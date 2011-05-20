Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023Ab1ETPEj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 11:04:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62254 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756937Ab1ETPEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 11:04:37 -0400
X-Authority-Analysis: v=1.1 cv=NmbQexcdgr4rtO3OwYGrP5Q3rTMpacrTPhuaXkv4uP8= c=1 sm=0 a=Tvs5BdieIDcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=jC6dt6rfuOzAHPnH57oA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH] extable: Make sure all archs define _sdata
From: Steven Rostedt <rostedt@goodmis.org>
To: Richard Henderson <rth@twiddle.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org,
        Hirokazu Takata <takata@linux-m32r.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>, Kyle McMartin <kyle@mcmartin.ca>,
        Helge Deller <deller@gmx.de>,
        "JamesE.J.Bottomley" <jejb@parisc-linux.org>
In-Reply-To: <4DD67A90.7010908@twiddle.net>
References: <1305855298.1465.19.camel@gandalf.stny.rr.com>
	 <4DD67A90.7010908@twiddle.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 20 May 2011 11:04:31 -0400
Message-ID: <1305903871.1465.22.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-20 at 07:28 -0700, Richard Henderson wrote:

> Although I suppose if we're supposedly standardizing on _sdata,
> the two uses of _data in arch/alpha/mm/ could be transitioned.
> 

If we start getting more uses of _sdata, then perhaps this would be a
good idea.

Currently I only need it to know if a pointer passed in to one of my
functions can be freed or not. If the pointer is pointing to a struct in
the core kernel data, it is safe from being freed. Anything else will
need the extra work to keep it safe (rcu logic and such) and takes a
path with a bit more overhead.

Thanks!

-- Steve


