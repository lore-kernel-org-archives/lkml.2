Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab1BJBco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 20:32:44 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47558 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab1BJBcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 20:32:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=HxAJhARs/MWihcQrvXSoKdT4HMyrJ/Vo/Nsv3d/+m/BqaG692++GHXFwI/637oxB43
         vx1xP3Yo8We6irmsknvVronMPtWK7fu01AkeNULnQ6SApByG0O47r7/HfwI0J4RK/zbg
         2jtwORYcuK91L9Oas/I/CcTCELCVwCFJ8AFA0=
MIME-Version: 1.0
In-Reply-To: <20110209.150514.115926470.davem@davemloft.net>
References: <AANLkTikA3MT=eeMKg58HyYZRswUR+PMhYW978HEc0sst@mail.gmail.com>
	<4D5315FB.8020004@zytor.com>
	<AANLkTimN2oM6E9E34fMffgtH81ZfYcGj6J5nnjGrxGfA@mail.gmail.com>
	<20110209.150514.115926470.davem@davemloft.net>
Date: Wed, 9 Feb 2011 20:32:39 -0500
Message-ID: <AANLkTinbLbdPDS-MaSQ3b2BP_ykERx6EfBoJuD0ZxWdr@mail.gmail.com>
Subject: Re: Can anyone explain "movl %eax %eax"?
From: Jidong Xiao <jidong.xiao@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you David and Peter.

And I found more information in the following website, other people
who are not very clear can have a look at this document:

http://www.x86-64.org/documentation/assembly.html

======================
Implicit zero extend

Results of 32-bit operations are implicitly zero extended to 64-bit
values. This differs from 16 and 8 bit operations, that don't affect
the upper part of registers. This can be used for code size
optimisations in some cases, such as:

  movl $1, %eax                 # one byte shorter movq $1, %rax
  xorq %rax, %rax		# three byte equivalent of mov $0,%rax
  andl $5, %eax			# equivalent for andq $5, %eax
======================

Regards
Jidong

On Wed, Feb 9, 2011 at 6:05 PM, David Miller <davem@davemloft.net> wrote:
> From: Jidong Xiao <jidong.xiao@gmail.com>
> Date: Wed, 9 Feb 2011 18:02:09 -0500
>
>> Oh, I see. Thank you. So similarly, the operation "xorl %eax,%eax" is
>> used for the same reason, right? I see that appears in more files.
>
> The xorl clears the entire register.
>
