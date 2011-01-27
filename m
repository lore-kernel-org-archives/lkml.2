Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab1A0APN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 19:15:13 -0500
Received: from mail.perches.com ([173.55.12.10]:3396 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754376Ab1A0APM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 19:15:12 -0500
Subject: Re: [PATCH] use %pK for /proc/kallsyms and /proc/modules
From: Joe Perches <joe@perches.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Tejun Heo <tj@kernel.org>, Marcus Meissner <meissner@suse.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Eugene Teo <eugeneteo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, Len Brown <len.brown@intel.com>,
        Changli Gao <xiaosuo@gmail.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>
In-Reply-To: <20110125181058.GA25670@outflux.net>
References: <20110125181058.GA25670@outflux.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jan 2011 16:15:09 -0800
Message-ID: <1296087309.2448.33.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-25 at 10:10 -0800, Kees Cook wrote:
> Note that when compiling with -Wformat, these harmless warnings will
> be emitted, and can be ignored:
>   warning: '0' flag used with ‘%p’ gnu_printf format

> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
[]
> @@ -477,11 +477,11 @@ static int s_show(struct seq_file *m, void *p)
>  		 */
>  		type = iter->exported ? toupper(iter->type) :
>  					tolower(iter->type);
> -		seq_printf(m, "%0*lx %c %s\t[%s]\n",
> +		seq_printf(m, "%0*pK %c %s\t[%s]\n",
>  			   (int)(2 * sizeof(void *)),
>  			   iter->value, type, iter->name, iter->module_name);

You can change this to

		seq_printf(m, "%pK %c %s\t[%s]\n",
  			   iter->value, type, iter->name, iter->module_name);

as that's the normal size.

Presto.  No warnings.  Same output.

>  	} else
> -		seq_printf(m, "%0*lx %c %s\n",
> +		seq_printf(m, "%0*pK %c %s\n",
>  			   (int)(2 * sizeof(void *)),

Here too.

