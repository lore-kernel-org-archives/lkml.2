Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab2JETgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 15:36:19 -0400
Received: from nm24.bullet.mail.sp2.yahoo.com ([98.139.91.94]:39325 "HELO
	nm24.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753445Ab2JETgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 15:36:17 -0400
X-Yahoo-Newman-Id: 85395.76638.bm@omp1012.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: GECrvpgVM1mp_m.l.VLyQcaLbQRbw9_mvZbNAhxErIx4djK
 UV8V9bUBNVVt1WApt1cFWHsy84pTjdRYrY6X1ZXExiRK1JYQICk2EodzP.wA
 GcOHdkyQpdirMPjtsHBGLdI_IqmvCZq1BwUuVceALRn147KNjLx0LJ.Qlvp0
 J5yZyOWWsGxsxM9KhSSggu54H4v7V2GdPmJskml6ul6BdYgubVCUmwDmZ3aJ
 n72FtR3wCEw_.RiGTvJfUKu5mIJgJgAdq9XKicbvXv_ZCjpBNEP1SR18Epr7
 B.EzKkGnO3mXMhxwybNIuYTPLnqxlKgbWhZGW0AiwtnWGFP88vylLD2ZhQNH
 5ob03v0LzKP.vZ1hPVgy6tXe75pip58Ky1ElukiwEdJ_KReyhkL9aYrLkKcN
 GNpg2lu5mJMEJaSh1hMIxgLjpz41Q4nxg1eakm3vw3XVcjeAGM4CT
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: danielfsantos@att.net
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>, Andrea Arcangeli <aarcange@redhat.com>,
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
Subject: [PATCH v2 0/10] Cleanup & new features for compiler*.h and bug.h
Date: Fri,  5 Oct 2012 14:35:49 -0500
Message-Id: <1349465759-20524-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch set is a dependency of the generic red-black tree patch set, which
I have now split up into three smaller sets.

The major aim of this patch set is to cleanup compiler-gcc*.h and improve the
manageability of of compiler features at various versions (when they are
broken, etc.), and to cleanup & add some needed features to bug.h.

compiler-gcc*.h
o Introduce GCC_VERSION - (e.g., gcc 4.7.1 becomes 40701)
o Reorder all features based upon the version introduced (readability)
o Change all version checks to use GCC_VERSION
o Remove redundant __linktime_error

bug.h
o Improve BUILD_BUG_ON(expr) - Will now generate a compile-time error and in
  gcc-4.4+, also emits an error message containing the expression that failed.
o Add BUILD_BUG_ON_MSG(expr, msg) - Like BUILD_BUG_ON, except that you can
  specify the error message that is emitted (again, gcc-4.4+).
o Add BUILD_BUG_ON_INTERNAL(expr, fn, msg) - contains a generic implementation
  of BUILG_BUG_ON{_MSG}.
o Finally, the implementations of BUILD_BUG{,_ON,_ON_MSG} is consolidated,
  eliminating duplicate code.

