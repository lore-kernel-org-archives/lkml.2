Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab1JCKZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 06:25:52 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54065 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084Ab1JCKZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 06:25:45 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 3 Oct 2011 19:24:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Wei Yang <weiyang.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: One comment on the __release_region in kernel/resource.c
Message-Id: <20111003192458.14d198a3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <CADLM8XNiaxLFRZXs4NKJmoORvED-DV0bNxPF6eHsfnLqtxw09w@mail.gmail.com>
References: <CADLM8XNiaxLFRZXs4NKJmoORvED-DV0bNxPF6eHsfnLqtxw09w@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Oct 2011 21:57:07 +0800
Wei Yang <weiyang.kernel@gmail.com> wrote:

> Dear experts,
> 
> I am viewing the source code of __release_region() in kernel/resource.c.
> And I have one comment for the performance issue.
> 
> For example, we have a resource tree like this.
> 10-89
>    20-79
>        30-49
>        55-59
>        60-64
>        65-69
>    80-89
> 100-279
> 
> If the caller wants to release a region of [50,59], the original code will
> execute four times in the for loop in the subtree of 20-79.
> 
> After changing the code below, it will execute two times instead.
> 
> By using the "git annotate", I see this code is committed by Linus as the
> initial version. So don't get more information about why this code is
> written
> in this way.
> 
> Maybe the case I thought will not happen in the real world?
> 
> Your comment is warmly welcome. :)
> 
> diff --git a/kernel/resource.c b/kernel/resource.c
> index 8461aea..81525b4 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -931,7 +931,7 @@ void __release_region(struct resource *parent,
> resource_size_t start,
>        for (;;) {
>                struct resource *res = *p;
> 
> -               if (!res)
> +               if (!res || res->start > start)

Hmm ?
	res->start > end ?


Thanks,
-Kame

