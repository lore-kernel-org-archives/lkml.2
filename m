Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab1HBH0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 03:26:24 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:55544 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab1HBH0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 03:26:18 -0400
X-ASG-Debug-ID: 1312269975-01de280c1e110450001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E37A696.2090007@fusionio.com>
Date: Tue, 2 Aug 2011 09:26:14 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: linux-next: build warning after merge of the moduleh tree
References: <20110801132359.1de051cb8a4a2bdfdad7560c@canb.auug.org.au>
X-ASG-Orig-Subj: Re: linux-next: build warning after merge of the moduleh tree
In-Reply-To: <20110801132359.1de051cb8a4a2bdfdad7560c@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1312269975
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.70667
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-01 05:23, Stephen Rothwell wrote:
> Hi Paul,
> 
> After merging the moduleh tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:
> 
> block/bsg-lib.c:75:1: warning: data definition has no type or storage class
> block/bsg-lib.c:75:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
> block/bsg-lib.c:75:1: warning: parameter names (without types) in function declaration
> block/bsg-lib.c:164:1: warning: data definition has no type or storage class
> block/bsg-lib.c:164:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
> block/bsg-lib.c:164:1: warning: parameter names (without types) in function declaration
> block/bsg-lib.c:210:1: warning: data definition has no type or storage class
> block/bsg-lib.c:210:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
> block/bsg-lib.c:210:1: warning: parameter names (without types) in function declaration
> block/bsg-lib.c:244:1: warning: data definition has no type or storage class
> block/bsg-lib.c:244:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
> block/bsg-lib.c:244:1: warning: parameter names (without types) in function declaration
> block/bsg-lib.c:297:1: warning: data definition has no type or storage class
> block/bsg-lib.c:297:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
> block/bsg-lib.c:297:1: warning: parameter names (without types) in function declaration
> 
> This is an interaction with commit aa387cc89567 ("block: add bsg helper
> library") from the block tree.  That file should have included module.h
> but now would need export.h it seems (just uses EXPORTSYMBOL_GPL).
> 
> I applied the following as a merge fix patch:

Thanks, will you carry this until things are merged? Not easy for me to
fix up.

-- 
Jens Axboe

