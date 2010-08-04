Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900Ab0HDOpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 10:45:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51316 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932591Ab0HDOpW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 10:45:22 -0400
MIME-Version: 1.0
In-Reply-To: <19545.30920.745148.710816@stoffel.org>
References: <AANLkTin3+LfXOpW5MsPSgs_5Z0UFnQTwBAXSocrU1Xs8@mail.gmail.com>
	<1280871336-31046-2-git-send-email-wad@chromium.org>
	<AANLkTimX-5v4qNeK1DD84n8z6-jpq8DSvCa5PepuhgM5@mail.gmail.com>
	<AANLkTik4DRO3685HG8-Hkp3=s=vinUdTQ=votQuf4-8N@mail.gmail.com>
	<AANLkTim6Bn++JaspY0cbpLLvi=MYBLNgUhARwKQkoYpE@mail.gmail.com>
	<19545.30920.745148.710816@stoffel.org>
Date: Wed, 4 Aug 2010 09:45:22 -0500
Message-ID: <AANLkTimsSJSGLrwbJ05F9dqvvB2GxpE5a+T4J4pTGH6r@mail.gmail.com>
Subject: Re: [PATCH 2/2] genhd, efi: add efi partition metadata to hd_structs
From: Will Drewry <wad@chromium.org>
To: John Stoffel <john@stoffel.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Karel Zak <kzak@redhat.com>,
        Tejun Heo <tj@kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 4, 2010 at 9:27 AM, John Stoffel <john@stoffel.org> wrote:
>>>>>> "Kay" == Kay Sievers <kay.sievers@vrfy.org> writes:
>
> Kay> On Wed, Aug 4, 2010 at 00:27, Will Drewry <wad@chromium.org> wrote:
>>> On Tue, Aug 3, 2010 at 4:54 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
>
>>>> Did you already test to put a lookup-call to the in-kernel mounter, if
>>>> we use some special partition table uuid identifier for root=? That
>>>> would be nice to see, if all that works as expected, and we can get to
>>>> the data we collect.
>>>
>>> Not yet, but I'd like to have it working there (and in my
>>> device-mapper target) as soon as possible.  Hopefully, I'll have that
>>> done pretty soon and I'll repost the series inclusive of an init:
>>> change.
>
> Kay> Nice.
>
>>> Any preferences on the variable? I'll start with your example of
>>> PARTUUID=, but that follows the initramfs model (UUID=) and not the
>>> existing magic root devices (/dev/nfs, /dev/ram).
>>> /dev/by-part-uuid/XXX... doesn't seem super-friendly though :)
>
> Kay> Yeah, this stuff does not really fit in to the path notation
> Kay> stuff, unless we use the udev-style link names, which some people
> Kay> like to avoid, and prefer some more abstract thing here.
>
> Kay> We have UUID=, LABEL= for mount and fstab, I think PARTUUID=,
> Kay> PARTLABEL= matches this.
>
> Ugh, why do we care whether a UUID refers to a disk or a partition?
> It should be unique no matter what, so just do /dev/uuid/XXXX and call
> it done.

Since these are supposed to be _unique_ it seems that any reference to
a uuid should be fair game.  And if a root=/dev/uuid/XXX makes it to
an initramfs environment, then that'll be able to easily check if the
UUID refers to a filesystem uuid or not.

I can roll that into the next version unless there's specific complaints.
