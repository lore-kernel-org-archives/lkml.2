Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab2F2QFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 12:05:21 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:53162 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336Ab2F2QFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 12:05:20 -0400
Date: Fri, 29 Jun 2012 18:05:10 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Petr Holasek <pholasek@redhat.com>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Anton Arapov <anton@redhat.com>
Subject: Re: [PATCH v2] KSM: numa awareness sysfs knob
Message-ID: <20120629160510.GA10082@cmpxchg.org>
References: <1340970592-25001-1-git-send-email-pholasek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340970592-25001-1-git-send-email-pholasek@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 01:49:52PM +0200, Petr Holasek wrote:
> Introduces new sysfs boolean knob /sys/kernel/mm/ksm/merge_nodes
> which control merging pages across different numa nodes.
> When it is set to zero only pages from the same node are merged,
> otherwise pages from all nodes can be merged together (default behavior).

Is it conceivable that admins may (in the future) want to merge only
across nodes that are below a given distance threshold?

I'm not asking to implement this, just whether the knob can be
introduced such that it's future-compatible.  Make it default to a
Very High Number and only allow setting it to 0 for now e.g.?  And
name it max_node_merge_distance (I'm bad at names)?

What do you think?
