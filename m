Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568Ab1LEROw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:14:52 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:65050 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932523Ab1LEROu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:14:50 -0500
Date: Mon, 5 Dec 2011 09:14:43 -0800
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, pavel@ucw.cz, len.brown@intel.com, ebiederm@xmission.com,
        rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 1/3] PM / Sleep: Make [un]lock_system_sleep() generic
Message-ID: <20111205171443.GB627@google.com>
References: <20111204200208.25620.515.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111204200208.25620.515.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Dec 05, 2011 at 01:32:38AM +0530, Srivatsa S. Bhat wrote:
> +static inline void lock_system_sleep(void)
> +{
> +	/* simplified freezer_do_not_count() */
> +	current->flags |= PF_FREEZER_SKIP;
> +	mutex_lock(&pm_mutex);
> +}
> +
> +static inline void unlock_system_sleep(void)
> +{
> +	mutex_unlock(&pm_mutex);
> +	/* simplified freezer_count() */
> +	current->flags &= ~PF_FREEZER_SKIP;
> +}

BTW, don't we want try_to_freeze() there?  What's the reason for not
using freezer_count()?

Thanks.

-- 
tejun
