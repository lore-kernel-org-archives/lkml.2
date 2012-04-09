Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892Ab2DITQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 15:16:49 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60493 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757686Ab2DITQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 15:16:47 -0400
Message-ID: <4F83359B.90103@lwfinger.net>
Date: Mon, 09 Apr 2012 14:16:43 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: oops on rmmod of rtl8192ce
References: <CAPM=9tz-2bXahnfDK0-anxyZcqFUPOSEewJxh2+2U51xypmw-w@mail.gmail.com> <CAPM=9tzqwZpWP9Ea-UVWYFcoVY-fa+jCf5FOShiMTrY4roN-og@mail.gmail.com>
In-Reply-To: <CAPM=9tzqwZpWP9Ea-UVWYFcoVY-fa+jCf5FOShiMTrY4roN-og@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2012 10:02 AM, Dave Airlie wrote:
> ping any ideas on this oops on unload?

Sorry about the delay.

The oops looks like interrupts are not being disabled soon enough. Does the 
following patch help?


Index: wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
@@ -1943,6 +1943,7 @@ void rtl_pci_disconnect(struct pci_dev *
  		rtl_deinit_deferred_work(hw);
  		rtlpriv->intf_ops->adapter_stop(hw);
  	}
+	rtlpriv->cfg->ops->disable_interrupt(hw);

  	/*deinit rfkill */
  	rtl_deinit_rfkill(hw);

Larry
