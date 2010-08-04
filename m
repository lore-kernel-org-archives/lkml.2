Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456Ab0HDJAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 05:00:49 -0400
Received: from mail.windriver.com ([147.11.1.11]:36224 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756956Ab0HDJAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 05:00:47 -0400
Date: Wed, 4 Aug 2010 16:59:48 +0800
From: Yong Zhang <yong.zhang@windriver.com>
To: Ryan Wang <openspace.wang@gmail.com>
Cc: kernelnewbies@nl.linux.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: question about CONFIG_BASE_SMALL
Message-ID: <20100804085948.GA21549@windriver.com>
Reply-To: Yong Zhang <yong.zhang@windriver.com>
References: <AANLkTi=1DxqLrqVbfRouOBRWg4RHFaHz438X7F1JWL6P@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTi=1DxqLrqVbfRouOBRWg4RHFaHz438X7F1JWL6P@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 04 Aug 2010 08:59:51.0071 (UTC) FILETIME=[65D372F0:01CB33B3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 04:38:12PM +0800, Ryan Wang wrote:
> Hi all,
> 
>       I noticed CONFIG_BASE_SMALL in different parts
> of the kernel code, with ifdef/ifndef.
>       I wonder what does CONFIG_BASE_SMALL mean?
> And how can I configure it, e.g. through make menuconfig?

Yeah, here:

init/Kconfig:
...
config BASE_SMALL
	int
	default 0 if BASE_FULL
	default 1 if !BASE_FULL
...
config BASE_FULL
	default y
	bool "Enable full-sized data structures for core" if EMBEDDED
	help
	  Disabling this option reduces the size of miscellaneous core
	  kernel data structures. This saves memory on small machines,

> 
> thanks,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
