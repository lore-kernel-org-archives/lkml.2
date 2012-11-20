Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab2KTJSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 04:18:30 -0500
Received: from mx2.parallels.com ([64.131.90.16]:33285 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103Ab2KTJS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 04:18:28 -0500
Message-ID: <50AB4ADB.6090506@parallels.com>
Date: Tue, 20 Nov 2012 13:18:19 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Zdenek Kabelac <zkabelac@redhat.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Jiri Slaby <jslaby@suse.cz>, <Valdis.Kletnieks@vt.edu>,
        Jiri Slaby <jirislaby@gmail.com>, <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: Re: [PATCH] Revert "mm: remove __GFP_NO_KSWAPD"
References: <20121012135726.GY29125@suse.de> <507BDD45.1070705@suse.cz> <20121015110937.GE29125@suse.de> <5093A3F4.8090108@redhat.com> <5093A631.5020209@suse.cz> <509422C3.1000803@suse.cz> <509C84ED.8090605@linux.vnet.ibm.com> <509CB9D1.6060704@redhat.com> <20121109090635.GG8218@suse.de> <509F6C2A.9060502@redhat.com> <20121112113731.GS8218@suse.de>
In-Reply-To: <20121112113731.GS8218@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2012 03:37 PM, Mel Gorman wrote:
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 02c1c971..d0a7967 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -31,6 +31,7 @@ struct vm_area_struct;
>  #define ___GFP_THISNODE		0x40000u
>  #define ___GFP_RECLAIMABLE	0x80000u
>  #define ___GFP_NOTRACK		0x200000u
> +#define ___GFP_NO_KSWAPD	0x400000u
>  #define ___GFP_OTHER_NODE	0x800000u
>  #define ___GFP_WRITE		0x1000000u

Keep in mind that this bit has been reused in -mm.
If this patch needs to be reverted, we'll need to first change
the definition of __GFP_KMEMCG (and __GFP_BITS_SHIFT as a result), or it
would break things.

