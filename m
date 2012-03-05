Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583Ab2CEOsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:48:39 -0500
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:30036 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932379Ab2CEOsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 09:48:38 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 9.hMGdYVM1nPuf5E2dNrfbTnYZ78AMER0QMtmFZ7jnWJwEN
 MIU.Nq63Ayn9kmOZZd.ogvOevCu5rXilNKus4TH32xtYDfRO4XySt3ugz5u5
 CiXhQyAYLu.8Xy5eR2gd1LS1niQZBI1obg7x6MJqwP9CYKTHYaCtKCeIwpT4
 eNg3BlQZivKpXUFK8VoyB5So9XTYyrWa0TMKFCRDxUZy9CNXJregJj3AYAtB
 iUzsJ1uMWEIt1GoWyHYs4zlzB.rWUhxk5k_0myOaDInxdG_IFQdK24aoqtXN
 gr6WW9kWTOyJKxu0esbi2pLaaRyt59ROc9jlUXyRs2yuY2ptelmsYb6YTnUs
 9odOH.Dc2qjbTSHCITvRHfyMG0Gi86jMfD5WXkzANLexm3Do40.ARWvvA3yG
 1cW.cr3JmRl9Oj_aaAKmW1hKr3P_9vFfQPbA8
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 5 Mar 2012 08:48:33 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Minchan Kim <minchan@kernel.org>
cc: Namhyung Kim <namhyung.kim@lge.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, Namhyung Kim <namhyung@gmail.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] slub: set PG_slab on all of slab pages
In-Reply-To: <20120304103446.GA9267@barrios>
Message-ID: <alpine.DEB.2.00.1203050845380.11722@router.home>
References: <1330505674-31610-1-git-send-email-namhyung.kim@lge.com> <20120304103446.GA9267@barrios>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Mar 2012, Minchan Kim wrote:

> I read this thread and I feel the we don't reach right point.
> I think it's not a compound page problem.
> We can face above problem where we allocates big order page without __GFP_COMP
> and free middle page of it.

Yes we can do that and doing such a thing seems to be more legitimate
since one could argue that the user did not request an atomic allocation
unit from the page allocator and therefore the freeing of individual
pages in that group is permissible. If memory serves me right we do that
sometimes.

However if compound pages are requested then such an atomic allocation
unit *was* requested and the page allocator should not allow to free
individual pages.
