Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab0HWSov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 14:44:51 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49168 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab0HWSos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 14:44:48 -0400
Date: Mon, 23 Aug 2010 14:31:55 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Thomas Fjellstrom <thomas@fjellstrom.ca>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ath5k problem with 2.6.35
Message-ID: <20100823183155.GF2609@tuxdriver.com>
References: <201008220005.38969.tfjellstrom@strangesoft.net>
 <201008220153.41678.thomas@fjellstrom.ca>
 <20100823182903.GE2609@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100823182903.GE2609@tuxdriver.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 02:29:03PM -0400, John W. Linville wrote:
> On Sun, Aug 22, 2010 at 01:53:41AM -0600, Thomas Fjellstrom wrote:
> > On August 22, 2010, Thomas Fjellstrom wrote:
> > > Hi, I'm running 2.6.35, and my wireless card fails to initialize properly
> > > on boot. I get the following messages in dmesg:
> > 
> > Probably important, but I missed a couple lines:
> >  
> > > [    0.866525] ath5k 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ
> > > 17 [    0.866536] ath5k 0000:02:00.0: setting latency timer to 64
> > > [    0.866571] ath5k 0000:02:00.0: registered as 'phy0'
> > > [    1.358241] ath: EEPROM regdomain: 0x67
> > > [    1.358242] ath: EEPROM indicates we should expect a direct regpair map
> > > [    1.358245] ath: Country alpha2 being used: 00
> > > [    1.358247] ath: Regpair used: 0x67
> >    [    1.360589] phy0: Failed to initialize wep: -2
> > > [    1.372021] ath5k phy0: can't register ieee80211 hw
> > > [    1.372080] ath5k 0000:02:00.0: PCI INT A disabled
> > > [    1.372084] ath5k: probe of 0000:02:00.0 failed with error -2
> 
> Did you enable fips mode?

Presuming the answer is yes, you need this patch (available in 2.6.36-rc1):

commit 3473187d2459a078e00e5fac8aafc30af69c57fa
Author: John W. Linville <linville@tuxdriver.com>
Date:   Wed Jul 7 15:07:49 2010 -0400

    mac80211: remove wep dependency
    
    The current mac80211 code assumes that WEP is always available.  If WEP
    fails to initialize, ieee80211_register_hw will always fail.
    
    In some cases (e.g. FIPS certification), the cryptography used by WEP is
    unavailable.  However, in such cases there is no good reason why CCMP
    encryption (or even no link level encryption) cannot be used.  So, this
    patch removes mac80211's assumption that WEP (and TKIP) will always be
    available for use.
    
    Signed-off-by: John W. Linville <linville@tuxdriver.com>
 
John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
