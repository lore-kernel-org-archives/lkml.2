Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab2BTVaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 16:30:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911Ab2BTV37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 16:29:59 -0500
Date: Mon, 20 Feb 2012 22:29:55 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Dean Nelson <dnelson@redhat.com>
Cc: linux-mm@kvack.org, Jin Dongming <jin.dongming@np.css.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thp: allow a hwpoisoned head page to be put back to LRU
Message-ID: <20120220212955.GD10222@redhat.com>
References: <20120220211040.8887.22420.email-sent-by-dnelson@aqua>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120220211040.8887.22420.email-sent-by-dnelson@aqua>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 04:10:40PM -0500, Dean Nelson wrote:
> Andrea Arcangeli pointed out to me that a check in __memory_failure() which
> was intended to prevent THP tail pages from being checked for the absence
> of the PG_lru flag (something that is always the case), was also preventing
> THP head pages from being checked.
> 
> A THP head page could actually benefit from the call to shake_page() by
> ending up being put back to a LRU, provided it had been waiting in a
> pagevec array.
> 
> Andrea suggested that the "!PageTransCompound(p)" in the if-statement
> should be replaced by a "!PageTransTail(p)", thus allowing THP head pages
> to be checked and possibly shaken.
> 
> Signed-off-by: Dean Nelson <dnelson@redhat.com>

Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
