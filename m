Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030337Ab2LGNUQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 08:20:16 -0500
Received: from server505h.appriver.com ([98.129.35.13]:1066 "EHLO
	server505.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030293Ab2LGNUO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 08:20:14 -0500
X-Note-AR-ScanTimeLocal: 12/7/2012 7:20:12 AM
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Primary: ecashin@coraid.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: @coraid.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: UNKNOWN->UNITED STATES->UNITED STATES
X-Note-Sending-IP: 98.129.35.1
X-Note-Reverse-DNS: 
X-Note-Return-Path: ecashin@coraid.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G328 G329 G330 G331 G335 G336 G347 G443 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
From: Ed Cashin <ecashin@coraid.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Fri, 7 Dec 2012 07:20:10 -0600
Subject: Re: [patch] aoe: use after free in aoedev_by_aoeaddr()
Thread-Topic: [patch] aoe: use after free in aoedev_by_aoeaddr()
Thread-Index: Ac3UfZW+wlge//ktRYOujiKDxRHR2Q==
Message-ID: <A578B7C2-D1FA-4F14-999F-E4CAA4816BB3@coraid.com>
References: <20121207061943.GC18220@elgon.mountain>
In-Reply-To: <20121207061943.GC18220@elgon.mountain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 7, 2012, at 1:19 AM, Dan Carpenter wrote:

> We should return NULL on failure instead of returning a freed pointer.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
> index e66ccbf..98f2965 100644
> --- a/drivers/block/aoe/aoedev.c
> +++ b/drivers/block/aoe/aoedev.c
> @@ -461,6 +461,7 @@ aoedev_by_aoeaddr(ulong maj, int min, int do_alloc)
> 	d->targets = kcalloc(NTARGETS, sizeof(*d->targets), GFP_ATOMIC);
> 	if (!d->targets) {
> 		kfree(d);
> +		d = NULL;
> 		goto out;
> 	}
> 	d->ntargets = NTARGETS;


That looks good, thanks.

If smatch found that, then I have to figure out what I'm doing wrong, because
I ran sparse and smatch on the latest patch series until they were clean.  :/

-- 
  Ed Cashin
  ecashin@coraid.com


