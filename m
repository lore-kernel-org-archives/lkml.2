Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006Ab0HEVlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 17:41:11 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:46631 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755100Ab0HEVlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 17:41:05 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMrMWkxQybSJ/2dsb2JhbACgPnLHKw2FLQQ
Date: Thu, 5 Aug 2010 23:41:02 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: dann frazier <dannf@hp.com>
Cc: linux-kernel@vger.kernel.org, Thomas Mingarelli <thomas.mingarelli@hp.com>
Subject: Re: [PATCH 00/15] hpwdt: make NMI code a config option (+ other
	cleanup)
Message-ID: <20100805214102.GA4288@infomag.iguana.be>
References: <1280274663-9160-1-git-send-email-dannf@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280274663-9160-1-git-send-email-dannf@hp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

> hwpdt includes an NMI-decoding feature, but the watchdog interface is quite
> usable without it. This patchset makes it possible to build hpwdt without the
> NMI functionality, as well as some general cleanup.

Looking at the overall overview we have:
watchdog: hpwdt (1/3): Introduce SECS_TO_TICKS() macro
watchdog: hpwdt (2/3): allow full range of timer values supported by hardware
watchdog: hpwdt (3/3): implement WDIOC_GETTIMELEFT
[PATCH 01/15] hpwdt_pretimeout reorganization                                         
[PATCH 02/15] remove unnecessary includes                                             
[PATCH 03/15] include spinlock.h                                                      
[PATCH 04/15] add include for linux/bitops.h                                          
[PATCH 05/15] Group together includes specific to NMI sourcing                        
[PATCH 06/15] Group options that affect watchdog behavior together                    
[PATCH 07/15] Group defines only used by NMI sourcing together                        
[PATCH 08/15] Group declarations specific to NMI sourcing together                    
[PATCH 09/15] Despecificate driver from iLO2                                          
[PATCH 10/15] Fix a typo                                                              
[PATCH 11/15] Make x86 assembly ifdef guard more strict                               
[PATCH 12/15] Construct status message w/ kasprintf and emit it with dev_info         
[PATCH 13/15] Use "decoding" instead of "sourcing"                                    
[PATCH 14/15] Make NMI decoding a compile-time option                                 
[PATCH 15/15] Bump version to 1.2.0                                                   

When I look closer I see that:
* Some of the clean-up stuff changes things that were introduced in the first 3 (timer) patches.
Since these patches are not in mainline yet, it would be better to directly do it there.
(Which means that you don't need patch 7 anymore).
* The clean-up of includes (2, 3, 4 and maybe 5) can be a single patch.
* Patch 10 is correct but since you change the Kconfig help text in patch 14 anyway,
I would incorporate that in patch 14.  Same for patch 15 -> this should be combined with patch 14 also.
* Personally I prefer to do the general clean-up first and then do the different changes for the NMI part.
* I don't like the ifdef's in the init and exit procedures. A procedure/function that is defined for both cases is the way that we should go here. (see patch 14).

So overall: patches look good, but let's re-order the patches a bit (so that we first clean-up the driver and then add the NMI related changes (If we ever need to revert some things then we at least have a clean-driver before we start bisecting the NMI changes)).
And secondly: let's try to have the ifdef's out of the init and exit procedures.

If you can look at how we can get rid of the ifdef's in init and exit, then I will reorder the patches and change the 3 timer patches and put that allready in a git tree.

Kind regards,
Wim.

