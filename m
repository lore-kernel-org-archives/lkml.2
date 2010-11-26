Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab0KZIb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 03:31:28 -0500
Received: from mail.sysgo.com ([195.145.229.155]:42412 "EHLO mail.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035Ab0KZIb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 03:31:27 -0500
Date: Fri, 26 Nov 2010 09:31:25 +0100
From: Pavel Machek <pma@sysgo.com>
To: Larry Finger <Larry.Finger@lwfinger.net>, ath9k-devel@venema.h4ckr.net
Cc: kernel list <linux-kernel@vger.kernel.org>, chunkeey@googlemail.com,
        linux-wireless@vger.kernel.org, rudolf.marek@sysgo.com, cko@sysgo.com,
        mfa@sysgo.com, anl@sysgo.com
Subject: ath9k_htc vs. powerpc (was Re: working usb wifi card, that is
 still possible to buy)
Message-ID: <20101126083125.GA28982@pma.sysgo.com>
References: <20101103092431.GA21138@pma.sysgo.com>
 <20101124081616.GA30595@pma.sysgo.com>
 <20101124131320.GA2611@pma.sysgo.com>
 <4CED33E0.5040000@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CED33E0.5040000@lwfinger.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > | D-Link DWA-131            | 07d1:3303 | realtek?            |                                          |              
> 
> This one should work with driver r8712u in staging in kernel 2.6.37-rcX. I don't
> have this model for testing, but the DWA-130 is rock solid with that driver.

Thanks... Yes, it works, but staging scares me.

I found card compatible with ath9k_htc driver, that works well on PC,
and is even listed as supported by atheros. Good.

Unfortunately, it does not work that well on powerpc mpc5200b. (I'm
using recent wireless-testing tree).

I can do scan just fine, but can not actually asocciate with the
accesspoint. Nothing too useful in dmesg, only:

Freeing unused kernel memory: 176k init                                         
warning: `named' uses 32-bit capabilities (legacy support in use)               
process `named' is using obsolete setsockopt SO_BSDCOMPAT                       
ieee80211 phy0: device now idle                                                 
ieee80211 phy0: device no longer idle - scanning                                
ieee80211 phy0: device now idle                                                 
ieee80211 phy0: device no longer idle - scanning                                
wlan0: direct probe to 00:23:f8:5d:76:93 (try 1)                                
wlan0: direct probe to 00:23:f8:5d:76:93 (try 2)                                
wlan0: direct probe to 00:23:f8:5d:76:93 (try 3)                                
wlan0: direct probe to 00:23:f8:5d:76:93 timed out                              
ieee80211 phy0: device now idle                                                 
-/bin/sh-3.00# 

Any ideas how to get more verbose debugging?

Diffences to the mpc5200b board are:

a) it is PowerPC, thus big-endian board

b) it only has USB1.1 controller.

								Pavel
