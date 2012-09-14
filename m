Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383Ab2INJUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 05:20:12 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:1950 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754820Ab2INJUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 05:20:10 -0400
Subject: Re: [PATCH] strings: helper for maximum decimal encoding of an
 unsigned integer
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Jan Engelhardt <jengelh@inai.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-kernel@vger.kernel.org,
        Jim Rees <rees@umich.edu>
Date: Fri, 14 Sep 2012 11:17:54 +0200
In-Reply-To: <alpine.LNX.2.01.1209100803060.22738@frira.zrqbmnf.qr>
References: <20120821212910.GD18637@fieldses.org>
	 <alpine.LNX.2.01.1209100803060.22738@frira.zrqbmnf.qr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1347614276.26071.15.camel@thorin>
Mime-Version: 1.0
X-DCC-URT-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Kind regards,
	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at


