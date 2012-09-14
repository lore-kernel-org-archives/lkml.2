Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab2INNTZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:19:25 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:2511 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751521Ab2INNTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:19:21 -0400
Subject: Re: [PATCH] strings: helper for maximum decimal encoding of an
 unsigned integer
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Jim Rees <rees@umich.edu>
Cc: Jan Engelhardt <jengelh@inai.de>, "J. Bruce Fields" <bfields@fieldses.org>,
        linux-kernel@vger.kernel.org
Date: Fri, 14 Sep 2012 15:18:12 +0200
In-Reply-To: <20120914123014.GB29160@umich.edu>
References: <20120821212910.GD18637@fieldses.org>
	 <alpine.LNX.2.01.1209100803060.22738@frira.zrqbmnf.qr>
	 <1347614276.26071.15.camel@thorin> <20120914123014.GB29160@umich.edu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1347628693.3813.7.camel@thorin>
Mime-Version: 1.0
X-DCC-URT-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fre, 2012-09-14 at 08:30 -0400, Jim Rees wrote:
> Bernd Petrovitsch wrote:
[...]  
>   A pure K&R-C version would use a string:
>   ----  snip ----
>   #define base10len(i) "\0x1\0x3\0x5\0x8\0x0A\0x0D\0x0F\0x11\0x14"[sizeof(i)]
>   ----  snip ----
>   (if I converted them properly into hexadecimal) and that gives a "char"
>   which is happily promoted to whatever one needs in that place.
> 
> 1. That may give you a signed char on some architectures, which is not what
> you want (although it doesn't matter since the values are all < 128)

And it depends on compiler options BTW.

But we can easily cast it:
#define base10len(i) ((unsigned char)"\x1\x3\x5\x8\xA\xD\xF\x11\x14"[sizeof(i)])

> 2. If you put this in a .h, you'll get multiple copies of the array

That depends on the compiler.

> 3. No bounds checking (but in ninja K&R style you never check bounds)

Well, I assumed that we don't use VLAs as parameter for the sizeof() so
the value is compile time known and the better C compilers can check it.
And then, there is no reason to store the string as such too.

[....]
> Pure K&R:

We can (and should) make it "const" too.

> base10.h:
> extern unsigned char base10len_vals[];
extern const unsigned char base10len_vals[];
> #define base10len(i) (base10len_vals[sizeof(i)])
> 
> base10.c:
> unsigned char base10len_vals[] = {1,3,5,8,10,13,15,17,20};
const unsigned char base10len_vals[] = {1,3,5,8,10,13,15,17,20};
> But I still like my way better.

The 8 wasted bytes probably do not matter ....

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

