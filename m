Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346Ab2BMKM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 05:12:26 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47783 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab2BMKMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 05:12:24 -0500
Date: Mon, 13 Feb 2012 02:12:21 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dan Smith <danms@us.ibm.com>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Ensure that walk_page_range()'s start and end are
 page-aligned
In-Reply-To: <1328902796-30389-1-git-send-email-danms@us.ibm.com>
Message-ID: <alpine.DEB.2.00.1202130211400.4324@chino.kir.corp.google.com>
References: <1328902796-30389-1-git-send-email-danms@us.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Feb 2012, Dan Smith wrote:

> The inner function walk_pte_range() increments "addr" by PAGE_SIZE after
> each pte is processed, and only exits the loop if the result is equal to
> "end". Current, if either (or both of) the starting or ending addresses
> passed to walk_page_range() are not page-aligned, then we will never
> satisfy that exit condition and begin calling the pte_entry handler with
> bad data.
> 
> To be sure that we will land in the right spot, this patch checks that
> both "addr" and "end" are page-aligned in walk_page_range() before starting
> the traversal.
> 

It doesn't "ensure" anything without CONFIG_DEBUG_VM enabled, which isn't 
the default.
