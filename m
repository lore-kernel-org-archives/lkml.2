Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751237Ab2GZE7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 00:59:51 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:55125 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004Ab2GZE7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 00:59:50 -0400
Date: Thu, 26 Jul 2012 10:29:00 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: teach build_probe_list() to consider the range
Message-ID: <20120726045900.GB3810@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120709133510.GA8269@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120709133510.GA8269@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072604-5930-0000-0000-00000A37E150
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-07-09 15:35:10]:

> Currently build_probe_list() builds the list of all uprobes attached
> to the given inode, and the caller should filter out those who don't
> fall into the [start,end) range, this is sub-optimal.
> 
> This patch turns find_least_offset_node() into find_node_in_range()
> which returns the first node inside the [min,max] range, and changes
> build_probe_list() to use this node as a starting point for rb_prev()
> and rb_next() to find all other nodes the caller needs. The resulting
> list is no longer sorted but we do not care.
> 
> This can speed up both build_probe_list() and the callers, but there
> is another reason to introduce find_node_in_range(). It can be used
> to figure out whether the given vma has uprobes or not, this will be
> needed soon.
> 
> While at it, shift INIT_LIST_HEAD(tmp_list) into build_probe_list().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

