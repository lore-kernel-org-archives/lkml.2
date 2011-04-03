Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab1DCKx4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 06:53:56 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:63667 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237Ab1DCKxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 06:53:55 -0400
Date: Sun, 3 Apr 2011 12:52:46 +0200
From: Alessandro Rubini <rubini@unipv.it>
To: nikai@nikai.net
Cc: rabin@rab.in, linus.walleij@stericsson.com,
        STEricsson_nomadik_linux@list.st.com, linux@arm.linux.org.uk,
        tglx@linutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: nomadik: avoid assigning u32 to bool
Message-ID: <20110403105246.GA11998@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Face: #Q;A)@_4.#>0+_%y]7aBr:c"ndLp&#+2?]J;lkse\^)FP^Lr5@O0{)J;'nny4%74.fM'n)M
	>ISCj.KmsL/HTxz!:Ju'pnj'Gz&.
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <20110403122611.4cca78b9@absol.kitzblitz>
References: <20110403122611.4cca78b9@absol.kitzblitz>
  <20110401235113.083787a7@absol.kitzblitz>
  <BANLkTinujPcSq86wjue+SGw5ZMiiLRaT_A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Why?  There are dozens of places in the kernel where this done, the code
>> generated should be the same, and it's pretty obvious what is being done
>> as it is.
> 
> Primarily because we were asked to avoid casts to bool even if
> they are safe.

[I have studied, meanwhile]

Actually the point of Rabin is, I think, that the patch is not needed.
Our "bool" is the C99 "_Bool" type, for which the compiler
automatically converts all non-0 assignments to 1.  Even if storage
is still one byte.

IIUC, the point of _Bool is allowing comparisong with "true", while in
general non-0 is considered true if evaluated in a conditional
but may be "!= 1" so "!= true" if compared explicitly.

You can compile a one-liner to check. I used a few more:

    _Bool i[10];

    int main(void)
    {
        i[0] = 1;
        i[1] = 10;
        return i[0];
    }

/alessandro
