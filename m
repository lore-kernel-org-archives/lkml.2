Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab1BJMk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 07:40:59 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:56852 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab1BJMk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 07:40:58 -0500
Date: Thu, 10 Feb 2011 13:40:43 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] memcg: operate on page quantities internally
Message-ID: <20110210124043.GN27110@cmpxchg.org>
References: <1297249313-23746-1-git-send-email-hannes@cmpxchg.org>
 <20110209133757.735b08ab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110209133757.735b08ab.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 01:37:57PM -0800, Andrew Morton wrote:
> On Wed,  9 Feb 2011 12:01:49 +0100
> Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > Hi,
> > 
> > this patch set converts the memcg charge and uncharge paths to operate
> > on multiples of pages instead of bytes.  It already was a good idea
> > before, but with the merge of THP we made a real mess by specifying
> > huge pages alternatingly in bytes or in number of regular pages.
> > 
> > If I did not miss anything, this should leave only res_counter and
> > user-visible stuff in bytes.  The ABI probably won't change, so next
> > up is converting res_counter to operate on page quantities.
> > 
> 
> I worry that there will be unconverted code and we'll end up adding
> bugs.
> 
> A way to minimise the risk is to force compilation errors and warnings:
> rename fields and functions, reorder function arguments.  Did your
> patches do this as much as they could have?

I sent you fixes/replacements for 1/4 and 4/4. 2/4 and 3/4 adjusted
the names of changed structure members already.
