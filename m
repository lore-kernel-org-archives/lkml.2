Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab2G3P3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 11:29:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40243 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2G3P3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 11:29:49 -0400
Date: Mon, 30 Jul 2012 08:29:44 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [ 36/40] mm: vmscan: convert global reclaim to per-memcg LRU
 lists
Message-ID: <20120730152944.GA21091@kroah.com>
References: <20120726211424.GA7709@kroah.com>
 <20120726211411.164006056@linuxfoundation.org>
 <20120726211414.464540343@linuxfoundation.org>
 <1343607917.4642.29.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343607917.4642.29.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 01:25:17AM +0100, Ben Hutchings wrote:
> On Thu, 2012-07-26 at 14:29 -0700, Greg Kroah-Hartman wrote:
> > From: Greg KH <gregkh@linuxfoundation.org>
> > 
> > 3.0-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Johannes Weiner <jweiner@redhat.com>
> > 
> > commit b95a2f2d486d0d768a92879c023a03757b9c7e58 upstream - WARNING: this is a substitute patch.
> > 
> > Stable note: Not tracked in Bugzilla. This is a partial backport of an
> > 	upstream commit addressing a completely different issue
> > 	that accidentally contained an important fix. The workload
> > 	this patch helps was memcached when IO is started in the
> > 	background. memcached should stay resident but without this patch
> > 	it gets swapped. Sometimes this manifests as a drop in throughput
> > 	but mostly it was observed through /proc/vmstat.
> [...]
> > The impact of the accidental fix is to make it harder for kswapd to force
> > scan small targets by taking zone->all_unreclaimable into account. This
> > patch is the closest equivalent available based on what is backported.
> > 
> > ---
> >  mm/vmscan.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> [...]
> 
> This is missing sign-offs.

Oops, my fault, somehow they got lost, I'll go add them back (it's just
Mel's and mine.)

greg k-h
