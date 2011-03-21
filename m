Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab1CUKwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 06:52:07 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34624 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab1CUKwF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 06:52:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lkeL8aGKQb6bYxLVAhggBvrJvezfBw7wWRm+j+tDyMA9a7vULq5MBIzVvLJbedvOYx
         Jol8BLb9RG94sYqyf+7AJ0kcJIeJ4JVZ6OzczZmKvlkhHeEfLfYMGaAOao6Bn0xnMciZ
         3G/VfKDa878Xq0Fi7JOmToSPHzklyFmV6G1Ng=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1103210907530.20892@wotan.suse.de>
References: <AANLkTik53Ss4hk3_nproctYLX0=imnt4HOt=pGV5idcU@mail.gmail.com>
	<201103210108.49780.vapier@gentoo.org>
	<AANLkTikSJDGEWCqazvAKHUC8_MoOP-+vyFOjyCmrA9dL@mail.gmail.com>
	<201103210153.10145.vapier@gentoo.org>
	<AANLkTimxWQZvtpe374Yju0O9BDMxDfBHsc1y3+c=M7D+@mail.gmail.com>
	<Pine.LNX.4.64.1103210907530.20892@wotan.suse.de>
Date: Mon, 21 Mar 2011 03:52:04 -0700
Message-ID: <AANLkTikYxVzFjLQFNvEy2FBmuO76PJPA5JuLgoUGzPF0@mail.gmail.com>
Subject: Re: X32 psABI status update
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Michael Matz <matz@suse.de>
Cc: Mike Frysinger <vapier@gentoo.org>, libc-alpha@sourceware.org,
        GCC Development <gcc@gcc.gnu.org>, LKML <linux-kernel@vger.kernel.org>,
        x32-abi@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 1:20 AM, Michael Matz <matz@suse.de> wrote:
> Hi,
>
> On Sun, 20 Mar 2011, H.J. Lu wrote:
>
>> I don't think it will help x32 and I think it will make it harder to add
>> x32 support. I still want to see a real usage before I add it.
>
> % cat real-world.c
> /* intptr_t; what's that? */
> union space_saving_htab_element {
>  void *generic_pointer;
>  /* Usually we need a long for a pointer, but I just figured out
>     that on x32 an int is enough and smaller.  My program
>     now needs half as much memory, supi!  */
> #ifdef __x32__
>  unsigned int as_number;
> #else
>  unsigned long as_number;
> #endif
> };

That is the wrong way to support x32.  You should remove "#ifdef __x32__",
which only shows __x32__ shouldn't be used/needed.

>
> Ciao,
> Michael.
> PS: Of course you and I wouldn't write such code, but Mikes point was that
> there might be some that do.  I could probably construct an example where
> it would matter for real involving inline asm that for some reason has to
> slightly differ depending on x32-ness.
>

I  am still waiting for a real example.

-- 
H.J.
