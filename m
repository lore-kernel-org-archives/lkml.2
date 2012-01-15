Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab2AOPC1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 10:02:27 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44670 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab2AOPCZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 10:02:25 -0500
MIME-Version: 1.0
In-Reply-To: <4F12A2E4.6050304@redhat.com>
References: <1326566048-6756-1-git-send-email-namit@cs.technion.ac.il>
	<4F12A2E4.6050304@redhat.com>
Date: Sun, 15 Jan 2012 17:02:23 +0200
X-Google-Sender-Auth: x71kIsAK4EoHOSwWVNWFJxEo-Hs
Message-ID: <CAKLkAJ75xb=py0DxP6B6777z0muuyneoua-aBTuH9KnU-u5u+Q@mail.gmail.com>
Subject: Re: [PATCH] KVM: Fix MOVSX emulation
From: Nadav Amit <namit@cs.technion.ac.il>
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok. I will include MOVSXD as well in the future patch.

Regards,
Nadav

On Sun, Jan 15, 2012 at 11:56 AM, Avi Kivity <avi@redhat.com> wrote:
> On 01/14/2012 08:34 PM, Nadav Amit wrote:
>> The destination register of MOVSX should be decoded similarily to MOVZX.
>>
>> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
>> ---
>>  arch/x86/kvm/emulate.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>> index 05a562b..7644a83 100644
>> --- a/arch/x86/kvm/emulate.c
>> +++ b/arch/x86/kvm/emulate.c
>> @@ -3553,7 +3553,8 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
>>       case OpReg:
>>               decode_register_operand(ctxt, op,
>>                        op == &ctxt->dst &&
>> -                      ctxt->twobyte && (ctxt->b == 0xb6 || ctxt->b == 0xb7));
>> +                      ctxt->twobyte && ((ctxt->b & 0xfe) == 0xb6 ||
>> +                             (ctxt->b & 0xfe) == 0xbe));
>>               break;
>>       case OpImmUByte:
>>               rc = decode_imm(ctxt, op, 1, false);
>
> Please post a unit test for this.  See
> git://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git x86/emulate.c.
>
> --
> error compiling committee.c: too many arguments to function
>
