Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab2ATN3K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 08:29:10 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:45057 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751820Ab2ATN3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 08:29:07 -0500
Message-ID: <1327066144.6176.27.camel@joe2Laptop>
Subject: Re: [PATCH 1/6] staging:android_pmem.h: Fixes the space and other
 formating issues pointed out by checkpatch.pl
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andy Whitcroft <apw@canonical.com>,
        Pradheep Shrinivasan <pradheep.sh@gmail.com>, greg@kroah.com,
        devel@linuxdriverproject.org, swetland@google.com,
        linux-kernel@vger.kernel.org
Date: Fri, 20 Jan 2012 05:29:04 -0800
In-Reply-To: <20120120115408.GL3356@mwanda>
References: <1326856764-2531-1-git-send-email-pradheep.sh@gmail.com>
	 <20120118065620.GE3294@mwanda>
	 <CANz8tm1imZ3njy_uV0tkq0sXwyB5ZLLJsrp4G1zjcBDnJUrjiw@mail.gmail.com>
	 <20120118185457.GH3356@mwanda>
	 <CAAq6er0OPkvTCLt1DvHSjyqM4pH7GMb-D78M09cJY+1ZV3miiQ@mail.gmail.com>
	 <20120120115408.GL3356@mwanda>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-20 at 14:54 +0300, Dan Carpenter wrote:
> It still complains about the following macros where parenthesis are
> not needed.
> 
> ERROR: Macros with complex values should be enclosed in parenthesis
> #156: FILE: staging/android/pmem.c:156:
> +#define PMEM_IS_FREE(id, index) !(pmem[id].bitmap[index].allocated)
> 
> Let's just make the check look for an operator with a low
> precedence.
> http://en.wikipedia.org/wiki/Order_of_operations#Programming_languages
> 
> Otherwise the submitters are going to change it to:
> 
> #define PMEM_IS_FREE(id, index) (!(pmem[id].bitmap[index].allocated))
> 
> That has two pairs of unneeded paranthesis and we run the risk of
> reprogramming the kernel in lisp, by mistake.

I think the outer parens are necessary.
Imagine PMEM_IS_FREE(foo, bar).another_dereference


