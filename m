Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab1JaNhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 09:37:54 -0400
Received: from relay3.sgi.com ([192.48.152.1]:51913 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754889Ab1JaNhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 09:37:53 -0400
Date: Mon, 31 Oct 2011 08:37:49 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, David Rientjes <rientjes@google.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] cache align vm_stat
Message-ID: <20111031133749.GB17076@sgi.com>
References: <20111024161035.GA19820@sgi.com>
 <alpine.DEB.2.00.1110262131240.27107@router.home>
 <20111028155456.20f3d611.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111028155456.20f3d611.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 03:54:56PM -0700, Andrew Morton wrote:
> On Wed, 26 Oct 2011 21:31:46 -0500 (CDT)
> Christoph Lameter <cl@gentwo.org> wrote:
> 
> > On Mon, 24 Oct 2011, Dimitri Sivanich wrote:
> > 
> > > Avoid false sharing of the vm_stat array.
> 
> Did we have some nice machine-description and measurement results which
> can be included in the changelog?  Such things should always be
> included with a performace patch!
> 
Tests run on a 640 cpu UV system.

With 120 threads doing parallel writes, each to different tmpfs mounts:
No patch:		~300 MB/sec
With vm_stat alignment:	~430 MB/sec
