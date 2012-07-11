Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030412Ab2GKWMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:12:55 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:36952 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab2GKWMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:12:51 -0400
Date: Thu, 12 Jul 2012 00:00:45 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: Remove rtl_ocpdr_cond
Message-ID: <20120711220045.GA8913@electric-eye.fr.zoreil.com>
References: <1342009916-1519-1-git-send-email-hayeswang@realtek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342009916-1519-1-git-send-email-hayeswang@realtek.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hayes Wang <hayeswang@realtek.com> :
> No waiting is needed for mac_ocp_{write / read}. And the bit 31 of
> OCPDR would not change, so rtl_udelay_loop_wait_high always return
> false. That is, the r8168_mac_ocp_read always retuen ~0.

(testing with davem's 48ee3569f31d91084dc694fef5517eb782428083)

It seemed right at first sight but testing without firmware produces
unexpected results. While it is not exactly fast if I ask it to emit
packets with ping -qf, it turns really slow when I use the -l preload
option: at most a few hundreds pps.

An old pcie 8168b in the same computer behaves correctly with the same
kernel.

I'll try again tomorrow evening.

-- 
Ueimor
