Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab0KISC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 13:02:26 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:4976 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443Ab0KISCU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 13:02:20 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
From: "Brett Rudley" <brudley@broadcom.com>
To: "Jon Masters" <jonathan@jonmasters.org>,
        devel <devel@linuxdriverproject.org>
cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Date: Tue, 9 Nov 2010 10:02:06 -0800
Subject: RE: PROBLEM: brcm80211 unable to survive suspend/resume cycle
Thread-Topic: PROBLEM: brcm80211 unable to survive suspend/resume cycle
Thread-Index: Act/vEvQejiXzlsoQpe3kqUkw59Z0wAe4k5w
Message-ID: <7A94256FD72B884D9E7C55586C3CBCEE13840C62AA@SJEXCHCCR01.corp.ad.broadcom.com>
References: <1289272437.3916.440.camel@constitution.bos.jonmasters.org>
In-Reply-To: <1289272437.3916.440.camel@constitution.bos.jonmasters.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 60C753153HC7218598-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jon, thanks for the heads up.  I can repro and am looking into it.

Brett

> -----Original Message-----
> From: devel-bounces@linuxdriverproject.org [mailto:devel-
> bounces@linuxdriverproject.org] On Behalf Of Jon Masters
> Sent: Monday, November 08, 2010 7:14 PM
> To: devel
> Cc: Linux Kernel Mailing List
> Subject: PROBLEM: brcm80211 unable to survive suspend/resume cycle
> 
> Folks,
> 
> I reported this before, but let me open up a new thread for this now
> that this driver has landed in 2.6.37-rc1 and been out for a while. I am
> able to use this driver (more or less) for daily use on my netbook, but
> it is unable survive a suspend/resume cycle without being unloaded and
> then reloaded again on resume. That actually seems to work quite well.
> 
> I believe the problem is firmware related:
> 
> [  553.355497] wl0: wlc_coreinit: ucode did not self-suspend!
> [  554.040495] wl0: wlc_suspend_mac_and_wait: waited 83000 uS and
> MI_MACSSPNDD is still not on.
> [  554.040517] wl0: psmdebug 0x000f8773, phydebug 0x00000000, psm_brc
> 0x0000
> [  554.154625] wl0: wlc_suspend_mac_and_wait: waited 83000 uS and
> MI_MACSSPNDD is still not on.
> [  554.154647] wl0: psmdebug 0x000f8773, phydebug 0x00000000, psm_brc
> 0x0000
> [  554.270438] wl0: wlc_suspend_mac_and_wait: waited 83000 uS and
> MI_MACSSPNDD is still not on.
> [  554.270459] wl0: psmdebug 0x000f8773, phydebug 0x00000000, psm_brc
> 0x0000
> [  554.384569] wl0: wlc_suspend_mac_and_wait: waited 83000 uS and
> MI_MACSSPNDD is still not on.
> 
> After the "ucode did not self-suspend", I then get the subsequent two
> line warnings repeated forever until I reload the driver. Sure, it's
> probably a firmware issue, but isn't there something the driver can do
> to kick it into a full reset if it doesn't come back? It's able to do it
> on module load initially...
> 
> Jon.
> 
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel


