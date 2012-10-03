Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab2JCGtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 02:49:10 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34754 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab2JCGtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 02:49:06 -0400
Date: Tue, 2 Oct 2012 23:49:03 -0700 (PDT)
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
Subject: Re: [PATCH 7/10] compiler{,-gcc4}.h: Introduce __flatten function
 attribute
In-Reply-To: <20120929005043.GD14293@jtriplet-mobl1>
Message-ID: <alpine.DEB.2.00.1210022347500.12717@chino.kir.corp.google.com>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com> <1348874411-28288-8-git-send-email-daniel.santos@pobox.com> <20120929002626.GD13907@jtriplet-mobl1> <50664308.6020601@att.net> <20120929005043.GD14293@jtriplet-mobl1>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2012, Josh Triplett wrote:

> That issue doesn't relate to __flatten, though; it only relates to
> __weak.  Since __flatten (and __compiletime_object_size) will work fine
> on 4.1.0 and 4.1.1, don't exclude them just because the definition for
> __weak elsewhere in the file excludes them.  That just makes it harder
> for anyone who might want to work on the issue with __weak.
> 

Nack to the patch since there are no users of it; there's no need to 
define every possible gcc function attribute.  If anything actually needs 
to use __attribute__((flatten)), then it can introduce it.
