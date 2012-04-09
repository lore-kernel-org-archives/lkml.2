Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710Ab2DISeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 14:34:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:50299 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757646Ab2DISet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 14:34:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="130387938"
Message-ID: <4F832BC8.4090907@linux.intel.com>
Date: Mon, 09 Apr 2012 11:34:48 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][REGRESSION] panic: fix stack dump print on direct call
 to panic()
References: <1333992030-21181-1-git-send-email-jason.wessel@windriver.com>
In-Reply-To: <1333992030-21181-1-git-send-email-jason.wessel@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The proper way to resolve the problem that original commit tried to
> solve is to avoid printing a stack dump from panic() when the either
> of the following conditions is true:
>
>    1) TAINT_DIE has been set (this is done by oops_end())
>       This indicates and oops has already been printed.
>    2) oops_in_progress>  1
>       This guards against the rare case where panic() is invoked
>       a second time, or in between oops_begin() and oops_end()

Oops. I guess can just revert it for now. Thanks for catching, Jason.

The proper solution is probably some variant of
http://git.kernel.org/?p=linux/kernel/git/ak/linux-mce-2.6.git;a=shortlog;h=refs/heads/mce/xpanic

Let the caller pass in the proper action instead of all these hacks.

-Andi


