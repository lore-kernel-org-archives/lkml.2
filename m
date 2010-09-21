Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab0IUMrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 08:47:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56889 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab0IUMrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 08:47:20 -0400
Date: Tue, 21 Sep 2010 14:47:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 5/5] ACPI, APEI, Fix ERST MOVE_DATA instruction implementation
Message-ID: <20100921124718.GE18991@one.firstfloor.org>
References: <1284865235-29920-1-git-send-email-ying.huang@intel.com> <1284865235-29920-6-git-send-email-ying.huang@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284865235-29920-6-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 19, 2010 at 11:00:35AM +0800, Huang Ying wrote:
> diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
> index 40b01c3..a103963 100644
> --- a/drivers/acpi/apei/erst.c
> +++ b/drivers/acpi/apei/erst.c
> @@ -266,13 +266,27 @@ static int erst_exec_move_data(struct apei_exec_context *ctx,
>  {
>  	int rc;
>  	u64 offset;
> +	void *src, *dst;
> +
> +	/* ioremap does not work in interrupt context */
> +	if (in_interrupt())
> +		return -EBUSY;

That breaks serialization of machine checks no? If the BIOS uses MOVE_DATA
How about using kmap_atomic instead?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
