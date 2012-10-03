Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab2JCGcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 02:32:31 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:32807 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab2JCGc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 02:32:29 -0400
Date: Tue, 2 Oct 2012 23:32:21 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Daniel Santos <daniel.santos@pobox.com>
cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/10] compiler-gcc.h: Add gcc-recommended GCC_VERSION
 macro
In-Reply-To: <1348874411-28288-4-git-send-email-daniel.santos@pobox.com>
Message-ID: <alpine.DEB.2.00.1210022332080.12717@chino.kir.corp.google.com>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com> <1348874411-28288-4-git-send-email-daniel.santos@pobox.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2012, Daniel Santos wrote:

> Throughout compiler*.h, many version checks are made.  These can be
> simplified by using the macro that gcc's documentation recommends.
> However, my primary reason for adding this is that I need bug-check
> macros that are enabled at certain gcc versions and it's cleaner to use
> this macro than the tradition method:
> 
> if __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ => 2)
> 
> If you add patch level, it gets this ugly:
> 
> if __GNUC__ > 4 || (__GNUC__ == 4 && (__GNUC_MINOR__ > 2 || \
>    __GNUC_MINOR__ == 2 __GNUC_PATCHLEVEL__ >= 1))
> 
> As opposed to:
> 
> if GCC_VERSION >= 40201
> 
> While having separate headers for gcc 3 & 4 eliminates some of this
> verbosity, they can still be cleaned up by this.
> 
> See also:
> http://gcc.gnu.org/onlinedocs/cpp/Common-Predefined-Macros.html
> 
> Signed-off-by: Daniel Santos <daniel.santos@pobox.com>

Acked-by: David Rientjes <rientjes@google.com>
