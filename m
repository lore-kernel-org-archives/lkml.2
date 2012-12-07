Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab2LGHqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 02:46:47 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54229 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672Ab2LGHqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 02:46:45 -0500
Date: Fri, 7 Dec 2012 08:46:43 +0100
From: Borislav Petkov <bp@alien8.de>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: WuJianguo <wujianguo@huawei.com>, Liujiang <jiang.liu@huawei.com>,
        andi@firstfloor.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH] MCE: fix an error of mce_bad_pages statistics
Message-ID: <20121207074643.GA27523@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Xishi Qiu <qiuxishi@huawei.com>, WuJianguo <wujianguo@huawei.com>,
	Liujiang <jiang.liu@huawei.com>, andi@firstfloor.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <50C15A35.5020007@huawei.com>
 <20121207072541.GA27708@liondog.tnic>
 <50C19C33.9030502@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50C19C33.9030502@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 03:35:15PM +0800, Xishi Qiu wrote:
> Hi Borislav, you mean we should move this to the beginning of soft_offline_page()?
> 
> soft_offline_page()
> {
> 	...
> 	get_any_page()
> 	...
> 	/*
> 	 * Synchronized using the page lock with memory_failure()
> 	 */
> 	if (PageHWPoison(page)) {
> 		unlock_page(page);

Basically yes, except without the unlock_page. Where do you do lock_page
earlier so that you need to unlock it now?

Thanks.

-- 
Regards/Gruss,
    Boris.
