Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab1BVSYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 13:24:16 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55239 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084Ab1BVSYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 13:24:15 -0500
Date: Tue, 22 Feb 2011 19:24:14 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <cl@linux.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, aarcange@redhat.com,
        lwoodman@redhat.com, Andi Kleen <ak@linux.intel.com>,
        arcange@redhat.com
Subject: Re: [PATCH 3/8] Preserve local node for KSM copies
Message-ID: <20110222182414.GA5818@one.firstfloor.org>
References: <1298315270-10434-1-git-send-email-andi@firstfloor.org> <1298315270-10434-4-git-send-email-andi@firstfloor.org> <alpine.DEB.2.00.1102220945210.16060@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1102220945210.16060@router.home>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 09:47:26AM -0600, Christoph Lameter wrote:
> On Mon, 21 Feb 2011, Andi Kleen wrote:
> 
> > Add a alloc_page_vma_node that allows passing the "local" node in.
> > Use it in ksm to allocate copy pages on the same node as
> > the original as possible.
> 
> Why would that be useful? The shared page could be on a node that is not
> near the process that maps the page. Would it not be better to allocate on
> the node that is local to the process that maps the page?

Either could be wrong, but not moving the mappings seems most deterministic
to me. At least one of the processes (whoever allocated the page first) 
will stay with its local memory.

Also the alloc_page_vma_node() call is used for THP too. I guess i should
split it out.

-Andi
