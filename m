Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab1CaAKL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 20:10:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40636 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754986Ab1CaAKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 20:10:09 -0400
Date: Thu, 31 Mar 2011 09:10:17 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Collins <collinsd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm-owner@vger.kernel.org
Subject: Re: [PATCH 2/2] msm: board-8960: Add support for pm8921-regulator
Message-ID: <20110331001016.GB21487@opensource.wolfsonmicro.com>
References: <1301523361-5982-1-git-send-email-collinsd@codeaurora.org>
 <1301523466-6054-1-git-send-email-collinsd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301523466-6054-1-git-send-email-collinsd@codeaurora.org>
X-Cookie: Stay away from flying saucers today.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 03:17:46PM -0700, David Collins wrote:

> +VREG_CONSUMERS(L1) = {
> +	REGULATOR_SUPPLY("8921_l1",		NULL),
> +};

All these supplies named after the regulator name should be removed.
Supplies define the mapping from the regulators on the board to the
supplies on the devices on the board, if any driver is requesting a
specific regulator name then there's an abstraction issue which means
that these should be redundant.

In general if you've got a supply that doesn't have a dev_name
associated with it something is wrong.
