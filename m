Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab0GNAEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 20:04:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51347 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab0GNAEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 20:04:04 -0400
X-User-Agent: K-9 Mail for Android
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: =?US-ASCII?Q?Re=3A_=5Bpatch_134/149=5D_x86=2C_paravirt=3A_Add_a?= =?US-ASCII?Q?_global_synchronization_point_=09for_pvclock?=
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 13 Jul 2010 17:02:42 -0700
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Palfrader <peter@palfrader.org>, Avi Kivity <avi@redhat.com>,
        Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Glauber Costa <glommer@redhat.com>,
        Zachary Amsden <zamsden@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Message-ID: <1600b961-b476-453d-9fd7-d98dbc8e5ed5@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I believe that's how it is actually implemented though, and I believe we'd have failures all over if that was not true.

"Jeremy Fitzhardinge" <jeremy@goop.org> wrote:

>On 07/13/2010 03:14 PM, H. Peter Anvin wrote:
>> Actually, I believe volatile operations (including asm volatile) are
>> strictly ordered *with respect to other volatile operations*. 
>
>The documentation makes no reference to that property; in fact it
>suggests it is outright not true:
>
>    Note that even a volatile `asm' instruction can be moved relative to
>    other
>    code, including across jump instructions.  For example, on many targets
>    there is a system register which can be set to control the rounding
>    mode of floating point operations.  You might try setting it with a
>    volatile `asm', like this PowerPC example:
>
>                asm volatile("mtfsf 255,%0" : : "f" (fpenv));
>                sum = x + y;
>
>    This will not work reliably, as the compiler may move the addition
>    back before the volatile `asm'.  To make it work you need to add an
>    artificial dependency to the `asm' referencing a variable in the
>    code you don't want moved, for example:
>
>             asm volatile ("mtfsf 255,%1" : "=X"(sum): "f"(fpenv));
>             sum = x + y;
>
>    Similarly, you can't expect a sequence of volatile `asm'
>    instructions to remain perfectly consecutive.
>    [...]
>    An `asm' instruction without any output operands will be treated
>    identically to a volatile `asm' instruction.
>
>>  As such I
>> would think we'd want to keep the "memory" clobber here, to make it
>> strictly ordered with regards to *all* memory operations.
>>   
>
>That would keep its overall effect consistent.
>
>    J

-- 
Sent from my mobile phone.  Please pardon any lack of formatting.
