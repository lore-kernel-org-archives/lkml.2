Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349Ab0KWIyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 03:54:11 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51148 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab0KWIyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 03:54:09 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Subject: Re: [PATCH 1/2] kmsg_dump: adding to reboot, halt, poweroff and emergency_restart path
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        "Artem.Bityutskiy@nokia.com" <Artem.Bityutskiy@nokia.com>,
        "simon.kagstrom@netinsight.net" <simon.kagstrom@netinsight.net>,
        "David.Woodhouse@intel.com" <David.Woodhouse@intel.com>,
        "anders.grafstrom@netinsight.net" <anders.grafstrom@netinsight.net>,
        "jason.wessel@windriver.com" <jason.wessel@windriver.com>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "eparis@redhat.com" <eparis@redhat.com>, "hch@lst.de" <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "marco.stornelli@gmail.com" <marco.stornelli@gmail.com>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        Aaron Durbin <adurbin@google.com>,
        "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C12D6E2FA@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C12D6E2F5@USINDEVS01.corp.hds.com> <5C4C569E8A4B9B42A84A977CF070A35B2C12D6E2FA@USINDEVS01.corp.hds.com>
Message-Id: <20101123175405.7BCB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 23 Nov 2010 17:54:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch alters mtdoops and ramoops to perform their actions only for KMSG_DUMP_PANIC,
> KMSG_DUMP_OOPS and KMSG_DUMP_KEXEC because they would like to log crashes only.
> 
>  Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
> 
> ---
>  drivers/char/ramoops.c |    5 +++++
>  drivers/mtd/mtdoops.c  |    5 +++++
>  2 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c index 73dcb0e..8998b29 100644
> --- a/drivers/char/ramoops.c
> +++ b/drivers/char/ramoops.c
> @@ -69,6 +69,11 @@ static void ramoops_do_dump(struct kmsg_dumper *dumper,
>  	char *buf;
>  	struct timeval timestamp;
>  
> +	if (reason != KMSG_DUMP_OOPS &&
> +	    reason != KMSG_DUMP_PANIC &&
> +	    reason != KMSG_DUMP_KEXEC)
> +		return;
> +
>  	/* Only dump oopses if dump_oops is set */
>  	if (reason == KMSG_DUMP_OOPS && !dump_oops)
>  		return;
> diff --git a/drivers/mtd/mtdoops.c b/drivers/mtd/mtdoops.c index 1ee72f3..c948150 100644
> --- a/drivers/mtd/mtdoops.c
> +++ b/drivers/mtd/mtdoops.c
> @@ -307,6 +307,11 @@ static void mtdoops_do_dump(struct kmsg_dumper *dumper,
>  	unsigned long l1_cpy, l2_cpy;
>  	char *dst;
>  
> +	if (reason != KMSG_DUMP_OOPS &&
> +	    reason != KMSG_DUMP_PANIC &&
> +	    reason != KMSG_DUMP_KEXEC)
> +		return;
> +
>  	/* Only dump oopses if dump_oops is set */
>  	if (reason == KMSG_DUMP_OOPS && !dump_oops)
>  		return;

Looks good.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



