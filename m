Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab2IQHcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 03:32:06 -0400
Received: from void.printf.net ([89.145.121.20]:36176 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870Ab2IQHcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 03:32:03 -0400
From: Chris Ball <cjb@laptop.org>
To: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: Venkatraman S <svenkatr@ti.com>, Jaehoon Chung <jh80.chung@samsung.com>,
        Adrian Hunter <ext-adrian.hunter@nokia.com>,
        Philip Rakity <prakity@marvell.com>, raphael.andy.lee@gmail.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v6] mmc: core: Remove bounce buffer in mmc_send_cxd_data()
References: <1343955483-6917-1-git-send-email-kyungsik.lee@lge.com>
Date: Mon, 17 Sep 2012 03:32:12 -0400
In-Reply-To: <1343955483-6917-1-git-send-email-kyungsik.lee@lge.com> (Kyungsik
	Lee's message of "Fri, 3 Aug 2012 09:58:03 +0900")
Message-ID: <m3txuxyuir.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Aug 02 2012, Kyungsik Lee wrote:
> It is expected that Extended CSD register(the size of this register
> is larger than CID/CSD) will be referenced more frequently as more
> fields have been added to Extended CSD and it seems that it is not
> a good option to double the memory used.
>
> This patch is intended to avoid the use of bounce buffer for reading
> Extended CSD register in mmc_send_cxd_data(). It will provide a better
> performance gain by removing memcpy() overhead for a half KiB and
> a redundant bounce buffer allocated repeatedly at the cost of providing
> DMA-capable buffer from upper caller(but on-stack buffer is allowed
> with no performance gain).
>
> Signed-off-by: Kyungsik Lee <kyungsik.lee@lge.com>
> Reviewed-by: Venkatraman S <svenkatr@ti.com>

Thanks, pushed to mmc-next for 3.7.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
