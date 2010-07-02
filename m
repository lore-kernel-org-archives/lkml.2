Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112Ab0GBJUQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 05:20:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:33898 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758098Ab0GBJUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 05:20:14 -0400
Message-ID: <4C2DAEBB.7090607@kernel.org>
Date: Fri, 02 Jul 2010 11:17:47 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, torvalds@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
       dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
       andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com,
       Arjan van de Ven <arjan@infradead.org>
Subject: [PATCHSET] workqueue: implement and use WQ_UNBOUND
References: <4C2A2688.1020206@kernel.org> <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-35-git-send-email-tj@kernel.org> <20100628225513.GB10104@nowhere> <4C299FD8.7030904@kernel.org> <20100629121855.GA5318@nowhere> <4C2A1558.7060007@kernel.org> <20100629155228.GK5318@nowhere> <4C2A176F.1090101@kernel.org> <4C2A220B.8080006@linux.intel.com> <25085.1277847455@redhat.com>
In-Reply-To: <25085.1277847455@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 02 Jul 2010 09:18:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, David, Arjan.

These four patches implement unbound workqueues which can be used as
simple execution context provider.  I changed async to use it and will
also make fscache use it.  This can be used by setting WQ_UNBOUND on
workqueue creation.  Works queued to unbound workqueues are implicitly
HIGHPRI and dispatched to unbound workers as soon as resources are
available and the only limitation applied by workqueue code is
@max_active.  IOW, for both async and fscache, things will stay about
the same.

WQ_UNBOUND can serve the role of WQ_SINGLE_CPU.  WQ_SINGLE_CPU is
dropped and replaced by WQ_UNBOUND.

Arjan, I still think we'll be better off using bound workqueues for
async but let's first convert without causing behavior difference.
Either way isn't gonna result in any noticeable difference anyway.  If
you're okay with the conversion, please ack it.

David, this should work for fscache/slow-work the same way too.  That
should relieve your concern, right?  Oh, and Frederic suggested that
we would be better off with something based on tracing API and I
agree, so the debugfs thing is currently dropped from the tree.  What
do you think?

Thanks.

-- 
tejun
