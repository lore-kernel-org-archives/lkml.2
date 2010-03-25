Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab0CYOhD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 10:37:03 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:56195 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab0CYOg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 10:36:59 -0400
Date: Thu, 25 Mar 2010 09:35:05 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, David Rientjes <rientjes@google.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 02/11] mm,migration: Do not try to migrate unmapped
 anonymous pages
In-Reply-To: <20100325092131.GK2024@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1003250933480.2670@router.home>
References: <20100325083235.GF2024@csn.ul.ie> <20100325180221.e1d9bae7.kamezawa.hiroyu@jp.fujitsu.com> <20100325180726.6C89.A69D9226@jp.fujitsu.com> <20100325092131.GK2024@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Mar 2010, Mel Gorman wrote:

> Christoph is opposed to removing it because of cache-hotness issues more
> so than use-after-free concerns. The refcount is needed with or without
> SLAB_DESTROY_BY_RCU.

The issue is only performance. If we can preserve the cache hotness in a
different way (or do things in a completely different manner) then its
fine.
