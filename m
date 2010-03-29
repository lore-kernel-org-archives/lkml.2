Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab0C2Myn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 08:54:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43579 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750902Ab0C2Mym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 08:54:42 -0400
Date: Mon, 29 Mar 2010 13:54:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Todd Fischer <todd.fischer@ridgerun.com>
Cc: linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com, sameo@linux.intel.com,
       lrg@slimlogic.co.uk
Subject: Re: [PATCH 2/5]  Make room for other tps6507x drivers to have
 board specific initialization data.
Message-ID: <20100329125440.GC8434@rakim.wolfsonmicro.main>
References: <1269634292-29686-1-git-send-email-todd.fischer@ridgerun.com>
 <1269634292-29686-2-git-send-email-todd.fischer@ridgerun.com>
 <1269634292-29686-3-git-send-email-todd.fischer@ridgerun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269634292-29686-3-git-send-email-todd.fischer@ridgerun.com>
X-Cookie: Uncompensated overtime?  Just Say No.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 02:11:29PM -0600, Todd Fischer wrote:
> Need mfd structure that can hold pointers to sub-driver initialization
> and run time data.

Please provide a more verbose changelog.  What needs this structure?

>  	/**
> +	 * tps_board points to pmic related constants
> +	 * coming from the board-evm file.
> +	 */
> +
> +	tps_board = (struct tps6507x_board *)client->dev.platform_data;

There's no need to cast away from void and you ought to be using
dev_get_platdata().

> +	if (!tps_board)
> +		return -EIO;
> +

This seems like the wrong error code to be using here.
