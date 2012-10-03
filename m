Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab2JCGlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 02:41:00 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:65363 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab2JCGk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 02:40:58 -0400
Date: Tue, 2 Oct 2012 23:40:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Josh Triplett <josh@joshtriplett.org>
cc: Daniel Santos <daniel.santos@pobox.com>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
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
Subject: Re: [Bulk] Re: [PATCH 4/10] compiler-gcc{3,4}.h: Use GCC_VERSION
 macro
In-Reply-To: <20120929004231.GB14293@jtriplet-mobl1>
Message-ID: <alpine.DEB.2.00.1210022337400.12717@chino.kir.corp.google.com>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com> <1348874411-28288-5-git-send-email-daniel.santos@pobox.com> <20120929002029.GA13907@jtriplet-mobl1> <50664179.5090608@att.net> <20120929004231.GB14293@jtriplet-mobl1>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2012, Josh Triplett wrote:

> GCC 4.1.0 and 4.1.1 miscompiling __weak has nothing to do with
> __compiletime_object_size; why should *this* version check exclude those
> versions?
> 

Agreed, we shouldn't be relying on any #error directives to fail the build 
and then try to factor those version numbers out of other directives; if 
the #error directive were ever to be removed (or commented out, like in 
this case), nobody would make the other directives inclusive of that 
now-allowed version where things like __compiletime_object_size() are 
valid.

After __compiletime_object_size() is compiled for GCC_VERSION >= 40100, 
then:

	Acked-by: David Rientjes <rientjes@google.com>
