Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab2APA2x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 19:28:53 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:39919 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab2APA2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 19:28:52 -0500
X-AuditID: b753bd60-99661ba00000359c-c0-4f136f401617
X-AuditID: b753bd60-99661ba00000359c-c0-4f136f401617
Message-ID: <4F136F14.9050107@hitachi.com>
Date: Mon, 16 Jan 2012 09:28:04 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Ulrich Drepper <drepper@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        pp-manager@sdl.hitachi.co.jp
Subject: Re: Typo transferred from Intel manual
References: <CAOPLpQc_TfvtfJ0NL+4fsi2r_eW+4qWX+WbXrZ9BjGn44nAmBw@mail.gmail.com>
In-Reply-To: <CAOPLpQc_TfvtfJ0NL+4fsi2r_eW+4qWX+WbXrZ9BjGn44nAmBw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulrich,

(2012/01/14 7:24), Ulrich Drepper wrote:
> The arch/x86/lib/x86-opcode-map.txt file contains the line
> 
> af: SCAS/W/D/Q rAX,Xv
> 
> 
> This is what the Intel manuals show, but it's not correct.  The 'X' stands for
> 
> Memory addressed by the DS:rSI register pair (for example, MOVS, CMPS,
> OUTS, or LODS).
> 
> 
> On the other hand 'Y' means (also see the ae byte entry for SCASB):
> 
> Memory addressed by the ES:rDI register pair (for example, MOVS, CMPS,
> INS, STOS, or SCAS).

I see, thanks for reporting :)

> Hence the following patch should be applied:

Could you add a comment line above the fix in x86-opcode-map.txt?
I just consider the case that someone may confuse the fix itself
is typo.

Thank you!

> 
> 
> Signed-off-by: Ulrich Drepper <drepper@gmail.com>
> 
> diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
> index 5b83c51..c292885 100644
> --- a/arch/x86/lib/x86-opcode-map.txt
> +++ b/arch/x86/lib/x86-opcode-map.txt
> @@ -219,7 +219,7 @@ ab: STOS/W/D/Q Yv,rAX
>  ac: LODS/B AL,Xb
>  ad: LODS/W/D/Q rAX,Xv
>  ae: SCAS/B AL,Yb
> -af: SCAS/W/D/Q rAX,Xv
> +af: SCAS/W/D/Q rAX,Yv
>  # 0xb0 - 0xbf
>  b0: MOV AL/R8L,Ib
>  b1: MOV CL/R9L,Ib
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
