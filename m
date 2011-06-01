Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244Ab1FASmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 14:42:16 -0400
Received: from smtp-out.google.com ([216.239.44.51]:19339 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab1FASmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 14:42:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=KJlZrUJ1ZlGNCdMOI6yMcSNkUe9vpIYsNh0Yb17/Wp2144HEMefhwo4g8gvsLQOJHY
         a+M4UbuhC+tFEqzGly0Q==
Date: Wed, 1 Jun 2011 11:42:09 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Make GFP_DMA allocations w/o ZONE_DMA emit a warning
 instead of failing
In-Reply-To: <BANLkTinrviHh40fTfqyeB=SrcNS0yqZM0w@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1106011140050.16198@chino.kir.corp.google.com>
References: <1306922672-9012-1-git-send-email-dbaryshkov@gmail.com> <BANLkTinBkdVd90g3-uiQP41z1S1sXUdRmQ@mail.gmail.com> <BANLkTikrRRzGLbMD47_xJz+xpgftCm1C2A@mail.gmail.com> <alpine.DEB.2.00.1106011017260.13089@chino.kir.corp.google.com>
 <BANLkTinrviHh40fTfqyeB=SrcNS0yqZM0w@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jun 2011, Dmitry Eremin-Solenikov wrote:

> > So you want to continue to allow the page allocator to return pages from
> > anywhere, even when GFP_DMA is specified, just as though it was lowmem?
> 
> Yes and no. I'm asking for the grace period for the drivers authors to be able
> to fix their code. After a grace period of one or two majors this permission
> should be removed and your original patch should be effective.
> 

You don't need to wait for the code to be fixed, you just need to enable 
CONFIG_ZONE_DMA.  This is a configuration issue.  If that GFP_DMA can be 
removed later, that's great, but right now it requires it.  Why can't you 
enable the config option?
