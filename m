Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab2CBARv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 19:17:51 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:13662 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751266Ab2CBARu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 19:17:50 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArwBAKU/KE8Y9geI/2dsb2JhbAAMgVOCPaQnl02GTIErg2eBBwSGUJhU
X-IronPort-AV: E=Sophos;i="4.73,1,1325480400"; 
   d="scan'208";a="165462774"
Message-ID: <4F5011AC.2020909@teksavvy.com>
Date: Thu, 01 Mar 2012 19:17:48 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.3-rc5
References: <CA+55aFytp=ZT++sj_P7nw9mNSKjPaqjB4srgSB6HYAAJW04-Pw@mail.gmail.com> <4F4B9FFE.5050709@teksavvy.com> <CA+55aFxMPOAdvu-iFL8vDzC=d1osVD91RfksLiE4sAP5Lf5oNQ@mail.gmail.com> <4F4F8BEE.3040806@teksavvy.com> <CA+55aFyij_ORw+BE-Sbkt9Y9qcUQSmW_4e-r7p3t0DNA4Sg9pA@mail.gmail.com>
In-Reply-To: <CA+55aFyij_ORw+BE-Sbkt9Y9qcUQSmW_4e-r7p3t0DNA4Sg9pA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-03-01 11:22 AM, Linus Torvalds wrote:
> On Thu, Mar 1, 2012 at 6:47 AM, Mark Lord <kernel@teksavvy.com> wrote:
>>
>> It's close (after adding a missing left-paren), but not 100% working yet.
>> In particular, this command fails to get valid data:  i8kctl bios
>>
>>    ioctl(3, I8K_BIOS_VERSION, 0xbfc543c8)  = -1 EINVAL (Invalid argument)
>
> Hmm. That makes no sense.

No, that was my misinterpretation.
The BIOS_VERSION call is broken for different reasons,
and my original all-inclusive patch has a fix for it too.  :)

> Does *this* work? And if not, can you do an strace, but use the "-e
> raw=ioctl" option to make it show the ioctl numbers as raw hex to
> verify..

Here's a go, 64-bit kernel (3.2.8), 32-bit userspace:

Dell laptop SMM driver v1.14 21/02/2005 Massimo Dal Zotto (dz@debian.org)
ioctl32(i8kctl:1474): Unknown cmd fd(3) cmd(80046980){t:'i';sz:4} arg(ff8b1fd8)
on /proc/i8k
ioctl32(i8kctl:1475): Unknown cmd fd(3) cmd(c0046986){t:'i';sz:4} arg(ff90ed5c)
on /proc/i8k
ioctl32(i8kctl:1475): Unknown cmd fd(3) cmd(c0046986){t:'i';sz:4} arg(ff90ed5c)
on /proc/i8k

I'll reboot/redo that again with strace shortly.
