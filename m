Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab2EKLk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 07:40:57 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:53615 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab2EKLkz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 07:40:55 -0400
MIME-Version: 1.0
In-Reply-To: <4FA787D5.6040508@redhat.com>
References: <1336324765.3638.4.camel@lappy> <4FA787D5.6040508@redhat.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Fri, 11 May 2012 13:40:34 +0200
Message-ID: <CA+1xoqf7W1WsEvMHCEUZjBHJVUCaefnGo9qxu0pttCtoUURseg@mail.gmail.com>
Subject: Re: kvm: KVM internal error. Suberror: 1
To: Avi Kivity <avi@redhat.com>
Cc: mtosatti@redhat.com, Dave Jones <davej@redhat.com>, kvm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 7, 2012 at 10:29 AM, Avi Kivity <avi@redhat.com> wrote:
> On 05/06/2012 08:19 PM, Sasha Levin wrote:
>> Hi all,
>>
>> During some fuzzing with trinity in a KVM guest running on qemu, I got the following error:
>>
>> KVM internal error. Suberror: 1
>> emulation failure
>> RAX=0000000000000000 RBX=ffff8800284108e0 RCX=0000000000000001 RDX=ffffffff84482008
>> RSI=1030000000000000 RDI=8180000000000000 RBP=ffff880028723d38 RSP=ffff880028723ce8
>> R8 =0000000000000206 R9 =fffffffff7e80206 R10=0000000000000000 R11=0000000000000000
>> R12=ffff880028410000 R13=ffffffff846ba1c0 R14=ffffffff84a74970 R15=0000000000009530
>> RIP=ffffffff8111c862 RFL=00010046 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
>> ES =0000 0000000000000000 ffffffff 00000000
>> CS =0010 0000000000000000 ffffffff 00a09b00 DPL=0 CS64 [-RA]
>> SS =0018 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
>> DS =0000 0000000000000000 ffffffff 00000000
>> FS =0000 00007f955873b700 ffffffff 00000000
>> GS =0000 ffff880035a00000 ffffffff 00000000
>> LDT=0000 0000000000000000 ffffffff 00000000
>> TR =0040 ffff880035bd2480 00002087 00008b00 DPL=0 TSS64-busy
>> GDT=     ffff880035a04000 0000007f
>> IDT=     ffffffff8436a000 00000fff
>> CR0=8005003b CR2=00007f5cfdad0518 CR3=000000001a154000 CR4=000407e0
>> DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000
>> DR6=00000000ffff0ff0 DR7=0000000000000400
>> EFER=0000000000000d01
>> Code=66 90 e8 7b 97 ff ff b8 01 00 00 00 eb 1c 0f 1f 40 00 31 c0 <83> 3d 97 9f c7 02 00 0f 95 c0 eb 0a 66 90 31 c0 66 0f 1f 44 00 00 48 8b 5d d8 4c 8b 65 e0
>> KVM internal error. Suberror: 1
>> emulation failure
>
> This is cmpl   $0x0,0x2c79f97(%rip) # 0xffffffff83d96800.  I don't
> understand why it failed, we do emulate cmp.  I'll try to write a unit
> test for it.
>
>
>> RAX=ffff88000d5f8000 RBX=ffff88000d600010 RCX=0000000000000001 RDX=0000000000000000
>> RSI=0000000000000001 RDI=ffff88000d5f8000 RBP=ffff88000d601ec8 RSP=ffff88000d601ec8
>> R8 =0000000000000001 R9 =0000000000000000 R10=0000000000000000 R11=0000000000000000
>> R12=ffffffff83fed960 R13=0000000000000000 R14=0000000000000000 R15=0000000000000000
>> RIP=ffffffff8107d696 RFL=00000286 [--S--P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
>> ES =0000 0000000000000000 ffffffff 00000000
>> CS =0010 0000000000000000 ffffffff 00a09b00 DPL=0 CS64 [-RA]
>> SS =0018 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
>> DS =0000 0000000000000000 ffffffff 00000000
>> FS =0000 0000000000000000 ffffffff 00000000
>> GS =0000 ffff880029800000 ffffffff 00000000
>> LDT=0000 0000000000000000 ffffffff 00000000
>> TR =0040 ffff8800299d2480 00002087 00008b00 DPL=0 TSS64-busy
>> GDT=     ffff880029804000 0000007f
>> IDT=     ffffffff8436a000 00000fff
>> CR0=8005003b CR2=00007fcfa03f9e9c CR3=0000000003a1c000 CR4=000407e0
>> DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000
>> DR6=00000000ffff0ff0 DR7=0000000000000400
>> EFER=0000000000000d01
>> Code=89 e5 fb c9 c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb f4 <c9> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 c9 c3 66 0f 1f 84 00 00 00 00 00 55 8b 07 48
>> KVM internal error. Suberror: 1
>> emulation failure
>> RAX=ffff88000d5db000 RBX=ffff88000d5ce010 RCX=0000000000000001 RDX=0000000000000000
>> RSI=0000000000000001 RDI=ffff88000d5db000 RBP=ffff88000d5cfec8 RSP=ffff88000d5cfec8
>> R8 =0000000000000001 R9 =0000000000000000 R10=0000000000000000 R11=0000000000000000
>> R12=ffffffff83fed960 R13=0000000000000000 R14=0000000000000000 R15=0000000000000000
>> RIP=ffffffff8107d696 RFL=00000286 [--S--P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
>> ES =0000 0000000000000000 ffffffff 00000000
>> CS =0010 0000000000000000 ffffffff 00a09b00 DPL=0 CS64 [-RA]
>> SS =0018 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
>> DS =0000 0000000000000000 ffffffff 00000000
>> FS =0000 0000000000000000 ffffffff 00000000
>> GS =0000 ffff88001b800000 ffffffff 00000000
>> LDT=0000 0000000000000000 ffffffff 00000000
>> TR =0040 ffff88001b9d2480 00002087 00008b00 DPL=0 TSS64-busy
>> GDT=     ffff88001b804000 0000007f
>> IDT=     ffffffff8436a000 00000fff
>> CR0=8005003b CR2=00007fcfa076b518 CR3=000000001a148000 CR4=000407e0
>> DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000
>> DR6=00000000ffff0ff0 DR7=0000000000000400
>> EFER=0000000000000d01
>> Code=89 e5 fb c9 c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb f4 <c9> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 c9 c3 66 0f 1f 84 00 00 00 00 00 55 8b 07 48
>>
>> The assembly doesn't quite make sense, and the fact that I got 3 of these in a row, makes me believe that it isn't an actual emulation error, but something else.
>>
>
> The assembly makes sense, it's sti; hlt; leaveq. What doesn't make sense
> is that we have to emulate leaveq - rsp and rbp point at normal memory
> as far as I can tell.
>
> The fact that it often happens after hlt makes me suspect interrupts are
> involved.  Please run this again with a trace so we so what happens
> prior to the error.

I wasn't able to reproduce this issue so far.
