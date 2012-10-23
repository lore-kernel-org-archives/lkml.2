Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab2JWEVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 00:21:48 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46257 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755041Ab2JWEVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 00:21:46 -0400
Message-ID: <1350966105.7502.25.camel@joe-AO722>
Subject: Re: linux-next: build failure after merge of the akpm tree
From: Joe Perches <joe@perches.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>
Date: Mon, 22 Oct 2012 21:21:45 -0700
In-Reply-To: <20121023144221.5ae3061a11766df8175b959d@canb.auug.org.au>
References: <20121023144221.5ae3061a11766df8175b959d@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-23 at 14:42 +1100, Stephen Rothwell wrote:
> Hi Andrew,
> 
> After merging the akpm tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> kernel/printk/printk_syslog.c: In function 'printk_syslog_print':
> kernel/printk/printk_syslog.c:108:3: error: implicit declaration of function 'copy_to_user' [-Werror=implicit-function-declaration]
> kernel/printk/printk_syslog.c: In function 'do_syslog':
> kernel/printk/printk_syslog.c:245:3: error: implicit declaration of function 'access_ok' [-Werror=implicit-function-declaration]
> kernel/printk/printk_syslog.c:245:18: error: 'VERIFY_WRITE' undeclared (first use in this function)
> kernel/printk/printk_syslog.c:245:18: note: each undeclared identifier is reported only once for each function it appears in
> 
> Caused by commit 598815e5f25f ("printk: add printk_syslog.c and .h").
> 
> Presumably missing an (or some) include files - see Rule 1 in
> Documentation/SubmitChecklist.

Yup, missing at least <linux/uaccess.h> which x86 gets
via an arch specific include.

I compiled it only x86.

I'll resubmit that one.

