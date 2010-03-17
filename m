Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab0CQOnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 10:43:23 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:47763 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279Ab0CQOnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 10:43:21 -0400
Subject: Re: [PATCH 5/5] doc: add the documentation for mpol=local
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kiran@scalex86.org,
       cl@linux-foundation.org, hugh.dickins@tiscali.co.uk, mel@csn.ul.ie,
       stable@kernel.org, linux-mm <linux-mm@kvack.org>,
       akpm@linux-foundation.org
In-Reply-To: <20100316145220.4C54.A69D9226@jp.fujitsu.com>
References: <201003122353.o2CNrC56015250@imap1.linux-foundation.org>
	 <20100316143406.4C45.A69D9226@jp.fujitsu.com>
	 <20100316145220.4C54.A69D9226@jp.fujitsu.com>
Content-Type: text/plain
Organization: HP/LKTT
Date: Wed, 17 Mar 2010 10:42:36 -0400
Message-Id: <1268836956.4773.58.camel@useless.americas.hpqcorp.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-16 at 14:53 +0900, KOSAKI Motohiro wrote:
> commit 3f226aa1c (mempolicy: support mpol=local tmpfs mount option)
> added new mpol=local mount option. but it didn't add a documentation.
> 
> This patch does it.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Ravikiran Thirumalai <kiran@scalex86.org>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
> Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Cc: <stable@kernel.org>

Acked-by: Lee Schermerhorn <lee.schermerhorn@hp.com>

[Note:  looking at this patch in context, it appears that a few more
updates are in order.  E.g., "contextualization" of the specified
nodelists based on mems_allowed when one allocates a tmpfs file and what
happens when the mount option nodelist is disjoint from a task's
mems_allowed.  I'll test the behavior to make sure it matches my
expectations and update the doc accordingly in a subsequent patch.]

> ---
>  Documentation/filesystems/tmpfs.txt |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/filesystems/tmpfs.txt b/Documentation/filesystems/tmpfs.txt
> index 3015da0..fe09a2c 100644
> --- a/Documentation/filesystems/tmpfs.txt
> +++ b/Documentation/filesystems/tmpfs.txt
> @@ -82,11 +82,13 @@ tmpfs has a mount option to set the NUMA memory allocation policy for
>  all files in that instance (if CONFIG_NUMA is enabled) - which can be
>  adjusted on the fly via 'mount -o remount ...'
>  
> -mpol=default             prefers to allocate memory from the local node
> +mpol=default             use the process allocation policy
> +                         (see set_mempolicy(2))
>  mpol=prefer:Node         prefers to allocate memory from the given Node
>  mpol=bind:NodeList       allocates memory only from nodes in NodeList
>  mpol=interleave          prefers to allocate from each node in turn
>  mpol=interleave:NodeList allocates from each node of NodeList in turn
> +mpol=local		 prefers to allocate memory from the local node
>  
>  NodeList format is a comma-separated list of decimal numbers and ranges,
>  a range being two hyphen-separated decimal numbers, the smallest and
> @@ -134,3 +136,5 @@ Author:
>     Christoph Rohland <cr@sap.com>, 1.12.01
>  Updated:
>     Hugh Dickins, 4 June 2007
> +Updated:
> +   KOSAKI Motohiro, 16 Mar 2010

