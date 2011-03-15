Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab1COOHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 10:07:46 -0400
Received: from smtp.nokia.com ([147.243.1.47]:19175 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280Ab1COOHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 10:07:45 -0400
Date: Tue, 15 Mar 2011 16:01:53 +0200
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: ext Christoph Hellwig <hch@infradead.org>
Cc: menage@google.com, lizf@cn.fujitsu.com,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 0/2] suck some poison out of cgroups' linked lists
Message-ID: <20110315140153.GD18664@esdhcp04044.research.nokia.com>
References: <1300194523-19325-1-git-send-email-ext-phil.2.carmody@nokia.com> <20110315135137.GA27545@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110315135137.GA27545@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/03/11 09:51 -0400, ext Christoph Hellwig wrote:
> On Tue, Mar 15, 2011 at 03:08:41PM +0200, Phil Carmody wrote:
> > Apparently, whether nodes are on a list is being checked with list_empty(),
> > and if they're on a list, they're list_del()ed. According to a subsequent 
> > list_empty() check, they're still on a list, as list_del() doesn't turn
> > the nodes into singleton lists, it simply poisons both its pointers, and
> > merry poison dereferencing may ensue. Oops.
> > 
> > There are at least 2 to address this matter, I've gone for the latter:
> > 
> > 1) Do not use list_empty() to check if a node is on a list or not. Have
> > an additional new function that checks to see whether the node is either
> > a singleton or is poisoned. Something like list_node_{on,off}_list()?
> > 
> > 2) Ensure that you never leave poison anywhere where you might want
> > to use list_empty().
> 
> The correct way is to use list_del_init() if you want to do list_empty
> checks later on.

I.e. (2). Glad I chose that one.

Phil
