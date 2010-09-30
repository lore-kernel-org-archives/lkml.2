Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab0I3TUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 15:20:52 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43368 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647Ab0I3TUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 15:20:51 -0400
MIME-Version: 1.0
In-Reply-To: <1285851024.748.97.camel@marc>
References: <4CA391B3.1030806@wol.de> <20100930103010.1a6a7785@lxorguk.ukuu.org.uk>
 <1285843077.748.32.camel@marc> <AANLkTi=d+5uDVK9RHguSmwFhKLVUPXvzo=G3s=NKKDW3@mail.gmail.com>
 <20100930122928.19e5ee84@lxorguk.ukuu.org.uk> <1285851024.748.97.camel@marc>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 30 Sep 2010 21:20:29 +0200
Message-ID: <AANLkTimRa9VsOgSkcdrg=41pskEbMhNL4D9SXeV3dztG@mail.gmail.com>
Subject: Re: [PATCH] Fix capi devicenames
To: "Marc - A. Dahlhaus" <mad@wol.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        isdn@linux-pingi.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

n Thu, Sep 30, 2010 at 14:50, Marc - A. Dahlhaus <mad@wol.de> wrote:
> Am Donnerstag, den 30.09.2010, 12:29 +0100 schrieb Alan Cox:
>> > In any case devices.txt should be fixed, it has not much to do with
>> > the real world.
>>
>> If some distros chose not to follow devices.txt that is their problem.
>>
>> devices.txt is the specification, and its ABI.
>>
>> It is fixed and the kernel behaviour is to follow it. Those who didn't
>> follow it, or who didn't propose a change back when it was specified in
>> the first place have only themselves to blame.
>>
>> It isn't changing, and the ISDN code should follow the spec.
>>
>> How you sort out your userspace is a problem for those who dug holes and
>> jumped down them.
>
> Well, i doubt that any distro or hand crafted setup out there is using
> anything else than the /dev/capi20 and /dev/capi/[0-9]+ devices for capi
> interaction. Because the userspace (libcapi20 & capiinit) handle just
> this devices. (i checked debian/ubuntu, fedora rawhide and gentoo and
> all are not using other device node names...)

devices.txt is just bogus in this case and states stuff which was
never used in the real world. But you don't need to touch it. Just add
the naming hints (char *(*devnode)) to the capi class and nothing will
change, the device names in /sys and everywhere else will stay as they
are today, just devtmpfs and udev will create the right device nodes
out of the kernel supplied additional information. We did this for the
rest of the kernel the same way.

Kay
