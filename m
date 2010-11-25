Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab0KYJlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 04:41:47 -0500
Received: from mga01.intel.com ([192.55.52.88]:35935 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257Ab0KYJlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 04:41:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,253,1288594800"; 
   d="scan'208";a="630207547"
Message-ID: <4CEE2F58.3090506@linux.intel.com>
Date: Thu, 25 Nov 2010 10:41:44 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Chen Gong <gong.chen@linux.intel.com>
CC: x86@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/MCE: don't let EDAC bypass the handle from MCE
References: <1290674793-8346-1-git-send-email-gong.chen@linux.intel.com>
In-Reply-To: <1290674793-8346-1-git-send-email-gong.chen@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>   		entry = rcu_dereference_check_mce(mcelog.next);
>   		for (;;) {
> -			/*
> -			 * If edac_mce is enabled, it will check the error type
> -			 * and will process it, if it is a known error.
> -			 * Otherwise, the error will be sent through mcelog
> -			 * interface
> -			 */
> -			if (edac_mce_parse(mce))
> -				return;
> +			edac_mce_parse(mce);

The other problem with the current code is that it prints the misleading 
KERN_EMERG fallback message
for every corrected error.

-Andi

