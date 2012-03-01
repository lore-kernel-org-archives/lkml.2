Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab2CAOrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 09:47:14 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:47851 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932069Ab2CAOrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 09:47:13 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArwBAKU/KE8Y9geI/2dsb2JhbAAMgVOCPaQnl02GTIErg2eBBwSGUJhU
X-IronPort-AV: E=Sophos;i="4.73,1,1325480400"; 
   d="scan'208";a="165364451"
Message-ID: <4F4F8BEE.3040806@teksavvy.com>
Date: Thu, 01 Mar 2012 09:47:10 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.3-rc5
References: <CA+55aFytp=ZT++sj_P7nw9mNSKjPaqjB4srgSB6HYAAJW04-Pw@mail.gmail.com> <4F4B9FFE.5050709@teksavvy.com> <CA+55aFxMPOAdvu-iFL8vDzC=d1osVD91RfksLiE4sAP5Lf5oNQ@mail.gmail.com>
In-Reply-To: <CA+55aFxMPOAdvu-iFL8vDzC=d1osVD91RfksLiE4sAP5Lf5oNQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-02-28 01:30 PM, Linus Torvalds wrote:
> On Mon, Feb 27, 2012 at 7:23 AM, Mark Lord <kernel@teksavvy.com> wrote:
>>
>> The i8k driver is still b0rked for COMPAT use in linux-3.2.xx,
>> and I don't think my patch got picked up by anyone for 3.3 yet:
>
> I really don't like your patch.
..

Heh, I think we agree on that point.  I hate it.  :)

> Quite frankly, I think the right solution is to fix the kernel
> interface to the right type (int) that is the same. But because we
> don't want to change the user interface, let's make the kernel
> *accept* the 8-byte entity and just change it into a 4-byte size, and
> leave the user-space visible ioctl numbers the same broken crap - it's
> not like the other ioctl numbers had the right size *either*...
>
> IOW, have something like the attached in the ioctl handler (and then
> we need to also add the compat handler, as in your patch).
>
> Does this (with your compat_ioctl wrapper addition) also work for you?


It's close (after adding a missing left-paren), but not 100% working yet.
In particular, this command fails to get valid data:  i8kctl bios

    ioctl(3, I8K_BIOS_VERSION, 0xbfc543c8)  = -1 EINVAL (Invalid argument)

That's the original issue I first noticed which prompted me to try
and get things to roughly behave again.

I think all (or at least most) of the other ioctls appear to be working though.
