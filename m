Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751031Ab0KWIfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 03:35:36 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46139 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab0KWIff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 03:35:35 -0500
Subject: Re: Free memory never fully used, swapping
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Simon Kirby <sim@hostway.ca>, linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
In-Reply-To: <20101122154419.ee0e09d2.akpm@linux-foundation.org>
References: <20101115195246.GB17387@hostway.ca>
	 <20101122154419.ee0e09d2.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Tue, 23 Nov 2010 00:35:31 -0800
Message-ID: <1290501331.2390.7023.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-22 at 15:44 -0800, Andrew Morton wrote:
> > These are all x86_64, and so there is no highmem garbage going on. 
> > The only zones would be for DMA, right?

There shouldn't be any highmem-related action going on.

> Is the combination of memory fragmentation and large-order allocations
> the only thing that would be causing this reclaim here?

It does sound somewhat suspicious.  Are you using hugetlbfs or
allocating large pages?  What are your high-order allocations going to?

> Is there some easy bake knob for finding what
>  is causing the free memory jumps each time this happens? 

I wish.  :)  The best thing to do is to watch stuff like /proc/vmstat
along with its friends like /proc/{buddy,meminfo,slabinfo}.  Could you
post some samples of those with some indication of where the bad
behavior was seen?

I've definitely seen swapping in the face of lots of free memory, but
only in cases where I was being a bit unfair about the numbers of
hugetlbfs pages I was trying to reserve.

-- Dave
 

