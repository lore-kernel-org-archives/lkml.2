Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759691Ab2EJOOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 10:14:41 -0400
Received: from nm15.access.bullet.mail.mud.yahoo.com ([66.94.237.216]:21668
	"HELO nm15.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751187Ab2EJOOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 10:14:39 -0400
X-Yahoo-Newman-Id: 174853.43242.bm@smtp103.biz.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Ma2xpjsVM1m1QN5YRIsvMRzhut.XE9FZGPW5AduEIudPAtI
 heuFpx4zZW1Qq5mSOax_YAR6LD_ZdZMgilkwMJ012NIIdtPowCep2xsPi2eP
 58Aj9fgoiePSte3yGQ3wh.hC232HXYRuCBG6slQZymtWIj9VBWbBLfJxSkQd
 TWbf1VwDl2xVmfUdj3D9FZEbUxe19Xw0fW4Yl45MgAxLaUexqW7LjecAJpab
 q2O4sEGMZtSHaZSDL.Ry0Bht.VK7R1wGwTVwOmWGHXRoiFICY7fkqI7DQtby
 aFs.k2JJ463BolUUfaYdBa0bs_lzT2xQOyI4.xF5EMeKZHaXRsgwtAUlELiz
 CjAlUdwbBG8QhIPIB94Ftu8hgQI5jLrRqF8tDrz_IFttbzzmCedKaCxrTkFo
 QbcZaZ10MI7WihDgBqyK9yhJywEGSnnjTuBua5Zcbhs8r0IQ-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4FABCD55.9000504@schaufler-ca.com>
Date: Thu, 10 May 2012 07:14:45 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-Netdev <netdev@vger.kernel.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Neil Brown <neilb@suse.de>, Christoph Hellwig <hch@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>,
        LSM <linux-security-module@vger.kernel.org>,
        SE Linux <selinux@tycho.nsa.gov>
Subject: Re: [PATCH 02/12] selinux: tag avc cache alloc as non-critical
References: <1336658065-24851-1-git-send-email-mgorman@suse.de> <1336658065-24851-3-git-send-email-mgorman@suse.de>
In-Reply-To: <1336658065-24851-3-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/10/2012 6:54 AM, Mel Gorman wrote:
> Failing to allocate a cache entry will only harm performance not
> correctness.  Do not consume valuable reserve pages for something
> like that.

Copying to the LSM and SELinux lists.
 
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>  security/selinux/avc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/security/selinux/avc.c b/security/selinux/avc.c
> index 8ee42b2..75c2977 100644
> --- a/security/selinux/avc.c
> +++ b/security/selinux/avc.c
> @@ -280,7 +280,7 @@ static struct avc_node *avc_alloc_node(void)
>  {
>  	struct avc_node *node;
>  
> -	node = kmem_cache_zalloc(avc_node_cachep, GFP_ATOMIC);
> +	node = kmem_cache_zalloc(avc_node_cachep, GFP_ATOMIC|__GFP_NOMEMALLOC);
>  	if (!node)
>  		goto out;
>  

