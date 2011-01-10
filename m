Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab1AJXU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 18:20:27 -0500
Received: from void.printf.net ([89.145.121.20]:57864 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628Ab1AJXUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 18:20:25 -0500
Date: Mon, 10 Jan 2011 23:20:20 +0000
From: Chris Ball <cjb@laptop.org>
To: Chuanxiao Dong <chuanxiao.dong@intel.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH v6 0/3]mmc: implement eMMC4.4 standard HW reset feature
Message-ID: <20110110232020.GA7920@void.printf.net>
References: <20101227101305.GA20143@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101227101305.GA20143@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chuanxiao,

On Mon, Dec 27, 2010 at 06:13:05PM +0800, Chuanxiao Dong wrote:
> Hi all,
>    This is the version 6 of hardware reset feature implementation. When eMMC
>    card cannot response any command, signal RST_n can help to reset eMMC
>    card.
> 
>    patch1: enable HW reset capability if card supports.
>    patch2: do hardware reset if card occurs read/write/erase timeout
>    patch3: implement hwreset_emmc and reinit_emmc callbacks. In this patch,
>    hwreset_emmc callback will pull up/down the corresponded GPIO line number
>    to trigger RST_n signal.

Sorry for the very late reply.  I'm simply not sure what to do about
this patchset -- I'm extremely reluctant to touch the once-only
programmable bits on the eMMC, and especially to do so silently by
default.

Also, where exactly do you assign host->rst_gpio?  It isn't assigned
to in this patch, so where will it be set?  It looks like you could
end up strobing GPIO0 if a gpio isn't passed in at all.

I haven't seen any other reports of -ETIMEDOUT from eMMC controllers
not responding to CMD0; I wonder if only your controller has this
problem, and if that should change how we handle it.

Does anyone else on the list have feedback on how best to proceed?

Thanks,

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
