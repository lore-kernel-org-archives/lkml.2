Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab1HYSKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 14:10:49 -0400
Received: from mail.windriver.com ([147.11.1.11]:55076 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab1HYSKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 14:10:48 -0400
Message-ID: <4E569000.302@windriver.com>
Date: Thu, 25 Aug 2011 14:10:08 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>
Subject: Re: linux-next: build failure after merge of the final tree (akpm
 and moduleh trees related)
References: <20110825161750.45803be66cba17a6bd3906bc@canb.auug.org.au>
In-Reply-To: <20110825161750.45803be66cba17a6bd3906bc@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-08-25 02:17 AM, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (sparc64 defconfig)
> failed like this:
> 
> kernel/printk.c:536:35: error: expected ')' before string constant
> kernel/printk.c:1116:35: error: expected ')' before string constant
> 
> Caused by commits 8a04dedc045d ("We are enabling some power features on
> medfield.  To test suspend-2-RAM") and d09d67ec904c (same - the following
> commit) from the akpm tree interacting with commit a25ffe9fafa1 ("kernel:
> Map most files to use export.h instead of module.h") from the moduleh
> tree.  This file now needs module.h, not just export.h since
> MODULE_PARM_DESC if defined there.
> 
> I have applied a merge fixup patch to change export.h back to module.h.

Thanks Stephen, I've excluded kernel/printk.c from the conversion to
export.h today.

Paul.

> 
> P.S. Andrew, these commits could do with better subject lines :-(
