Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab2IZXUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 19:20:46 -0400
Received: from nm20.bullet.mail.bf1.yahoo.com ([98.139.212.179]:41530 "HELO
	nm20.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750950Ab2IZXUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 19:20:45 -0400
X-Yahoo-Newman-Id: 589371.12461.bm@smtp111.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: TsgHMcMVM1kTTwkvdc9LuKZ6zjy.ah9PE8hk3yhy.Chu4yP
 mUCaCUOqF_fuaZEOrW8QhdOWYcrcNdXpR8eJDaTxSoD2oY7Z40C92Yaya2Lz
 _sVom4qtLqOIIDG4fHpR47FurHMcKkVgrfzm7H9CHdTzJflEsGUN2trntguP
 3vmJoFaXqHIjimzVRje6rCnDAsS293xqUtH8aTeOaRca2vbjdwcOS64V9K4s
 99ZUJxwMdxzUwcdeTt6a8wSmy24b1uLcwF5CHuoJ59hXD8GPzTMRbCIKGDGW
 CY9ULmv0pInLFV6mTtdj5HiWvNgcvEc9nsAbrmzONa7OpEpHruBz577c_aEI
 Jvu0jBQKEUfO3g_0CkK.QAEVBnI12.TCJglbPVgS6w5jkSXVc7fconTOal27
 4_vs8.JH7MT.qzW_tbu4n3v.HiozzVKZhW9v58CM_46lmbKPFkJ5oif9YC9v
 AXw3j4FY7j531pyuCLiQL7p3Ss_ja_aNO2MWR4rVKnxNQDym_UQqjAG4TNqR
 vhmP9taUe0ttfrAHm_w0zyi8Xnu0_FFms0hgGvIdgWBKVYxMdHvq7Eb.JAoe
 UyMNlsDaBUwt4T18G.J2mJm0BDU3.H.ViUpk366foCFwLyaan_Q--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <50638DCC.5040506@att.net>
Date: Wed, 26 Sep 2012 18:20:44 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        torvalds@linux-foundation.org
Subject: Please be aware that __always_inline doesn't mean "always inline"!
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've noticed that there's a lot of misperception about the meaning of
the __always_inline, or more specifically,
__attribute__((always_inline)), which does not actually cause the
function to always be inlined.  Rather, it *allows* gcc to inline the
function, even when compiling without optimizations.  Here is the
description of the attribute from gcc's docs
(http://gcc.gnu.org/onlinedocs/gcc-4.7.2/gcc/Function-Attributes.html)

always_inline
Generally, functions are not inlined unless optimization is specified.
For functions declared inline, this attribute inlines the function even
if no optimization level was specified.

This would even appear to imply that such functions aren't even marked
as "inline" (something I wasn't aware of until today).  The only
mechanism I'm currently aware of to force gcc to inline a function is
the flatten attribute (see https://lkml.org/lkml/2012/9/25/643) which
works backwards, you declare it on the calling function, and it forces
gcc to inline all functions (marked as inline) that it calls.

Daniel
