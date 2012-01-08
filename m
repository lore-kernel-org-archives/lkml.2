Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab2AHB1F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 20:27:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64250 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab2AHB1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 20:27:03 -0500
Date: Sun, 8 Jan 2012 10:26:57 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Nadav Amit <nadav.amit@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: fix mov immediate emulation for 64-bit operands
Message-Id: <20120108102657.9a5dd6534ea4ae829073ff6e@gmail.com>
In-Reply-To: <C814BCA3-145A-410F-8F4F-CE5617DDB1A2@gmail.com>
References: <1325967346-12539-1-git-send-email-namit@cs.technion.ac.il>
	<E0EE2EE9-96C1-4354-BDCE-19E3AF2C0F30@gmail.com>
	<4F08AA3C.9090306@zytor.com>
	<C814BCA3-145A-410F-8F4F-CE5617DDB1A2@gmail.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Nadav Amit <nadav.amit@gmail.com> wrote: 
> On Jan 7, 2012, at 10:25 PM, H. Peter Anvin wrote:
> 
> > On 01/07/2012 12:21 PM, Nadav Amit wrote:
> >> MOV immediate instruction (opcodes 0xB8-0xBF) may take 64-bit operand.
> >> The previous emulation implementation assumes the operand is no longer than 32.
> >> 
> >> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> > 
> > There are exactly two such instructions: MOV immediate (B8-BF) and MOV
> > moff (A0-A3); you may want to check the latter too.
> > 
> > 	-hpa
> > 
> 
> These instructions (A0-A3) seem to be already covered by the decode_abs function.

Like these how about introducing a new flag and change the following entries in the
decode table to indicate possible 64bit immediate:

	/* 0xB8 - 0xBF */
	X8(I(DstReg | SrcImm | Mov, em_mov)),	

Checking the opcode byte at the operand decoding stage, like below, does not look nice:
	(IMO so better ask Avi)

+	if (size == 8 && ((ctxt->b & 0xF8) != 0xB8 || ctxt->twobyte))
		size = 4;

I am now cleaning up x86_decode_insn() to make each decoding stage clearer.

	Takuya
