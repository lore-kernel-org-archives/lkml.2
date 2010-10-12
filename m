Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046Ab0JLSeq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 14:34:46 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:3325 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754267Ab0JLSep convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 14:34:45 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
From: "Brett Rudley" <brudley@broadcom.com>
To: "jcm@jonmasters.org" <jcm@jonmasters.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
cc: "Henry Ptasinski" <henryp@broadcom.com>, "Nohee Ko" <noheek@broadcom.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 12 Oct 2010 11:34:30 -0700
Subject: RE: [PATCH] [staging] brcm80211: fix radio disabled on attempt
 to bring up interface
Thread-Topic: [PATCH] [staging] brcm80211: fix radio disabled on attempt
 to bring up interface
Thread-Index: Actp5+85D45Hn1gyQJyWQ75ByJ/yywAU+33w
Message-ID: <7A94256FD72B884D9E7C55586C3CBCEE1382808041@SJEXCHCCR01.corp.ad.broadcom.com>
References: <1286872198-10664-1-git-send-email-jcm@jonmasters.org>
In-Reply-To: <1286872198-10664-1-git-send-email-jcm@jonmasters.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 60AA75B23N010948622-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Brett Rudley <brudley@broadcom.com>
---

> -----Original Message-----
> From: jcm@jonmasters.org [mailto:jcm@jonmasters.org]
> Sent: Tuesday, October 12, 2010 1:30 AM
> To: linux-wireless@vger.kernel.org
> Cc: Brett Rudley; Henry Ptasinski; Nohee Ko; Jon Masters; LKML
> Subject: [PATCH] [staging] brcm80211: fix radio disabled on attempt to
> bring up interface
> 
> The brcm80211 driver does not correctly handle the case that the wireless
> radio hardware is physically disabled during interface initialization. An
> attempt is made to check whether the radio is disabled, and in the case
> that it is, a background worker is setup to monitor for the radio coming
> online, but the interface queues are incorrectly brought up anyway. The
> value BCME_RADIOOFF should be returned in wlc_up in such error case.
> 
> Signed-off-by: Jon Masters <jcm@jonmasters.org>
> 
> diff -urNp brcm80211_orig/sys/wlc_mac80211.c brcm80211/sys/wlc_mac80211.c
> --- brcm80211_orig/sys/wlc_mac80211.c	2010-10-12 04:18:07.940125220 -
> 0400
> +++ brcm80211/sys/wlc_mac80211.c	2010-10-12 04:19:19.814961117 -0400
> @@ -2783,7 +2783,7 @@ int BCMINITFN(wlc_up) (wlc_info_t *wlc)
> 
>  	if (wlc->pub->radio_disabled) {
>  		wlc_radio_monitor_start(wlc);
> -		return 0;
> +		return BCME_RADIOOFF;
>  	}
> 
>  	/* wlc_bmac_up_prep has done wlc_corereset(). so clk is on, set it
> */


