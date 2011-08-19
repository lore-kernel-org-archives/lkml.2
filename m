Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab1HSFEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 01:04:37 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:50080 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab1HSFEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 01:04:35 -0400
Date: Thu, 18 Aug 2011 22:04:32 -0700 (PDT)
Message-Id: <20110818.220432.1711182086933489213.davem@davemloft.net>
To: tim.c.chen@linux.intel.com
Cc: eric.dumazet@gmail.com, viro@zeniv.linux.org.uk, ebiederm@xmission.com,
        ak@linux.intel.com, matt.fleming@linux.intel.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [Patch] Scm: Remove unnecessary pid & credential references in
 Unix socket's send and receive path
From: David Miller <davem@davemloft.net>
In-Reply-To: <1313625374.2576.2908.camel@schen9-DESK>
References: <1313625374.2576.2908.camel@schen9-DESK>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 18 Aug 2011 22:04:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Chen <tim.c.chen@linux.intel.com>
Date: Wed, 17 Aug 2011 16:56:14 -0700

> +static __inline__ void scm_release(struct scm_cookie *scm)
> +{
> +	/* keep ref on pid and cred */
> +	scm->pid = NULL;
> +	scm->cred = NULL;
> +	if (scm && scm->fp)
> +		__scm_destroy(scm);
> +}

After dereferencing scm-> already, it seems a big redundant to test
it subsequently against NULL.
