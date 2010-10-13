Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab0JMHQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 03:16:35 -0400
Received: from canuck.infradead.org ([134.117.69.58]:40527 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab0JMHQe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 03:16:34 -0400
Subject: Re: [RFC PATCH 1/9] uaccess: Make copy_from_user_nmi() globally
 available
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
In-Reply-To: <1286946421-32202-2-git-send-regression-fweisbec@gmail.com>
References: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com>
	 <1286946421-32202-2-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 13 Oct 2010 09:15:56 +0200
Message-ID: <1286954156.29097.53.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-13 at 07:06 +0200, Frederic Weisbecker wrote:
> In order to support user stack dump safely in perf samples from
> generic code, export copy_from_user_nmi() from x86 and make it
> generally available. For most archs it will map to
> copy_from_user_inatomic, but for x86 we need to take care of
> not faulting from NMIs.
> 
> Since perf is the first user for now, let the overriden x86
> implementation in the perf source file.

It might make sense to call it copy_from_user_gup() because that's
bascially what it does, it doesn't rely on NMI context anymore, its just
NMI-safe.

Its a best effort software page table walk, and with the stacked
kmap_atomic bits Andrew took it should work from any context.


