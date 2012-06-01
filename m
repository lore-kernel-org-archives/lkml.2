Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003Ab2FABIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 21:08:36 -0400
Received: from nm11-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.240]:48705 "HELO
	nm11-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932977Ab2FABIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 21:08:35 -0400
X-Yahoo-Newman-Id: 995292.39282.bm@omp1015.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: xK8RBMcVM1nu.s054bjL485scpgtNIBN1s.rCih0glbn7Dp
 YVIRB4N_J5MYn7xH3FXMT3af7UcoPtLNtt0P5ZxJy.LtUuGaLlvaI3COYvEE
 EeiOvonPpe_cXHcIRXyXaZ8.LWUHZEUdO0zVWwNfTEIrI7Qe034S6aLhduTh
 2YmXRBrYem0EomOeC6zKOLn95Aaol5e.9Vti2C89g6UtGgAobwcT8vXSMqDd
 ijcIbnqIuL.xlx7EkssBshyaZ8OUr9xHFYL9NEitKlq2P7Z3.779Zcq7vNav
 tkhB_IZEZJdqcTIxGnXxo65Sr328kto4.DDEanwp3TaLqTNokzR7Eb4JA62l
 LHp6yDT2CVswrKb50hT5I2wiO12YqhfOk.tAx5TsUkODoPOU68iv5Au8Tyzf
 7hz37SA--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <4FC81611.9090801@att.net>
Date: Thu, 31 May 2012 20:08:33 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: daniel.santos@pobox.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Kent Overstreet <koverstreet@google.com>, tj@kernel.org,
        Peter Zijlstra <peterz@infradead.org>, axboe@kernel.dk,
        paul.gortmaker@windriver.com, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v2 1/3] [RFC] Generic Red-Black Trees
References: <4FC7FD23.6080800@att.net>
In-Reply-To: <4FC7FD23.6080800@att.net>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh yeah, so the patch set I sent boots & runs fine.  I've also noticed
that I have a few outdated doc-comments and a mistake in the
doc-comments for
the BUILD_BUG_ON_NON_CONST2() macro, under the "Normal Variables"
section, the text "global non-static const broken until 4.2 (-O1 broken
until 4.4)" contradicts the earlier statement that all const values
should never fail. This only applies to floats (but not doubles), which
we don't have to worry about in the kernel anyway. (incidentally, their
behavior under __builtin_constant_p() varies quite a bit until gcc 4.4,
where it's fine)

It was important for me to figure out what was and wasn't working with
__builtin_constant_p(), and in what versions of gcc because this
implementation relies heavily on the compiler optimizing out code based
upon values pass to it via a const struct pointer.  Also, I was looking
for other possibilities, as I continued discovered broken (improperly
optimized) scenarios.

Daniel
