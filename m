Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab2HXAxF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 20:53:05 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:39770 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2HXAxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 20:53:02 -0400
Message-ID: <5036D062.7070003@linux.vnet.ibm.com>
Date: Fri, 24 Aug 2012 08:52:50 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
CC: catalin.marinas@arm.com,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] kmemleak: replace list_for_each_continue_rcu with
 new interface
References: <502CB92F.2010700@linux.vnet.ibm.com> <502DC99E.4060408@linux.vnet.ibm.com>
In-Reply-To: <502DC99E.4060408@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12082400-0260-0000-0000-000001BC5166
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2012 12:33 PM, Michael Wang wrote:
> From: Michael Wang <wangyun@linux.vnet.ibm.com>
> 
> This patch replaces list_for_each_continue_rcu() with
> list_for_each_entry_continue_rcu() to save a few lines
> of code and allow removing list_for_each_continue_rcu().

Hi, Catalin

Could I get some comments on this patch?

Regards,
Michael Wang

> 
> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
> ---
>  mm/kmemleak.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index 45eb621..0de83b4 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -1483,13 +1483,11 @@ static void *kmemleak_seq_next(struct seq_file *seq, void *v, loff_t *pos)
>  {
>  	struct kmemleak_object *prev_obj = v;
>  	struct kmemleak_object *next_obj = NULL;
> -	struct list_head *n = &prev_obj->object_list;
> +	struct kmemleak_object *obj = prev_obj;
> 
>  	++(*pos);
> 
> -	list_for_each_continue_rcu(n, &object_list) {
> -		struct kmemleak_object *obj =
> -			list_entry(n, struct kmemleak_object, object_list);
> +	list_for_each_entry_continue_rcu(obj, &object_list, object_list) {
>  		if (get_object(obj)) {
>  			next_obj = obj;
>  			break;
> 

