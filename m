Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab2GJJMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 05:12:45 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:60222 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555Ab2GJJMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 05:12:43 -0400
Date: Tue, 10 Jul 2012 11:00:45 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 6/6] r8169: support RTL8168G
Message-ID: <20120710090045.GA32387@electric-eye.fr.zoreil.com>
References: <1341898590-1253-1-git-send-email-hayeswang@realtek.com> <1341904369-5277-1-git-send-email-hayeswang@realtek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341904369-5277-1-git-send-email-hayeswang@realtek.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(you should include a Signed-off-by)

Hayes Wang <hayeswang@realtek.com> :
> 1. Remove rtl_ocpdr_cond. No waiting is needed for mac_ocp_{write / read}.

Nit: it would not hurt to do a better job than me and save some commit noise
getting these things right before they pollute the history. :o)

> 2. Set ocp_base to OCP_STD_PHY_BASE after rtl8168g_1_hw_phy_config.

Can't it be stuffed into the firmware ?

The code does not explicitely switch from the PHY access context to
the extra OCP registers one and anything else in rtl8168g_1_hw_phy_config
seems to directly use the addresses it needs. So I'd expect the current
imbalance to come from the firmware, where it would make as much sense to
fix it
-> no imbalance after the firmware is applied
-> no useless instruction if the firmware is not used

-- 
Ueimor
