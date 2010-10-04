Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559Ab0JDTnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 15:43:39 -0400
Received: from smtp-out.google.com ([74.125.121.35]:30720 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193Ab0JDTni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 15:43:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=OCtFNUK4j4Eg0Cud7DIbkkCPryQTCLLQGtmRODHMCuKZgRmfQKHLpsPxDhzxsTHxWQ
         6UQx58sr9OkYgA+gKMbg==
Date: Mon, 4 Oct 2010 12:43:27 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Christoph Lameter <cl@linux.com>, Mel Gorman <mel@csn.ul.ie>,
        Rob Mueller <robm@fastmail.fm>, linux-kernel@vger.kernel.org,
        Bron Gondwana <brong@fastmail.fm>, linux-mm <linux-mm@kvack.org>
Subject: Re: Default zone_reclaim_mode = 1 on NUMA kernel is bad forfile/email/web
 servers
In-Reply-To: <20101004211112.E8B1.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1010041242330.29747@chino.kir.corp.google.com>
References: <20100927110049.6B31.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1009270828510.7000@router.home> <20101004211112.E8B1.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Oct 2010, KOSAKI Motohiro wrote:

> Recently, Robert Mueller reported zone_reclaim_mode doesn't work
> properly on his new NUMA server (Dual Xeon E5520 + Intel S5520UR MB).
> He is using Cyrus IMAPd and it's built on a very traditional
> single-process model.
> 
>   * a master process which reads config files and manages the other
>     process
>   * multiple imapd processes, one per connection
>   * multiple pop3d processes, one per connection
>   * multiple lmtpd processes, one per connection
>   * periodical "cleanup" processes.
> 
> Then, there are thousands of independent processes. The problem is,
> recent Intel motherboard turn on zone_reclaim_mode by default and
> traditional prefork model software don't work fine on it.
> Unfortunatelly, Such model is still typical one even though 21th
> century. We can't ignore them.
> 
> This patch raise zone_reclaim_mode threshold to 30. 30 don't have
> specific meaning. but 20 mean one-hop QPI/Hypertransport and such
> relatively cheap 2-4 socket machine are often used for tradiotional
> server as above. The intention is, their machine don't use
> zone_reclaim_mode.
> 
> Note: ia64 and Power have arch specific RECLAIM_DISTANCE definition.
> then this patch doesn't change such high-end NUMA machine behavior.
> 
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Bron Gondwana <brong@fastmail.fm>
> Cc: Robert Mueller <robm@fastmail.fm>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Acked-by: David Rientjes <rientjes@google.com>

We already do this, but I guess it never got pushed to mainline.
