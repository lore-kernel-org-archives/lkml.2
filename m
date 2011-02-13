Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab1BMP5l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 10:57:41 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37852 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab1BMP5h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 10:57:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YmeqUqzaeyrDJrxHskzAzM5qYFgkOI7ncP1ZHBqVQMrc27xZR7RNGnYQU0d+bBMn8A
         O5IlzPGRHPlDBcWN/hpqYWRr973N2PeFP1dsir7AxqRGvrQ773ioAWuHCv0Th7d7j6W/
         0QZtq4cdXDvxb81u4aVULT2zC7qMC2znd4Mzc=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1102131514250.31425@eddie.linux-mips.org>
References: <AANLkTikgfv+L9WS4s6n5mQcXWTzc6YMNUSsgBiAOmKbE@mail.gmail.com>
	<87aai1gdr7.fsf@mid.deneb.enyo.de>
	<4D5711E0.7020306@zytor.com>
	<87r5bcnwvw.fsf@mid.deneb.enyo.de>
	<AANLkTi=Ybzkp_NHom==M-kL+URWmmZ1LoWVP-EYMkN-j@mail.gmail.com>
	<87tyg8j7le.fsf@mid.deneb.enyo.de>
	<alpine.LFD.2.00.1102131514250.31425@eddie.linux-mips.org>
Date: Sun, 13 Feb 2011 07:57:36 -0800
Message-ID: <AANLkTimkm2ntT304aJXLPoBBg4Yvk0HmQNCV_bzTnocv@mail.gmail.com>
Subject: Re: X32 psABI status
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Florian Weimer <fw@deneb.enyo.de>, x32-abi@googlegroups.com,
        GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 13, 2011 at 7:43 AM, Maciej W. Rozycki <macro@linux-mips.org> wrote:
> On Sun, 13 Feb 2011, Florian Weimer wrote:
>
>> >> Actually, I'm wondering if you can do the translation in user space.
>> >> There already are 32-on-64 implementations in existence, without
>> >> kernel changes (recent Hotspot, LuaJIT, and probably some more).
>> >
>> > Please check out the x32 kernel source and provide feedback.
>>
>> I still don't understand why you need a separate syscall table.  You
>> should really be able to run on an unmodified amd64 kernel, in 64 bit
>> mode.  This would imply that tools like strace don't need any porting
>> at all (you could just use the amd64 version), and even GDB would
>> mostly worked unchanged.
>
>  For the record -- I suggested a similar approach for n32 MIPS too (back
> when it was on the table), but people rejected it deciding it was easier
> for them to add a separate syscall table (for a change).  It was perhaps
> even more surprising as any MIPS 32-bit user pointer is a valid 64-bit one
> too (I suspect this is also the case with x86-64) and any simple type,
> including pointers and the "long long" type (such as used with lseek64(2),
> etc.) goes into a single 64-bit register or stack slot with both ABIs, so
> any conversion layer (boundary checks or whatever; structures can be
> sorted out with padding) in libc would be pretty thin.

x32 is the same 64bit kernel interface for system calls which takes 64bit
arguments.  You can pass either 32bit or 64bit value to them.

-- 
H.J.
