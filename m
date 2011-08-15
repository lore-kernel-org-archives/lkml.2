Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab1HOTEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 15:04:44 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46249 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab1HOTEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 15:04:42 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MWsHKnEwstzc-QQNXZZfFKR31RP0sdQmHmhgvdfrWXP-Q@mail.gmail.com>
References: <CACqU3MU2pjcqgYDjn=S2asdLamU0mity+kLizH_mbTtJU5Fh2A@mail.gmail.com>
	<1313341346-15605-1-git-send-email-lacombar@gmail.com>
	<4E48FB04.9010903@suse.cz>
	<CACqU3MWsHKnEwstzc-QQNXZZfFKR31RP0sdQmHmhgvdfrWXP-Q@mail.gmail.com>
Date: Mon, 15 Aug 2011 15:04:40 -0400
Message-ID: <CACqU3MUDe7kcRx-N8ZPiPU6fcFEYDA1zECgUZxCneLE71fGPzg@mail.gmail.com>
Subject: Re: IS_ENABLED() and non-available symbols
From: Arnaud Lacombe <lacombar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Rabin Vincent <rabin@rab.in>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Aug 15, 2011 at 10:52 AM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> [...]
> I'd be interested to also know the cost of all those new symbols on
> build time...
>
here it is; on the parsing itself:

After 1000 iteration of:
% /usr/libexec/gcc/x86_64-redhat-linux/4.5.1/cc1 -E -quiet -v -include
include/generated/autoconf.h /dev/null -o /dev/null -mtune=generic
-march=x86-64 2>/dev/null

x include.before
+ include.after
+--------------------------------------------------------------------------+
| x  x x  x  x x                                  +  + +  +  + +  +  +    +|
||MA_|                                             |_A_|                   |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x 1000         0.016         0.021         0.016       0.01637 0.00077310911
+ 1000         0.034         0.043         0.035      0.035227 0.00076161083
Difference at 95.0% confidence
        0.018857 +/- 6.7264e-05
        115.192% +/- 0.410898%
        (Student's t, pooled s = 0.000767382)

After 1000 successive build of `init/main.o' (directly calling gcc):

x include.before
+ include.after
+--------------------------------------------------------------------------+
|     xxxxx**++++++                +              +                        |
|     xxxxx***+++++        x      ++       x      +            +           |
|     xxxxx***++*+++ +x+   x  x  x++ x   + x+   ++*  x     x   *           |
|     xxxxx****+*++**+**+*+*x x*xx*++*x++*+**x+ *+* +x *++x*  x*++ +      +|
||____|_A___M_A|_____|                                                     |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x 1000         0.628         0.835         0.631      0.636217   0.024724466
+ 1000         0.648         0.873         0.651      0.657341   0.026185882
Difference at 95.0% confidence
        0.021124 +/- 0.00223216
        3.32025% +/- 0.350849%
        (Student's t, pooled s = 0.0254657)

Now, an `allyesconfig' take about 5h30 hours to complete on my  Core2
T5670 (capped at 1.2GHz), so this patch would cost an extra 10min.
Still significant, but not too much :-)

 - Arnaud
