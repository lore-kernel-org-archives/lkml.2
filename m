Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab2ATQ2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 11:28:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60890 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab2ATQ2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 11:28:14 -0500
Date: Fri, 20 Jan 2012 16:28:01 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Pradheep Shrinivasan <pradheep.sh@gmail.com>, greg@kroah.com,
        devel@linuxdriverproject.org, swetland@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] staging:android_pmem.h: Fixes the space and other
 formating issues pointed out by checkpatch.pl
Message-ID: <20120120162801.GE2744@shadowen.org>
References: <1326856764-2531-1-git-send-email-pradheep.sh@gmail.com>
 <20120118065620.GE3294@mwanda>
 <CANz8tm1imZ3njy_uV0tkq0sXwyB5ZLLJsrp4G1zjcBDnJUrjiw@mail.gmail.com>
 <20120118185457.GH3356@mwanda>
 <CAAq6er0OPkvTCLt1DvHSjyqM4pH7GMb-D78M09cJY+1ZV3miiQ@mail.gmail.com>
 <20120120115408.GL3356@mwanda>
 <1327066144.6176.27.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327066144.6176.27.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 05:29:04AM -0800, Joe Perches wrote:
> On Fri, 2012-01-20 at 14:54 +0300, Dan Carpenter wrote:
> > It still complains about the following macros where parenthesis are
> > not needed.
> > 
> > ERROR: Macros with complex values should be enclosed in parenthesis
> > #156: FILE: staging/android/pmem.c:156:
> > +#define PMEM_IS_FREE(id, index) !(pmem[id].bitmap[index].allocated)
> > 
> > Let's just make the check look for an operator with a low
> > precedence.
> > http://en.wikipedia.org/wiki/Order_of_operations#Programming_languages
> > 
> > Otherwise the submitters are going to change it to:
> > 
> > #define PMEM_IS_FREE(id, index) (!(pmem[id].bitmap[index].allocated))
> > 
> > That has two pairs of unneeded paranthesis and we run the risk of
> > reprogramming the kernel in lisp, by mistake.
> 
> I think the outer parens are necessary.
> Imagine PMEM_IS_FREE(foo, bar).another_dereference


I don't believe that makes any sense does it, those are pointer
operations, and passing 0/1 to those is going to make the . very
unhappy.  But that is why I am only proposing to do the three which are
non-sensicle on pointers.

-apw
