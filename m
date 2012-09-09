Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab2IIB0A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 21:26:00 -0400
Received: from server505f.appriver.com ([98.129.35.10]:2290 "EHLO
	server505.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751013Ab2IIBZ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 21:25:59 -0400
X-Note-AR-ScanTimeLocal: 9/8/2012 8:25:58 PM
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
X-Note-Reverse-DNS: smtp.exg5.exghost.com
X-Note-Return-Path: ecashin@coraid.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G285 G286 G287 G288 G292 G293 G304 G395 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
From: Ed Cashin <ecashin@coraid.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Sat, 8 Sep 2012 20:25:53 -0500
Subject: Re: [patch] aoe: cleanup an allocation a bit
Thread-Topic: [patch] aoe: cleanup an allocation a bit
Thread-Index: Ac2OKg+2t3mAOyUWR36tdexkKBydzw==
Message-ID: <F3A3DC24-1380-447B-AA94-A5FADB8D6E43@coraid.com>
References: <20120908095921.GD608@elgon.mountain>
In-Reply-To: <20120908095921.GD608@elgon.mountain>
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

Looks OK to me, thanks.

On Sep 7, 2012, at 11:59 PM, "Dan Carpenter" <dan.carpenter@oracle.com> wrote:

> We changed this recently so we can just use kzalloc() here instead of
> kcalloc(1, ...).  Kernel style prefers sizeof(*t) over sizeof *t.  The
> kfree(t) is a no-op now as well so that can be removed.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Only applies to linux-next.
> 
> diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
> index 5461faa..c0adbbd 100644
> --- a/drivers/block/aoe/aoecmd.c
> +++ b/drivers/block/aoe/aoecmd.c
> @@ -1255,9 +1255,8 @@ addtgt(struct aoedev *d, char *addr, ulong nframes)
>            "aoe: device addtgt failure; too many targets\n");
>        return NULL;
>    }
> -    t = kcalloc(1, sizeof *t, GFP_ATOMIC);
> +    t = kzalloc(sizeof(*t), GFP_ATOMIC);
>    if (!t) {
> -        kfree(t);
>        printk(KERN_INFO "aoe: cannot allocate memory to add target\n");
>        return NULL;
>    }
