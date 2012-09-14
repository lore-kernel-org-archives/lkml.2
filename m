Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab2INMam (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 08:30:42 -0400
Received: from mout.perfora.net ([74.208.4.194]:53133 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635Ab2INMai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 08:30:38 -0400
Date: Fri, 14 Sep 2012 08:30:14 -0400
From: Jim Rees <rees@umich.edu>
To: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Cc: Jan Engelhardt <jengelh@inai.de>, "J. Bruce Fields" <bfields@fieldses.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] strings: helper for maximum decimal encoding of an
 unsigned integer
Message-ID: <20120914123014.GB29160@umich.edu>
References: <20120821212910.GD18637@fieldses.org>
 <alpine.LNX.2.01.1209100803060.22738@frira.zrqbmnf.qr>
 <1347614276.26071.15.camel@thorin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347614276.26071.15.camel@thorin>
X-Provags-ID: V02:K0:krHfhdhe6wLZ2pcr7AUOq+2vRcVFftfo76/IsA+nzMo
 AyZQzDlyHnJ2LdZCjV7J+cAMGtwIDnErCPsdeZgtRLchxL/b4i
 ws2EOd4ETO1t9uxjFAIVyMTX2Ltm0XLxlLzBSWWBzBWA3LSflc
 bS18zQdtUEbEhi8ltgca4goaWma1HoC9ode77kElgyr35sFvHz
 enyQcpTxarSG+xaTOWB7mNyn1qM86JMI2Q6BTHSIU1dUgRnJze
 9YiPUXHaXDXIZUI3/SrHAkTOo8Pc1fzDmDXGlJlyiPrEc72v1B
 kUgrfVJQ9tQt97TpBZb9CkL6GLEpYhktwm5uUNOcTzxtMY2VQ=
 =
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Petrovitsch wrote:

  On Mon, 2012-09-10 at 08:19 +0200, Jan Engelhardt wrote:
  > On Tuesday 2012-08-21 23:29, J. Bruce Fields wrote:
  [...]
  > >+/*
  > >+ * length of the decimal representation of an unsigned integer.  Just an
  > >+ * approximation, but it's right for types of size 1 to 36 bytes:
  > >+ */
  > >+#define base10len(i) (sizeof(i) * 24 / 10 + 1)
  > 
  > gcc provides... "interesting" features at times.
  > 
  > /* for unsigned "i"s */
  > #define base10len(i) ((const int[]){1,3,5,8,10,13,15,17,20}[i])
  
  Shouldn't that have been
  ----  snip ----
  #define base10len(i) ((const int[]){1,3,5,8,10,13,15,17,20}[sizeof(i)])
  ----  snip ----
  ?
  
  A pure K&R-C version would use a string:
  ----  snip ----
  #define base10len(i) "\0x1\0x3\0x5\0x8\0x0A\0x0D\0x0F\0x11\0x14"[sizeof(i)]
  ----  snip ----
  (if I converted them properly into hexadecimal) and that gives a "char"
  which is happily promoted to whatever one needs in that place.

1. That may give you a signed char on some architectures, which is not what
you want (although it doesn't matter since the values are all < 128)

2. If you put this in a .h, you'll get multiple copies of the array

3. No bounds checking (but in ninja K&R style you never check bounds)

4. Unreadable.

Pure K&R:

base10.h:
extern unsigned char base10len_vals[];
#define base10len(i) (base10len_vals[sizeof(i)])

base10.c:
unsigned char base10len_vals[] = {1,3,5,8,10,13,15,17,20};

But I still like my way better.
