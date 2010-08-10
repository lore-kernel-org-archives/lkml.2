Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab0HJFgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 01:36:45 -0400
Received: from mail.perches.com ([173.55.12.10]:2352 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026Ab0HJFgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 01:36:39 -0400
Subject: Re: [PATCH v3] arm: msm: Add MSM IOMMU support.
From: Joe Perches <joe@perches.com>
To: stepanm@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, dwalker@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <bf2b5539fdb03a1a9c55ee1122c40b99.squirrel@www.codeaurora.org>
References: <1281407259-28626-1-git-send-email-stepanm@codeaurora.org>
	 <1281409689.1954.96.camel@Joe-Laptop.home>
	 <bf2b5539fdb03a1a9c55ee1122c40b99.squirrel@www.codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Aug 2010 22:36:37 -0700
Message-ID: <1281418597.1954.106.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-09 at 20:42 -0700, stepanm@codeaurora.org wrote:
> I am actually considering doing away with all the pr_err lines entirely
> because they typically also result in returning -Ewhatever and other IOMMU
> drivers don't give this level of error reporting. But, they may be helpful
> to the users of the API. What are people's thoughts on this?

I believe the current uses of pr_err in this module
are unnecessary or could be converted to pr_debug.

I think __func__/line aren't particularly useful.

I prefer log messages prefixed with the module name.

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

and I'd convert all the current pr_err to pr_debug
and convert the printk(KERN_ERR to pr_err(

cheers, Joe

