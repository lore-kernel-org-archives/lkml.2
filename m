Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004Ab2GCRDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 13:03:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741Ab2GCRDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 13:03:11 -0400
Date: Tue, 3 Jul 2012 19:02:58 +0200
From: Petr Holasek <pholasek@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Anton Arapov <anton@redhat.com>
Subject: Re: [PATCH v2] KSM: numa awareness sysfs knob
Message-ID: <20120703170257.GC3964@dhcp-27-244.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1207021425110.24806@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2012, David Rientjes wrote:

> > The problem of the first patch/RFC was that merging algorithm was unstable
> > and could merge pages with distance higher than was set up (described by 
> > Nai Xia in RFC thread [1]). Sure, this instability could be solved, but for
> > ksm pages shared by many other pages on different nodes we would have to
> > still
> > recalculate which page is "in the middle" and in case of change migrate it 
> > between nodes every time when ksmd reach new shareable page or when some 
> > sharing page is removed.
> > 
> 
> Or you could simply refuse to ever merge any page that is identical to a 
> page on a node with a distance greater than the threshold, i.e. never 
> merge pages even under the threshold if a page exists on a node higher 
> than the threshold.

Position of the shared page would be really dependent on order of scanning.
We could have shared page in the ideal middle as well as on the edge where it
would block merging of other pages even under the threshold. 

