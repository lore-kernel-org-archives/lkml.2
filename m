Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab2IUFNZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 01:13:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37142 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab2IUFNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 01:13:23 -0400
Date: Thu, 20 Sep 2012 22:10:45 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: jenny.tc@intel.com, ramakrishna.pallala@intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] charger-manager: Check fully charged state of
 battery periodically
Message-ID: <20120921051044.GB927@lizard>
References: <1345536412-25914-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1345536412-25914-1-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 05:06:52PM +0900, Chanwoo Choi wrote:
> This patch check periodically fully charged state of battery to protect
> overcharge and overheat. If battery is fully charged, stop charging
> and check droped voltage with 'fullbatt_vchkdrop_ms' period. When voltage
> of battery is more droped than 'fullbatt_vchkdrop_uV' voltage,
> charger-manager will restart charging for battery.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---

Applied, thank you.

There were some minor issues, but I fixed them up:

[...]
> +	} else if (!cm->emergency_stop
> +			&& is_ext_pwr_online(cm) && !cm->charger_enabled) {

Wrong && placement (should have been on the previous line).

> +		fullbatt_vchk(&cm->fullbatt_vchk_work.work);
> +
> +	/*
> +	 * Check whether fully charged state to protect overcharge
> +	 * if charger-manager is charging for battery.
> +	 */
> +	} else if (!cm->emergency_stop
> +			&& is_full_charged(cm) && cm->charger_enabled) {

Ditto.
