Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab0DRPzz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 11:55:55 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:61979 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab0DRPzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 11:55:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SOVZ/OosSXKtSAhC2zTyM+P3gace0ikWft5+GSepN8Ym11j9yuqHYd3Lmx8fyeSCil
         NAQqOFY7bC6avUTJqOZNfTb1ta/rtfWdvYppc/EuJvu1NjRSsUORcj2rT6T+xNXt+Rak
         CpP1Qx54xPLSSofz3Us94TpZXnjDpZ3XzRofs=
Subject: Re: [PATCH 2/6] change alloc function in pcpu_alloc_pages
From: Minchan Kim <minchan.kim@gmail.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <1271445189.30360.280.camel@useless.americas.hpqcorp.net>
References: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>
	 <4BC65237.5080408@kernel.org>
	 <v2j28c262361004141831h8f2110d5pa7a1e3063438cbf8@mail.gmail.com>
	 <4BC6BE78.1030503@kernel.org>
	 <h2w28c262361004150100ne936d943u28f76c0f171d3db8@mail.gmail.com>
	 <4BC6CB30.7030308@kernel.org>
	 <l2u28c262361004150240q8a873b6axb73eaa32fd6e65e6@mail.gmail.com>
	 <4BC6E581.1000604@kernel.org>
	 <z2p28c262361004150321sc65e84b4w6cc99927ea85a52b@mail.gmail.com>
	 <4BC6FBC8.9090204@kernel.org>
	 <w2h28c262361004150449qdea5cde9y687c1fce30e665d@mail.gmail.com>
	 <alpine.DEB.2.00.1004161105120.7710@router.home>
	 <1271445189.30360.280.camel@useless.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 00:55:45 +0900
Message-ID: <1271606145.2100.160.camel@barrios-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Lee. 

On Fri, 2010-04-16 at 15:13 -0400, Lee Schermerhorn wrote:
> On Fri, 2010-04-16 at 11:07 -0500, Christoph Lameter wrote:
> > On Thu, 15 Apr 2010, Minchan Kim wrote:
> > 
> > > I don't want to remove alloc_pages for UMA system.
> > 
> > alloc_pages is the same as alloc_pages_any_node so why have it?
> > 
> > > #define alloc_pages alloc_page_sexact_node
> > >
> > > What I want to remove is just alloc_pages_node. :)
> > 
> > Why remove it? If you want to get rid of -1 handling then check all the
> > callsites and make sure that they are not using  -1.
> > 
> > Also could you define a constant for -1? -1 may have various meanings. One
> > is the local node and the other is any node. 
> 
> NUMA_NO_NODE is #defined as (-1) and can be used for this purpose.  '-1'
> has been replaced by this in many cases.   It can be interpreted as "No
> node specified" == "any node is acceptable".  But, it also has multiple
> meanings.  E.g., in the hugetlb sysfs attribute and sysctl functions it
> indicates the global hstates [all nodes] vs a per node hstate.  So, I
> suppose one could define a NUMA_ANY_NODE, to make the intention clear at
> the call site.
> 
> I believe that all usage of -1 to mean the local node has been removed,
> unless I missed one.  Local allocation is now indicated by a mempolicy
> mode flag--MPOL_F_LOCAL.  It's treated as a special case of
> MPOL_PREFERRED.

Thanks for good information. :)

-- 
Kind regards,
Minchan Kim


