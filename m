Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab2F2Wad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 18:30:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50790 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab2F2Wab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 18:30:31 -0400
Date: Fri, 29 Jun 2012 15:30:28 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Petr Holasek <pholasek@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Anton Arapov <anton@redhat.com>
Subject: Re: [PATCH v2] KSM: numa awareness sysfs knob
In-Reply-To: <20120629164706.GA7831@cmpxchg.org>
Message-ID: <alpine.DEB.2.00.1206291526180.15200@chino.kir.corp.google.com>
References: <1340970592-25001-1-git-send-email-pholasek@redhat.com> <20120629160510.GA10082@cmpxchg.org> <20120629163033.GA11327@stainedmachine.redhat.com> <20120629164706.GA7831@cmpxchg.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jun 2012, Johannes Weiner wrote:

> > I started with exactly same idea as you described above in the first
> > RFC, link: https://lkml.org/lkml/2011/11/30/91
> > But this approach turned out to be more complicated than it looked
> > (see two last emails in thread) and complexity of solution would rise
> > a lot.
> 
> Oh, I should have checked the archives given that it's v2.  I expected
> it to get complex but didn't put enough thought into it to see /that/
> amount of complexity.  Sorry.
> 
> Carry on, then :-)
> 

I don't think it's an unfair amount of complexity to ask for, and I don't 
see the problem with ksm merging two pages that have a distance under the 
configured threshold and leaving the third page unmerged; by configuring 
the threshold (which should be a char, not an int) the admin has specified 
the locality that is necessary for optimal performance so has knowingly 
restricted ksm in that way.

I'd rename it to ksm_merge_distance, which is more similar to 
reclaim_distance, and return to the first version of this patch.
