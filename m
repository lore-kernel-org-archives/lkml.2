Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab2AHOFk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 09:05:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab2AHOFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 09:05:39 -0500
Message-ID: <4F09A2A0.1060801@redhat.com>
Date: Sun, 08 Jan 2012 16:05:20 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Nadav Amit <nadav.amit@gmail.com>
CC: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: fix mov immediate emulation for 64-bit operands
References: <1325967346-12539-1-git-send-email-namit@cs.technion.ac.il> <E0EE2EE9-96C1-4354-BDCE-19E3AF2C0F30@gmail.com> <4F08AA3C.9090306@zytor.com> <C814BCA3-145A-410F-8F4F-CE5617DDB1A2@gmail.com> <20120108102657.9a5dd6534ea4ae829073ff6e@gmail.com> <CAKLkAJ4=eT7TdZoOkQKMnhmrESq5kvCQL3Mw52a35gu2yWsNgw@mail.gmail.com>
In-Reply-To: <CAKLkAJ4=eT7TdZoOkQKMnhmrESq5kvCQL3Mw52a35gu2yWsNgw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2012 10:47 AM, Nadav Amit wrote:
> On Sun, Jan 8, 2012 at 3:26 AM, Takuya Yoshikawa
> <takuya.yoshikawa@gmail.com> wrote:
> > Hi,
> >
> > Nadav Amit <nadav.amit@gmail.com> wrote:
> >> On Jan 7, 2012, at 10:25 PM, H. Peter Anvin wrote:
> >>
> >> > On 01/07/2012 12:21 PM, Nadav Amit wrote:
> >> >> MOV immediate instruction (opcodes 0xB8-0xBF) may take 64-bit operand.
> >> >> The previous emulation implementation assumes the operand is no longer than 32.
> >> >>
> >> >> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> >> >
> >> > There are exactly two such instructions: MOV immediate (B8-BF) and MOV
> >> > moff (A0-A3); you may want to check the latter too.
> >> >
> >> >     -hpa
> >> >
> >>
> >> These instructions (A0-A3) seem to be already covered by the decode_abs function.
> >
> > Like these how about introducing a new flag and change the following entries in the
> > decode table to indicate possible 64bit immediate:
> >
> >        /* 0xB8 - 0xBF */
> >        X8(I(DstReg | SrcImm | Mov, em_mov)),
> >
> > Checking the opcode byte at the operand decoding stage, like below, does not look nice:
> >        (IMO so better ask Avi)
> >
> > +       if (size == 8 && ((ctxt->b & 0xF8) != 0xB8 || ctxt->twobyte))
> >                size = 4;
> >
>
> I agree. I remembered these flags are expensive (from the time flags
> were set in u32).
> I guess I can add OpImm64.
> Another less preferable alternative is to add a misc. flag or reuse
> another flag.
>
> Avi, please acknowledge adding OpImm64.

Yes, OpImm64 is the cleanest IMO.  Note it doesn't even cost us a bit.

-- 
error compiling committee.c: too many arguments to function

