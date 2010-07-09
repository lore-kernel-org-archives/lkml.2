Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab0GISbj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 14:31:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643Ab0GISbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 14:31:37 -0400
Date: Fri, 9 Jul 2010 20:31:29 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: mmu notifier calls in apply_to_page_range()
Message-ID: <20100709183129.GG5741@random.random>
References: <4C373AEC.6000502@goop.org>
 <20100709151211.GE13493@random.random>
 <4C37458B.8040408@goop.org>
 <20100709162255.GA5741@random.random>
 <4C375CC8.2030705@goop.org>
 <20100709173612.GF5741@random.random>
 <4C375F5F.5000907@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C375F5F.5000907@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 09, 2010 at 10:41:51AM -0700, Jeremy Fitzhardinge wrote:
> On 07/09/2010 10:36 AM, Andrea Arcangeli wrote:
> > I'm not opposed to removing it, I've been wondering if it made any
> > sense in the first place but then there was no point not to add
> > it. Just calling apply_to_page_range in non blocking context doesn't
> > look so good.
> >   
> 
> That's a good point.  It should be safe if the pagetable is already
> fully populated; I should double-check that's true in our case.

Yes in that case is safe, but it'd be more strict to use pmd/*_offset
then.
