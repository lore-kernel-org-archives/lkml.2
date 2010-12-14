Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759887Ab0LNTyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 14:54:54 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:47832 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759843Ab0LNTyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 14:54:52 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Vftyt9v7ovxVGiSx/PcTYA/z3szn+DWKttpFDeAnrjDLJDCoDxiET3B4rpHo+fkj9GlamlKYFeDpW0OqFBM4GQIo7IVubrg8Mit3X5dCNbvI6jpDKSq/L3887q9U/xnh;
Date: Tue, 14 Dec 2010 11:54:49 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: Regression: audio not detected "cannot build controls"
Message-ID: <20101214115449.6e569c86@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sound on my Sony Vaio used to work back in 2.6.36 but no longer works.
At boot time I see a message like this:

[    7.159241] hda_codec: ALC889: BIOS auto-probing.
[    7.159246] hda_codec: ALC889: SKU not ready 0x411111f0
[    7.160629] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input6
[    7.164300] hda_codec: cannot build controls for #0 (error -16)
...
[    7.215622] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[    7.216004] HDA Intel 0000:01:00.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.216007] hda_intel: Disable MSI for Nvidia chipset
[    7.216094] HDA Intel 0000:01:00.1: setting latency timer to 64
...
[   13.780090] hda-intel: IRQ timing workaround is activated for card #1. Suggest a bigger bdl_pos_adj.

and I don't see the sound device in my Pulseaudio configuration so of
course I don't get anything out of the speakers.

I haven't tried to bisect this yet, presumably this bug came in along
with the main ALSA changes for this cycle.  Hope it's a known issue
with a fix somewhere already?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
