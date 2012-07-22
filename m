Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab2GVDxB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 23:53:01 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34182 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab2GVDw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 23:52:58 -0400
Message-ID: <500B7916.6060804@lwfinger.net>
Date: Sat, 21 Jul 2012 22:52:54 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Christopher Li <sparse@chrisli.org>
CC: Linux-Sparse <linux-sparse@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: False warning from Sparse
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am getting the following false warning from sparse:

   CHECK   drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c:1158:13: warning: context 
imbalance in 'rtl92c_dm_refresh_rate_adaptive_mask' - different lock contexts 
for basic block

The only code in that routine that does any locking is the following:

              /* Only the PCI card uses sta in the update rate table
               * callback routine */
              if (rtlhal->interface == INTF_PCI) {
                      rcu_read_lock();
                      sta = ieee80211_find_sta(mac->vif, mac->bssid);
              }
              rtlpriv->cfg->ops->update_rate_tbl(hw, sta,
                                   p_ra->ratr_state);

              p_ra->pre_ratr_state = p_ra->ratr_state;
              if (rtlhal->interface == INTF_PCI)
                      rcu_read_unlock();

Does the warning get output because the code cannot assume that 
rtlhal->interface is the same in both if statements? If that is the case, are 
there any compiler directives that would tell sparse of the situation?

Thanks,

Larry
