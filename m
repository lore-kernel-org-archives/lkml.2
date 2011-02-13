Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab1BMPOF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 10:14:05 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:54982 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab1BMPN6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 10:13:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Q4NIA+rJhGLoYix5KJQ2kt4tN+GmxKsj3o1FPzk7EErPk5dY6VNRCPcghlzcvwg260
         LfLB9to3iveRBtdR5UqGm1LHzEmnf3F7Lt+blaJ/4Zx5az9EV/GuCjAvBODORZUk3SnB
         ehJWxCNuzE9weMPMdMDSlcNON2fYyftFWzTsE=
MIME-Version: 1.0
In-Reply-To: <87tyg8j7le.fsf@mid.deneb.enyo.de>
References: <AANLkTikgfv+L9WS4s6n5mQcXWTzc6YMNUSsgBiAOmKbE@mail.gmail.com>
	<87aai1gdr7.fsf@mid.deneb.enyo.de>
	<4D5711E0.7020306@zytor.com>
	<87r5bcnwvw.fsf@mid.deneb.enyo.de>
	<AANLkTi=Ybzkp_NHom==M-kL+URWmmZ1LoWVP-EYMkN-j@mail.gmail.com>
	<87tyg8j7le.fsf@mid.deneb.enyo.de>
Date: Sun, 13 Feb 2011 07:13:57 -0800
Message-ID: <AANLkTin1cTCVNTiLS792ZkG9_Y5OvXCtDXHRFfY7hbSF@mail.gmail.com>
Subject: Re: X32 psABI status
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Florian Weimer <fw@deneb.enyo.de>
Cc: x32-abi@googlegroups.com, GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 13, 2011 at 7:07 AM, Florian Weimer <fw@deneb.enyo.de> wrote:
> * H. J. Lu:
>
>>> Actually, I'm wondering if you can do the translation in user space.
>>> There already are 32-on-64 implementations in existence, without
>>> kernel changes (recent Hotspot, LuaJIT, and probably some more).
>>
>> Please check out the x32 kernel source and provide feedback.
>
> I still don't understand why you need a separate syscall table.  You
> should really be able to run on an unmodified amd64 kernel, in 64 bit

That is done on purpose. x32 is designed for environments where the
current ia32 API is sufficient. You can think it as ia32 with register
extended to 64bit plus 8 more registers. Everything else is still 32bit.

> mode.  This would imply that tools like strace don't need any porting
> at all (you could just use the amd64 version), and even GDB would
> mostly worked unchanged.
>

Yes, strace needs to be updated. I have ported GDB to x32.


-- 
H.J.
