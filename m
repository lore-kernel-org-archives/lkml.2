Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab2HaQKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 12:10:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59545 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab2HaQKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 12:10:39 -0400
Message-ID: <5040E1FD.3060009@gmail.com>
Date: Fri, 31 Aug 2012 10:10:37 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: "Suzuki K. Poulose" <suzuki@in.ibm.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [perf] Fix intlist node removal
References: <503DB6CD.4070502@gmail.com> <20120831065840.5167.90318.stgit@suzukikp.in.ibm.com>
In-Reply-To: <20120831065840.5167.90318.stgit@suzukikp.in.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/31/12 12:58 AM, Suzuki K. Poulose wrote:
> Similar to the one in :
> 	https://lkml.org/lkml/2012/8/29/27
>
>
> Make sure we remove the node from the rblist before we delete the
> node. The rblist__remove_node() will invoke rblist->node_delete,
> which  will take care of deleting the node with the suitable function
> provided by the user.
>
> Signed-off-by: Suzuki K Poulose <suzuki@in.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> ---
>
>   tools/perf/util/intlist.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/util/intlist.c b/tools/perf/util/intlist.c
> index fd530dc..77c504f 100644
> --- a/tools/perf/util/intlist.c
> +++ b/tools/perf/util/intlist.c
> @@ -52,9 +52,9 @@ int intlist__add(struct intlist *ilist, int i)
>   	return rblist__add_node(&ilist->rblist, (void *)((long)i));
>   }
>
> -void intlist__remove(struct intlist *ilist __used, struct int_node *node)
> +void intlist__remove(struct intlist *ilist, struct int_node *node)
>   {
> -	int_node__delete(node);
> +	rblist__remove_node(&ilist->rblist, &node->rb_node);
>   }
>
>   struct int_node *intlist__find(struct intlist *ilist, int i)
>

Acked-by: David Ahern <dsahern@gmail.com>
