Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab2HBOU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 10:20:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37689 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab2HBOU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 10:20:58 -0400
Date: Thu, 2 Aug 2012 15:20:53 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Schrober <franzschrober@yahoo.de>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch.pl: Wrong check SINGLE_STATEMENT_DO_WHILE_MACRO
Message-ID: <20120802142053.GH2501@dm>
References: <4204029.7cYAuJfu4T@bentobox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4204029.7cYAuJfu4T@bentobox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 10:00:04AM +0200, Schrober wrote:
> Hi,
> 
> I think your check for SINGLE_STATEMENT_DO_WHILE_MACRO is wrong. Just to give 
> an example:
> 
> #define foobar(x) \
> 	do { \
> 		if (pizza_ready(x)) \
> 			eat_pizza(x); \
> 	} while (0)
> 
> 
> if (hungry(y))
> 	foobar(x);
> else
> 	barfoo(x);
> 
> checkpatch does now complain about something like "WARNING: Single statement 
> macros should not use a do {} while (0) loop"
> 
> But we would have an ambiguous else when the do-while is removed. The code 
> works as expected with the do-while but the else is "attached" to the wrong 
> "if" when the do-while is removed.
> 
> And yes, this example is made that easy to make it easy to understand. There 
> are examples were static inline code would not work very well (vararg for 
> example).
> 
> Please fix or remove your check. Otherwise some people will be start to 
> overeagerly change these macros and break the kernel doing that.

It does appear this check should not apply when a control statement is
included.

-apw
