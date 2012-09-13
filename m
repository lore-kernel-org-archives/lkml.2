Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab2IMBlQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 21:41:16 -0400
Received: from server505h.appriver.com ([98.129.35.13]:3765 "EHLO
	server505.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751764Ab2IMBlP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 21:41:15 -0400
X-Note-AR-ScanTimeLocal: 9/12/2012 8:41:13 PM
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
X-Note: Global Rule Hits: G299 G300 G301 G302 G306 G307 G318 G409 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
From: Ed Cashin <ecashin@coraid.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 12 Sep 2012 20:41:09 -0500
Subject: Re: [PATCH 1/9] drivers/block/aoe/aoecmd.c: Remove useless kfree
Thread-Topic: [PATCH 1/9] drivers/block/aoe/aoecmd.c: Remove useless kfree
Thread-Index: Ac2RUNsf9t3DVDCITJmhGZuh8M9LEQ==
Message-ID: <2A87C8FF-BD7F-46EA-8C08-29A9AB176DCD@coraid.com>
References: <1347462407-13499-1-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1347462407-13499-1-git-send-email-peter.senna@gmail.com>
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

There's a patch in the mm tree that already makes this change, thanks.

Sent from my iPhone

On Sep 12, 2012, at 5:08 AM, "Peter Senna Tschudin" <peter.senna@gmail.com> wrote:

> From: Peter Senna Tschudin <peter.senna@gmail.com>
> 
> Remove useless kfree() and clean up code related to the removal.
> 
> The semantic patch that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r exists@
> position p1,p2;
> expression x;
> @@
> 
> if (x@p1 == NULL) { ... kfree@p2(x); ... return ...; }
> 
> @unchanged exists@
> position r.p1,r.p2;
> expression e <= r.x,x,e1;
> iterator I;
> statement S;
> @@
> 
> if (x@p1 == NULL) { ... when != I(x,...) S
>                        when != e = e1
>                        when != e += e1
>                        when != e -= e1
>                        when != ++e
>                        when != --e
>                        when != e++
>                        when != e--
>                        when != &e
>   kfree@p2(x); ... return ...; }
> 
> @ok depends on unchanged exists@
> position any r.p1;
> position r.p2;
> expression x;
> @@
> 
> ... when != true x@p1 == NULL
> kfree@p2(x);
> 
> @depends on !ok && unchanged@
> position r.p2;
> expression x;
> @@
> 
> *kfree@p2(x);
> // </smpl>
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> 
> ---
> drivers/block/aoe/aoecmd.c |    1 -
> 1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
> index 5461faa..cbb0521 100644
> --- a/drivers/block/aoe/aoecmd.c
> +++ b/drivers/block/aoe/aoecmd.c
> @@ -1257,7 +1257,6 @@ addtgt(struct aoedev *d, char *addr, ulong nframes)
>    }
>    t = kcalloc(1, sizeof *t, GFP_ATOMIC);
>    if (!t) {
> -        kfree(t);
>        printk(KERN_INFO "aoe: cannot allocate memory to add target\n");
>        return NULL;
>    }
> 
