Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab0IFJCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 05:02:35 -0400
Received: from smtp-out.google.com ([74.125.121.35]:10897 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab0IFJCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 05:02:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=sctwRDxY2wBkJ29zpE6LHLTI/lWaAu/WXwnifVf1Vx0jhpdI34B78ftSw0z/IKI/l
	zSP34q+9sRmaFUK4v04VA==
Date: Mon, 6 Sep 2010 02:02:27 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Kulikov Vasiliy <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 13/14] mm: mempolicy: Check return code of check_range
In-Reply-To: <20100906093610.C8B5.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1009060201000.10552@chino.kir.corp.google.com>
References: <1283711588-7628-1-git-send-email-segooon@gmail.com> <20100906093610.C8B5.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Sep 2010, KOSAKI Motohiro wrote:

> > From: Vasiliy Kulikov <segooon@gmail.com>
> > 
> > Function check_range may return ERR_PTR(...). Check for it.
> 
> When happen this issue?
> 
> afaik, check_range return error when following condition.
>  1) mm->mmap->vm_start argument is incorrect
>  2) don't have neigher MPOL_MF_STATS, MPOL_MF_MOVE and MPOL_MF_MOVE_ALL
> 
> I think both case is not happen in real. Am I overlooking anything?
> 

There's no reason not to check the return value of a function when the 
implementation of either could change at any time.  migrate_to_node() is 
certainly not in any fastpath where we can't sacrifice a branch for more 
robust code.
