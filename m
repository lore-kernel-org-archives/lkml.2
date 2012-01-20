Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab2ATMSs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 07:18:48 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:63554 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab2ATMSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 07:18:47 -0500
MIME-Version: 1.0
In-Reply-To: <20120120115408.GL3356@mwanda>
References: <1326856764-2531-1-git-send-email-pradheep.sh@gmail.com>
	<20120118065620.GE3294@mwanda>
	<CANz8tm1imZ3njy_uV0tkq0sXwyB5ZLLJsrp4G1zjcBDnJUrjiw@mail.gmail.com>
	<20120118185457.GH3356@mwanda>
	<CAAq6er0OPkvTCLt1DvHSjyqM4pH7GMb-D78M09cJY+1ZV3miiQ@mail.gmail.com>
	<20120120115408.GL3356@mwanda>
Date: Fri, 20 Jan 2012 12:18:45 +0000
X-Google-Sender-Auth: NkqoCusbGZf2EQ8iiVRllw7XmEg
Message-ID: <CAAq6er2K2TaBm_NUgs5E7LbWhZZLwd_kNzPf=kpbtCvccr7kRw@mail.gmail.com>
Subject: Re: [PATCH 1/6] staging:android_pmem.h: Fixes the space and other
 formating issues pointed out by checkpatch.pl
From: Andy Whitcroft <apw@canonical.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Pradheep Shrinivasan <pradheep.sh@gmail.com>, greg@kroah.com,
        devel@linuxdriverproject.org, swetland@google.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 11:54 AM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
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

Yep we want to avoid that.  As -> binds tighter than many of the
operators in these bands we can only safely avoid the ()'s if the
operator does not potentially make a pointer, so for now I have added
unary minus and the two unary not operators.  I think I want to see
some examples of other operators before I would be keen to have any
further exceptions.

Anyhow how does this work for you:

    http://people.canonical.com/~apw/checkpatch/checkpatch-next.pl

-apw
