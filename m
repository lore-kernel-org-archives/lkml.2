Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab1CAXUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 18:20:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:28214 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757238Ab1CAXUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 18:20:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,249,1297065600"; 
   d="scan'208";a="607974475"
Message-ID: <4D6D7F34.5060106@linux.intel.com>
Date: Tue, 01 Mar 2011 15:20:20 -0800
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/7] hpfs: remove the BKL
References: <1299021191-17961-1-git-send-email-arnd@arndb.de> <1299021191-17961-4-git-send-email-arnd@arndb.de>
In-Reply-To: <1299021191-17961-4-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>   config HPFS_FS
>   	tristate "OS/2 HPFS file system support"
>   	depends on BLOCK
> -	depends on BKL # nontrivial to fix
> +	depends on BROKEN || !PREEMPT
That's a weird way to write a condition. Just depends on !PREEMPT ?
Other than that it looks good.

Acked-by: Andi Kleen <ak@linux.intel.com>

-Andi



