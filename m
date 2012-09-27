Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab2I0PQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 11:16:40 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:54784 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754855Ab2I0PQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 11:16:39 -0400
X-Greylist: delayed 578 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Sep 2012 11:16:39 EDT
Date: Thu, 27 Sep 2012 15:07:00 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Glauber Costa <glommer@parallels.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 4/4] sl[au]b: process slabinfo_show in common code
In-Reply-To: <1348756660-16929-5-git-send-email-glommer@parallels.com>
Message-ID: <0000013a08443b02-5715bfe6-9c47-49c5-a951-8a48cc432e42-000000@email.amazonses.com>
References: <1348756660-16929-1-git-send-email-glommer@parallels.com> <1348756660-16929-5-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2012, Glauber Costa wrote:

> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -239,7 +239,23 @@ static void s_stop(struct seq_file *m, void *p)
>
>  static int s_show(struct seq_file *m, void *p)
>  {
> -	return slabinfo_show(m, p);
> +	struct kmem_cache *s = list_entry(p, struct kmem_cache, list);
> +	struct slabinfo sinfo;
> +
> +	memset(&sinfo, 0, sizeof(sinfo));
> +	get_slabinfo(s, &sinfo);

Could get_slabinfo() also set the objects per slab etc in some additional
field in struct slabinfo? Then we can avoid the exporting of the oo_
functions and we do not need the cache_order() etc functions.

