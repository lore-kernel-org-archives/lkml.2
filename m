Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435Ab1HZRJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 13:09:39 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59845 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab1HZRJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 13:09:38 -0400
Subject: Re: [PATCH 05/13] mm: convert shrinkers to use new API
From: Wanlong Gao <wanlong.gao@gmail.com>
Reply-To: wanlong.gao@gmail.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, khlebnikov@openvz.org
In-Reply-To: <1314089786-20535-6-git-send-email-david@fromorbit.com>
References: <1314089786-20535-1-git-send-email-david@fromorbit.com>
	 <1314089786-20535-6-git-send-email-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
Organization: FNST
Date: Sat, 27 Aug 2011 01:09:30 +0800
Message-ID: <1314378570.1987.8.camel@Allen>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-23 at 18:56 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Modify shrink_slab() to use the new .count_objects/.scan_objects API
> and implement the callouts for all the existing shrinkers.

> +static long
> +cifs_idmap_shrinker_scan(struct shrinker *shrink, struct shrink_control *sc)
>  {
> -	int nr_to_scan = sc->nr_to_scan;
> -	int nr_del = 0;
> -	int nr_rem = 0;
>  	struct rb_root *root;
> +	long freed;
>  
>  	root = &uidtree;
>  	spin_lock(&siduidlock);
> -	shrink_idmap_tree(root, nr_to_scan, &nr_rem, &nr_del);
> +	freed = shrink_idmap_tree(root, sc->nr_to_scan);
>  	spin_unlock(&siduidlock);
>  
>  	root = &gidtree;
>  	spin_lock(&sidgidlock);
> -	shrink_idmap_tree(root, nr_to_scan, &nr_rem, &nr_del);
> +	freed += shrink_idmap_tree(root, sc->nr_to_scan);
>  	spin_unlock(&sidgidlock);
>  
> -	return nr_rem;
> +	return freed;
> +}
> +
> +/*
> + * This still abuses the nr_to_scan == 0 trick to get the common code just to
> + * count objects. There neds to be an external count of the objects in the

			  ^^^^^?
Hi Dave:
Great work. a bit comments.
Thanks
-Wanlong Gao


