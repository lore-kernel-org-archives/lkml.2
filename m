Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab2FGRs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 13:48:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:45192 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932456Ab2FGRs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 13:48:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="153041070"
From: Andi Kleen <andi@firstfloor.org>
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de,
        alan@lxorguk.ukuu.org.uk, linux-usb@vger.kernel.org
Subject: Re: [PATCH 10/11] Introduce single user mode
References: <1339000274-10448-1-git-send-email-stefani@seibold.net>
Date: Thu, 07 Jun 2012 10:48:16 -0700
In-Reply-To: <1339000274-10448-1-git-send-email-stefani@seibold.net>
	(stefani@seibold.net's message of "Wed, 6 Jun 2012 18:31:13 +0200")
Message-ID: <m2sje7hv33.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stefani@seibold.net writes:
>  	}
>  
> +	if (dev->in_use) {
> +		retval = -EBUSY;
> +		goto exit;
> +	}

This plus setting the flag has to be inside the mutex, otherwise you
have an obvious race.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
