Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab2JWOfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 10:35:18 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63740 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab2JWOfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 10:35:16 -0400
Message-ID: <5086AB0B.7070402@gmail.com>
Date: Tue, 23 Oct 2012 07:34:51 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Dwiastika Peppy <dwiastikapeppy@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Linux Kernel
References: <CABTsxV5OCX=P8u-p6K4eoaAyWo-SGNcD0VxHkkFXOQu7r+Vs1g@mail.gmail.com>
In-Reply-To: <CABTsxV5OCX=P8u-p6K4eoaAyWo-SGNcD0VxHkkFXOQu7r+Vs1g@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2012 04:32 AM, Dwiastika Peppy wrote:
> Hai Justin. My name is Peppy
> I wanna ask you about installing Linux Kernel 2.6.27
> I'm a newbie in Linux user
> I got problem when installed Linux Kernel and this is the problem :
> *scripts/unifdef.c:209: error: conflicting types for ‘getline’
> /usr/include/stdio.h:651: note: previous declaration of ‘getline’ was here
> make[2]: *** [scripts/unifdef] Error 1
> make[1]: *** [__headers] Error 2
> make: *** [vmlinux] Error 2*
>
> what should i do to solve this problem?
> maybe you can help me..
> Thank you before Justin
>
> Best Regards,
>
>
> Peppy


from what I remember libc made the change then everything else had to be 
fixed. this commit is the commit which fixes it:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=d15bd1067b1fcb2b7250d22bc0c7c7fea0b759f7

but after thinking this over we probably should have done a
get_line || getline();
so old and new can always be working for people using older kernels and 
in the event of bisecting. but then again we might have more of a 
bloated kernel if we did this approach to _every_ function definition 
rename in the kernel.

anyway hope this helps with your build experience of the kernel.

Justin P. Mattock
