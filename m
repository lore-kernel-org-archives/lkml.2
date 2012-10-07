Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab2JGSgP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 14:36:15 -0400
Received: from nm15-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.208]:24479 "HELO
	nm15-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751649Ab2JGSgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 14:36:05 -0400
X-Yahoo-Newman-Id: 857192.95483.bm@omp1015.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ljofvr8VM1l5cXYb3WSvbnU.z0ZMTtPDSpvF2nKMSanb5tm
 U.kIHjvdArT7d6BlEmlM_wnVSVcM2irjFYz8MLjWCN3iAX.EN31soy0ldL.f
 Dp3TFpb3N1WjLu1e91l6VeIfDlx5uWCwnROU.QdgFYAfifGvc2oFT3wYZhPA
 K1zalcODM4nVVPrcjUM5VuNrk07ktclot1YK2N_rS5d7cxUwBLi_G77ceauc
 AGiDS4x7zZX7jPzfDsKFzzxKgfUxIV.aOfRjQkqxnsZVnXHXR0M4SAaaA..K
 x870uyfMXlkgD4PtIrgGjObhH_hq49R23AeV4Fjy5CPEwOZhLx80cKDmP.ID
 yfUkqzlX5yy6JR9V4wpgzztxORNeTtdkNOuYAYMxj9avqB3ZIucYT_xihriY
 AC.nkFa_6rvShOwNY59uTw7pg0QvdV_fqTJu4yKmuDyaI7KJBBg--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <5071CB92.2040703@att.net>
Date: Sun, 07 Oct 2012 13:36:02 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Andi Kleen <ak@linux.intel.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 0/10] Cleanup & new features for compiler*.h and bug.h
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com> <1349465759-20524-1-git-send-email-daniel.santos@pobox.com>
In-Reply-To: <1349465759-20524-1-git-send-email-daniel.santos@pobox.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just realized that in my patch set header I didn't specify that this
version of the patches is based against -mm.  However, I did not test
against -mm, I rebased them to mainline, merged some conflicts and made
some changes and tested there and I'm running that kernel now (that is,
with all of my patches, including fair scheduler using the generic
red-black tree).

This patch set builds fine against -mm & -next, but I just can't get
either of those to run correctly on my machine, even without my
patches.  (Sorry, that I don't have an actual test machine at the moment.)

On 10/05/2012 02:35 PM, danielfsantos@att.net wrote:
> This patch set is a dependency of the generic red-black tree patch set, which
> I have now split up into three smaller sets.
>
> The major aim of this patch set is to cleanup compiler-gcc*.h and improve the
> manageability of of compiler features at various versions (when they are
> broken, etc.), and to cleanup & add some needed features to bug.h.
>
> compiler-gcc*.h
> o Introduce GCC_VERSION - (e.g., gcc 4.7.1 becomes 40701)
> o Reorder all features based upon the version introduced (readability)
> o Change all version checks to use GCC_VERSION
> o Remove redundant __linktime_error
>
> bug.h
> o Improve BUILD_BUG_ON(expr) - Will now generate a compile-time error and in
>   gcc-4.4+, also emits an error message containing the expression that failed.
> o Add BUILD_BUG_ON_MSG(expr, msg) - Like BUILD_BUG_ON, except that you can
>   specify the error message that is emitted (again, gcc-4.4+).
> o Add BUILD_BUG_ON_INTERNAL(expr, fn, msg) - contains a generic implementation
>   of BUILG_BUG_ON{_MSG}.
> o Finally, the implementations of BUILD_BUG{,_ON,_ON_MSG} is consolidated,
>   eliminating duplicate code.

