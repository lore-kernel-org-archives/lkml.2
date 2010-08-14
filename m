Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab0HNV52 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 17:57:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756731Ab0HNV51 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 17:57:27 -0400
MIME-Version: 1.0
In-Reply-To: <201008141547.08722.edt@aei.ca>
References: <AANLkTimNborh0AtHkdnN-aCizDu4+S6ORmeoKzS_nEVH@mail.gmail.com>
 <201008141427.03946.edt@aei.ca> <AANLkTingwMvoVm_J6cmm_K3=G9rCYwOrQ=-5vK_wzGcX@mail.gmail.com>
 <201008141547.08722.edt@aei.ca>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 14 Aug 2010 14:56:58 -0700
Message-ID: <AANLkTinP3Kh4Gjnkx2ycr34W6SVqLsBh7yMsGuoU7pAD@mail.gmail.com>
Subject: Re: Linux 2.6.35.2
To: Ed Tomlinson <edt@aei.ca>
Cc: sedat.dilek@gmail.com, Greg KH <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>, penberg@kernel.org, arthur@psw.ro,
        wylda@volny.cz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 14, 2010 at 12:47 PM, Ed Tomlinson <edt@aei.ca> wrote:
> On Saturday 14 August 2010 14:47:45 Linus Torvalds wrote:
>>
>> Just to verify: you have CONFIG_HIGHPTE enabled on a x86-32 kernel,
>> right? I'd have expected this to not ever show up anywhere else, and
>> I'm just verifying that there isn't anything else going on. I'm
>> appending the commit message, the patch hasn't changed.
>
> No.  I have a x86-64 based kernel (amd64).

Hmm. On x86-64, pte_unmap() is a no-op. So moving it around should not
matter one whit. We don't even have a debug mode to turn it into some
kind of "check that we use it properly in an atomic region" which we
_could_ do.

Can you send me the messages you saw without that patch? There's
something odd going on here. I don't like the fact that the patch
apparently makes a difference for you. It shouldn't.

                     Linus
