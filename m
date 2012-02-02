Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab2BBRRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:17:35 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33989 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab2BBRRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:17:34 -0500
Date: Thu, 2 Feb 2012 09:17:27 -0800
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, pavel@ucw.cz, len.brown@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PM/Hibernate: Refactor and simplify freezer_test_done
Message-ID: <20120202171727.GE19837@google.com>
References: <20120202014014.11863.86758.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202014014.11863.86758.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 07:10:19AM +0530, Srivatsa S. Bhat wrote:
> @@ -251,10 +251,10 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
>  		error = hibernation_snapshot(data->platform_support);
>  		if (!error) {
>  			error = put_user(in_suspend, (int __user *)arg);
> -			if (!error && !freezer_test_done)
> -				data->ready = 1;
>  			if (freezer_test_done)
>  				freezer_test_done = false;
> +			else if (!error)
> +				data->ready = 1;

Hmmm... how about..

	data->ready = !freezer_test_done && !error;
	freezer_test_done = false;

-- 
tejun
