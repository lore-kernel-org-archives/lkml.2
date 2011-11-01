Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab1KANpF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 09:45:05 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:57109 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753743Ab1KANpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 09:45:03 -0400
Subject: Re: powerpc 476, Little-endian, pte fault
From: Peter Bergner <bergner@vnet.ibm.com>
To: Santosh Kumar <santoshkumar.a@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
        Michael Neuling <mikey@neuling.org>, Ian Munsie <ianmunsi@au1.ibm.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAJw04pBpXsTS4=FeG5ZF3nqORXhiOZ=3V60cFCuJfgTiJcCh2g@mail.gmail.com>
References: <CAJw04pD24W_nGSLheWunCa_o7QqBmRf_TSAD44EkzazigRe_nQ@mail.gmail.com>
	 <12144.1320040276@neuling.org>
	 <CAJw04pAh5QDQMkUHbj9=rRPiUCZejimHiydCJFMAoZeSd_ydhA@mail.gmail.com>
	 <20440.1320054588@neuling.org> <1320060214.30202.34.camel@pasglop>
	 <CAJw04pBpXsTS4=FeG5ZF3nqORXhiOZ=3V60cFCuJfgTiJcCh2g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Nov 2011 08:44:34 -0500
Message-ID: <1320155074.2996.190.camel@otta>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
x-cbid: 11110113-7182-0000-0000-00000019E1D6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-01 at 08:32 +0530, Santosh Kumar wrote:
> I am using the same compiler as 476 & 440 instruction is almost the same.

Well the 476 implements ISA 2.05, which I think has added a fair amount
over the 440.  Not to mention the 476 core that has been released has
a FP unit.  I'll note that GCC has support for a 476 with and without
a FP unit, even though AFAIK, we only ship one with a FP unit.
The relevant options are -mcpu=476 (no FP unit) and -mcpu=476fp
(with FP unit).  Basically, -mcpu=476 is equivalent to
-mcpu=476fp -msoft-float.



> @@ -53,7 +58,12 @@
>         mullw   r10,r0,r4       # and get the remainder
>         add     r8,r8,r0
>         subf    r6,r10,r6
> +#ifdef CONFIG_INVADER
>  4:     stw     r7,0(r3)        # return the quotient in *r3
>         stw     r8,4(r3)
> +#else
> +4:     stw     r7,0(r3)        # return the quotient in *r3
> +       stw     r8,4(r3)
> +#endif
>         mr      r3,r6           # return the remainder in r3
>         blr

This looks like a typo, since you didn't actually swap the offsets
on the stw's like you did in all of the other patch hunks.


Peter



