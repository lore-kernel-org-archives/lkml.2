Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083Ab1CCCc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 21:32:28 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60587 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab1CCCc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 21:32:27 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 3 Mar 2011 11:26:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 5/8] Use correct numa policy node for transparent
 hugepages
Message-Id: <20110303112604.aa4352ca.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1299113128-11349-6-git-send-email-andi@firstfloor.org>
References: <1299113128-11349-1-git-send-email-andi@firstfloor.org>
	<1299113128-11349-6-git-send-email-andi@firstfloor.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  2 Mar 2011 16:45:25 -0800
Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> Pass down the correct node for a transparent hugepage allocation.
> Most callers continue to use the current node, however the hugepaged
> daemon now uses the previous node of the first to be collapsed page
> instead. This ensures that khugepaged does not mess up local memory
> for an existing process which uses local policy.
> 
> The choice of node is somewhat primitive currently: it just
> uses the node of the first page in the pmd range. An alternative
> would be to look at multiple pages and use the most popular
> node. I used the simplest variant for now which should work
> well enough for the case of all pages being on the same node.
> 
> Acked-by: Andrea Arcangeli <aarcange@redhat.com>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

