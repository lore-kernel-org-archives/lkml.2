Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259Ab2ECTX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 15:23:56 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56051 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751933Ab2ECTXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 15:23:55 -0400
Message-ID: <1336073032.13866.42.camel@joe2Laptop>
Subject: Re: [PATCH 2/3] params: replace printk(KERN_<LVL>...) with
 pr_<lvl>(...)
From: Joe Perches <joe@perches.com>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        jbaron@redhat.com
Date: Thu, 03 May 2012 12:23:52 -0700
In-Reply-To: <1336072371-23314-1-git-send-email-jim.cromie@gmail.com>
References: <1336072371-23314-1-git-send-email-jim.cromie@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-03 at 13:12 -0600, Jim Cromie wrote:
> I left 1 printk which uses __FILE__, __LINE__ explicitly, which should
> not be subject to generic preferences expressed via pr_fmt().
[]
> diff --git a/kernel/params.c b/kernel/params.c
[]
> @@ -753,11 +747,9 @@ static struct module_kobject * __init locate_module_kobject(const char *name)
>  #endif
>  		if (err) {
>  			kobject_put(&mk->kobj);
> -			printk(KERN_ERR
> -				"Module '%s' failed add to sysfs, error number %d\n",
> +			pr_crit("Adding module '%s' to sysfs failed (%d), "
> +				"the system may be unstable.\n",
>  				name, err);
> -			printk(KERN_ERR
> -				"The system will be unstable now.\n");
>  			return NULL;
>  		}
>  

It'd be nicer to coalesce the formats and not worry about 80 columns.
Coalesced formats are easier to find via grep.

			pr_crit("Adding module '%s' to sysfs failed (%d), the system may be unstable\n",


