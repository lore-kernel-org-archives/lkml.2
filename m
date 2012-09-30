Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413Ab2I3XLD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 19:11:03 -0400
Received: from nm6-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.206]:44593 "HELO
	nm6-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751132Ab2I3XLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 19:11:00 -0400
X-Yahoo-Newman-Id: 523818.81801.bm@omp1024.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: GH.Q5z4VM1ngTiM1gui6LWatKMZlfCRdVsHScCzAkK.tu0V
 sIRhLBrPVm2.AuvvYzilJr3XVhzaKIM.Z_BXvA.mHjMwgqtrz.rFy9WihiZ0
 prLDiIEdtl0ewUXSEqLm2f1NVnr8mu8IsTj3OQcCltNONicFnBNWfHxOaFNc
 7l3RIViphTgzDCO_MubU_Ii5v5J6XdO4KPvF_MIHHaNIXHx.f2UxUhK41Cyp
 XiQC3RAqV5L61dsHkgOURHPyq2Rmsq3JRZi6bHZGP4GL2sE3RL7LNd4if4wU
 YtNZ92n8RmZD.zaHWi1NiwnPKW7C.fzn9Py.nqajQJ.S0fxa_KpTWKOfsebS
 6gbJHUMVXBldeP2xy4k7y61itJDPRM9LCMO0npuub1EM3jErYZBYagkh7Cbs
 ThY09r4T.bWNnb2w80c64U9irs3PbUGi_MDdx3wq4z2mGSnfhGw--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <5068D185.9000802@att.net>
Date: Sun, 30 Sep 2012 18:11:01 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Andi Kleen <ak@linux.intel.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH 3/10] compiler-gcc.h: Add gcc-recommended GCC_VERSION
 macro
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com> <1348874411-28288-4-git-send-email-daniel.santos@pobox.com>
In-Reply-To: <1348874411-28288-4-git-send-email-daniel.santos@pobox.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So in light of feedback I've been getting on this patch set, it leaves
me with
this question.
> +#define GCC_VERSION (__GNUC__ * 10000 \
> +		   + __GNUC_MINOR__ * 100 \
> +		   + __GNUC_PATCHLEVEL__)
This macro presumes you are using gcc 3.0 or later, which introduced the
__GNUC_PATCHLEVEL__ predefined macro.  Should you be using a version of gcc
prior to 3.0 (where the macro is undefined), you would get an error that
__GNUC_PATCHLEVEL__ is undefined prior to getting the error trying to
include
"linux/compiler-gcc2.h".  So it presumes the compiler is 3.0+, when another
part of the code may allow it from a future change.  Should it be
modified to
do account for this or would that be overkill?


#ifdef __GNUC_PATCHLEVEL__
# define GCC_VERSION (__GNUC__ * 10000 \
                    + __GNUC_MINOR__ * 100 \
                    + __GNUC_PATCHLEVEL__)
#else
# define GCC_VERSION (__GNUC__ * 10000 \
                    + __GNUC_MINOR__ * 100)
#endif

Daniel
