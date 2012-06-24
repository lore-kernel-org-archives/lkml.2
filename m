Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab2FXIip (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 04:38:45 -0400
Received: from relay.felk.cvut.cz ([147.32.80.7]:38362 "EHLO
	relay.felk.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab2FXIik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 04:38:40 -0400
X-Greylist: delayed 1920 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Jun 2012 04:38:40 EDT
From: Pavel Pisa <pisa@cmp.felk.cvut.cz>
To: Rob Landley <rob@landley.net>
Subject: Re: [PATCH v4 0/13] Generic Red-Black Trees
Date: Sun, 24 Jun 2012 09:57:08 +0200
User-Agent: KMail/1.9.9
Cc: daniel.santos@pobox.com, Daniel Santos <danielfsantos@att.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-doc@vger.kernel.org, linux-sparse@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paul Turner <pjt@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Weinberger <richard@nod.at>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
References: <1340424048-7759-1-git-send-email-daniel.santos@pobox.com> <4FE661F8.3000109@att.net> <4FE69A14.6040904@landley.net>
In-Reply-To: <4FE69A14.6040904@landley.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201206240957.09136.pisa@cmp.felk.cvut.cz>
X-FELK-MailScanner-Information: 
X-MailScanner-ID: q5O7vDOM078503
X-FELK-MailScanner: Found to be clean
X-FELK-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-1.91, required 6, autolearn=not spam, BAYES_00 -1.90,
	T_RP_MATCHES_RCVD -0.01)
X-FELK-MailScanner-From: pisa@cmp.felk.cvut.cz
X-FELK-MailScanner-To: a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
	daniel.santos@pobox.com, danielfsantos@att.net,
	david.daney@cavium.com, dhowells@redhat.com, hpa@zytor.com,
	joe@perches.com, khlebnikov@openvz.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org,
	mingo@elte.hu, mingo@kernel.org, paul.gortmaker@windriver.com,
	pjt@google.com, richard@nod.at, rientjes@google.com, rob@landley.net,
	rostedt@goodmis.org, seto.hidetoshi@jp.fujitsu.com,
	sparse@chrisli.org, suresh.b.siddha@intel.com
X-FELK-MailScanner-Watermark: 1341129437.836@G3cHDUmx5tRtoYjT1s6tOA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rob,

I follow-up Daniel's RB series from Jonathan Corbet's
summarry on LWN http://lwn.net/Articles/500355/ .

I have attempted ourself to solve implementation of
type safe tree containers for C more than 10 years ago
(GAVL) and it is used in many of my own and our university
projects and even in (at least three) companies for
proprietary projects.

I have done multiple reviews of the Daniel's RB series
and I am confident that his approach is more clean
and generic than mine.

I would be happy if it can get into Linux kernel,
because it makes use of RB trees much simpler (user does
not need to care about details) and with much better
potential to catch user errors.

According to my review, there is only one possibly problematic
preprocessor construct. The Linux kernel is already dependent
on this CPP behavior (IS_ENABLED macro) anyway.

If you are fan of other compilers, please, provide
constructive help and debate there and test attached
C code on compilers which you use and consider
them as candidates to compile linux kernel.

According to my test, there is problem with MSVC
(free WDF version run under WINE to deliver our company
open-source projects to unfortunate users using Windows).

Version

Microsoft (R) 32-bit C/C++ Optimizing Compiler Version 15.00.30729.207 for 80x86
Copyright (C) Microsoft Corporation.  All rights reserved.

But that is compiler which breaks many standards
and if GCC is not enough open to you then I expect that
you do not mind if Linux kernel cannot be compiled by MSVC.
So I do not see that as a problem.

So again, please, test LLVM or other your beloved
compilers and report if there is a problem.

It would worth to have even user space version of the
kernel RB tree code with Dainie's interface to run feasibility
and performance tests in more environments quickly
(as Daniel mentioned already). But it is not necessary
for me to be convinced that provided changes should go into
kernel because I am convinced  already and offer my
"Reviewed-by" confirmation.

It would even worth to have this code available for
user space projects and libraries use. But there is a problem
that core part of the Linux RB code is GPL licensed
and for library use LGPL, MPL or GPL with linking exception
is usually required.

Best wishes,

                Pavel Pisa
    e-mail:     pisa@cmp.felk.cvut.cz
    www:        http://cmp.felk.cvut.cz/~pisa
    university: http://dce.fel.cvut.cz/
    company:    http://www.pikron.com/



#include <stdio.h>

#define IFF_EMPTY(test, t, f) _iff_empty(__JUNK##test, t, f)

#define __JUNK junk ,
#define _iff_empty(test_or_junk, t, f) __iff_empty(test_or_junk, t, f)
#define __iff_empty(__ignored1, __ignored2, result, ...) result

#define IS_EMPTY(arg)	IFF_EMPTY(arg, 1, 0)

#define TESTER_empty
#define TESTER_filled filled

int main(int argc, char *argv[])
{
  printf("IS_EMPTY for empty %d (should be 1)\n", IS_EMPTY(TESTER_empty));
  printf("IS_EMPTY for filled %d (should be 0)\n", IS_EMPTY(TESTER_filled));
  printf("IS_EMPTY for unknown %d (should be 0)\n", IS_EMPTY(TESTER_unknown));
  printf("IS_EMPTY for nil %d (should be 1)\n", IS_EMPTY());
  printf("IS_EMPTY for space %d (should be 1)\n", IS_EMPTY( ));
  printf("IS_EMPTY for comment %d (should be 1)\n", IS_EMPTY(/*test*/));
}


