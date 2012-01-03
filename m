Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab2ACNDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 08:03:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35636 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534Ab2ACNDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 08:03:10 -0500
Date: Tue, 3 Jan 2012 14:03:06 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Subject: Re: iwl3945 didn't survive after s2ram failure
Message-ID: <20120103130306.GA3891@tiehlicka.suse.cz>
References: <20111227105340.GD5344@tiehlicka.suse.cz>
 <20120103103457.GA3391@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120103103457.GA3391@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 03-01-12 11:34:58, Stanislaw Gruszka wrote:
> On Tue, Dec 27, 2011 at 11:53:40AM +0100, Michal Hocko wrote:
> > my laptop died (due to drained batteries) while it was suspended to
> > RAM and the wireless didn't get back to life after I booted again.
> 
> I wonder how we could kill hardware that way ...
> 
> > Dmesg says:
> > cfg80211: Calling CRDA to update world regulatory domain
> > iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:s
> > iwl3945: Copyright(c) 2003-2011 Intel Corporation
> > iwl3945 0000:05:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> > iwl3945 0000:05:00.0: setting latency timer to 64
> > iwl3945 0000:05:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
> > iwl3945 0000:05:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
> > iwl3945 0000:05:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
> > iwl3945 0000:05:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
> > iwl3945 0000:05:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
> > iwl3945 0000:05:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
> > iwl3945 0000:05:00.0: bad EEPROM signature,EEPROM_GP=0x00000007
> > iwl3945 0000:05:00.0: EEPROM not found, EEPROM_GP=0xffffffff
> > iwl3945 0000:05:00.0: Unable to init EEPROM
> > iwl3945 0000:05:00.0: PCI INT A disabled
> > iwl3945: probe of 0000:05:00.0 failed with error -2
> > 
> > Is there anything I can do to resurrect it?
> 
> No idea. Please provide logs with debug=0x47ffffff option.

[ 5622.729333] cfg80211: Calling CRDA to update world regulatory domain
[ 5622.739262] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:ds
[ 5622.739270] iwl3945: Copyright(c) 2003-2011 Intel Corporation
[ 5622.739324] ieee80211 phy0: U iwl3945_pci_probe Disabling hw_scan
[ 5622.739328] ieee80211 phy0: U iwl3945_pci_probe *** LOAD DRIVER ***
[ 5622.739396] iwl3945 0000:05:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[ 5622.739419] iwl3945 0000:05:00.0: setting latency timer to 64
[ 5622.739446] ieee80211 phy0: U iwl3945_pci_probe pci_resource_len = 0x00001000
[ 5622.739451] ieee80211 phy0: U iwl3945_pci_probe pci_resource_base = f801e000
[ 5622.739462] ieee80211 phy0: U iwl_legacy_eeprom_init NVM size = 1024
[ 5622.739466] ieee80211 phy0: U iwl_legacy_apm_init Init card's basic functions
[ 5622.740021] iwl3945 0000:05:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
[ 5622.760206] iwl3945 0000:05:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
[ 5622.777028] iwl3945 0000:05:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
[ 5622.793768] iwl3945 0000:05:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
[ 5622.810526] iwl3945 0000:05:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
[ 5622.827279] iwl3945 0000:05:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
[ 5622.840727] ieee80211 phy0: U iwl_legacy_eeprom_verify_signature EEPROM signature=0x00000007
[ 5622.840731] iwl3945 0000:05:00.0: bad EEPROM signature,EEPROM_GP=0x00000007
[ 5622.840735] iwl3945 0000:05:00.0: EEPROM not found, EEPROM_GP=0xffffffff
[ 5622.840740] ieee80211 phy0: U iwl_legacy_apm_stop Stop card, put in low power state
[ 5622.840746] ieee80211 phy0: U iwl_legacy_apm_stop_master stop master
[ 5622.840762] iwl3945 0000:05:00.0: Unable to init EEPROM
[ 5622.840836] iwl3945 0000:05:00.0: PCI INT A disabled
[ 5622.840851] iwl3945: probe of 0000:05:00.0 failed with error -2

> Did you try to totally power-off the laptop by removing
> battery (and power cable of course) ?

Yes and no change. I even tried to disable wireless in BIOS boot and
then enable it again. No change...
It seems somebody already had the same problem
https://bugzilla.redhat.com/show_bug.cgi?id=639184. My BIOS doesn't
provide any locator setting, unfortunatelly.

The message above says that the HW is still in a deep sleep state. Can
we somehow force waking it up?
Or, can we just ignore the signature check and (maybe) fix it by another
suspend/resume cycle?
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
