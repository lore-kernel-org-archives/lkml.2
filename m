Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472Ab0HDKPE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 06:15:04 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51465 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177Ab0HDKPD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 06:15:03 -0400
MIME-Version: 1.0
In-Reply-To: <20100804090049.GH5464@nb.net.home>
References: <AANLkTim6Bn++JaspY0cbpLLvi=MYBLNgUhARwKQkoYpE@mail.gmail.com> 
	<1280887483-2979-2-git-send-email-wad@chromium.org> <20100804090049.GH5464@nb.net.home>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 4 Aug 2010 12:14:45 +0200
Message-ID: <AANLkTin8eVm=_pw_DgP2wJW9pE0LgugqfXJE8aVXiH6R@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] genhd, efi: add efi partition metadata to 
	hd_structs
To: Karel Zak <kzak@redhat.com>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Jan Blunck <jblunck@suse.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 4, 2010 at 11:00, Karel Zak <kzak@redhat.com> wrote:
> On Tue, Aug 03, 2010 at 09:04:42PM -0500, Will Drewry wrote:
>> This change extends the partition_meta_info structure to
>> support EFI GPT-specific metadata and ensures that data
>> is copied in on partition scanning.
>
> Why do want to store GPT-specific data (efi_guid_t) to
> partition_meta_info? I think it would be better to use label and uuid
> in a generic format (e.g. string or u8 uuid[16]) -- then you don't
> have to use things like union, disklabel specific code to compare
> uuids, etc.  IMHO your current code is too complicated.

I don't mind having the raw data and the type accessible. It might be
useful for something we don't know about and it basically comes for
free.

But the only thing we are really interested in is the UUID, which,
like Tejun already suggested, we should probably store
format-independent, and have it always accessible. That way, we would
not need any type-specific parser, we just handle the normal DCE
format.

I don't think we should support any of the labels anyway in root= and
similar, because they never really worked reliably with duplicates,
and just ask for trouble.

Kay
