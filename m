Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab2BUCrL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 21:47:11 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:49172 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab2BUCrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 21:47:09 -0500
X-AuditID: cbfee610-b7b53ae000003b1c-cd-4f4300124b32
Date: Tue, 21 Feb 2012 02:23:14 +0000 (GMT)
From: Jongman Heo <jongman.heo@samsung.com>
Subject: Re: Re: [PATCH v2 3/3] i387: support lazy restore of FPU state
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: jongman.heo@samsung.com
MIME-version: 1.0
X-MTR: 20120221022114248@jongman.heo
Msgkey: 20120221022114248@jongman.heo
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120221022114248@jongman.heo
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <29057119.98761329790991208.JavaMail.weblogic@epml01>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1L2lJ0b015862


> Sender : Linus Torvalds<torvalds@linux-foundation.org>
> Date : 2012-02-21 11:18 (GMT+09:00)
> Title : Re: [PATCH v2 3/3] i387: support lazy restore of FPU state
> 
> On Mon, Feb 20, 2012 at 6:10 PM, Linus Torvalds
> wrote:
> >
> > The attached trivial patch fixes it, I bet.
> 
> Actually, it doesn't fix it on x86-32, because we actually have an
> #ifdef CONFIG_X86_64 around the "current_task" definition due to
> pointless differences in how we do that on x86-64 and x86-32.
> 
> So much for the "common" part of "arch/x86/kernel/cpu/common.c"
> 
> > Although I do wonder if we should just make kernel_fpu_begin() be a
> > real function instead of inlining it. I'm not sure it makes sense to
> > inline that thing, and it might be better to export that one instead.
> 
> I do think that would be better in the long run, but for now here's an
> updated "trivial" patch to fix it.
> 
> I want the fpu_owner_task to be declared next to the cache-hot
> task-switching stuff, and since they are different on 32-bit and
> 64-bit (for no really good reason), that gets duplicated too. Sad.
> 
>                         Linus
> 
>                       Linus

Yeah, this patch fixes my x86-32 build.

Thanks,
Jongman Heo.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
