Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab2GSWJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 18:09:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36125 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab2GSWI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 18:08:58 -0400
Date: Thu, 19 Jul 2012 23:08:55 +0100
From: Mel Gorman <mgorman@suse.de>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 30/34] mm: vmscan: Do not force kswapd to scan small
 targets
Message-ID: <20120719220855.GA9222@suse.de>
References: <1342708604-26540-1-git-send-email-mgorman@suse.de>
 <1342708604-26540-31-git-send-email-mgorman@suse.de>
 <20120719203743.GD19392@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120719203743.GD19392@burratino>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 03:37:43PM -0500, Jonathan Nieder wrote:
> Mel Gorman wrote:
> 
> > commit ad2b8e601099a23dffffb53f91c18d874fe98854 upstream - WARNING: partial backport only
> >
> > Stable note: Not tracked in Bugzilla. This patch is very controversial for
> > 	-stable. The upstream patch is addressing a completely different
> > 	issue but accidentally contained an important fix. The workload
> > 	in question was running memcached and then started IO in the
> > 	background. memcached should stay resident but without this patch
> > 	it gets swapped. Sometimes this manifests as a drop in throughput
> > 	but mostly it was observed through /proc/vmstat.
> 
> I had thought partial backports like this were pretty normal and ok,
> actually, as long as they are well explained. 

I was not aware of that and it's not something I had noticed for any other
MM backports to -stable. I wanted to call it out instead of seeing if
reviewers happened to spot the upstream commit did not resemble this patch :)

> Otherwise there would
> be no way to fix bugs in stable in the above situation.
> 

If there is no problem with this then the note can change slightly

Stable note: Not tracked in Bugzilla. This is a partial backport of an
	upstream commit addressing a completely different issue
	that accidentally contained an important fix. The workload
	this patch helps was memcached when IO is started in the
	background. memcached should stay resident but without this patch
	it gets swapped. Sometimes this manifests as a drop in throughput
	but mostly it was observed through /proc/vmstat.

-- 
Mel Gorman
SUSE Labs
