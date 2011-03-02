Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab1CBQiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 11:38:00 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59734 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036Ab1CBQh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 11:37:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gaISJlEuOP+QH0kirpAk9p1XHB08D5aOg9edpJ4M8HTrk87B+OgA/STt1y3VvzKq8o
         Axx6HuvzaybrutwWL7cv1rgnFwWWcnFFYOXtrNVrh2gFv1C4sKGpmjh24HA4mvFZo/Ao
         S9LYBEdwULxzMUU76I80HvtVHmKbkFd6ZeQ9M=
Date: Wed, 2 Mar 2011 17:37:29 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm UPDATED] x86-64, NUMA: Fix distance table
 handling
Message-ID: <20110302163729.GQ3319@htj.dyndns.org>
References: <20110224145128.GM7840@htj.dyndns.org>
 <4D66AC9C.6080500@kernel.org>
 <20110224192305.GB15498@elte.hu>
 <4D66B176.9030300@kernel.org>
 <alpine.DEB.2.00.1103010844430.19743@chino.kir.corp.google.com>
 <20110302100400.GK19669@htj.dyndns.org>
 <20110302102530.GB3319@htj.dyndns.org>
 <4D6E6D52.8030901@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6E6D52.8030901@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Yinghai.

On Wed, Mar 02, 2011 at 08:16:18AM -0800, Yinghai Lu wrote:
> my original part:
> 
> @@ -393,7 +393,7 @@ void __init numa_reset_distance(void)
>         size_t size;
>  
>         if (numa_distance_cnt) {
> -               size = numa_distance_cnt * sizeof(numa_distance[0]);
> +               size = numa_distance_cnt * numa_distance_cnt * sizeof(numa_distance[0]);
>                 memblock_x86_free_range(__pa(numa_distance),
>                                         __pa(numa_distance) + size);
>                 numa_distance_cnt = 0;
> 
> So can you tell me why you need to make those change?
> 	move out assigning or numa_distance_cnt and size of the the IF

Please read the patch description.  I actually wrote that down.  :-)

> the change include:
> 1. you only need to go over new_nr*new_nr instead huge MAX_NUMNODES * MAX_NUMNODES
> 2. you do NOT need to go over it if you don't have phys_dist assigned before.
>    numa_alloc_distance already have that default set.
> 3. do need to check if phys_dist is assigned before referring phys_dist.

* If you wanted to make that change, split it into a separate patch.
  Don't mix it with changes which actually fix the bug.

* I don't think it's gonna matter all that much.  It's one time and
  only used if emulation is enabled, but then again yeap MAX_NUMNODES
  * MAX_NUMNODES can get quite high, but it looks way too complicated
  for what it achieves.  Just looping over enabled nodes should
  achieve about the same thing in much simpler way, right?

Thanks.

-- 
tejun
