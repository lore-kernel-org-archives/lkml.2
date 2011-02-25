Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab1BYS3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 13:29:06 -0500
Received: from mail.fuw.edu.pl ([193.0.80.14]:42757 "EHLO mail.fuw.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932436Ab1BYS3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 13:29:05 -0500
From: "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH v2 2/3] sdhci-pci : Enable runtime PM support
Date: Fri, 25 Feb 2011 19:28:22 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc6+; KDE/4.4.4; x86_64; ; )
Cc: "Tardy, Pierre" <pierre.tardy@intel.com>, Chris Ball <cjb@laptop.org>,
        Pierre Tardy <tardyp@gmail.com>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gao, Yunpeng" <yunpeng.gao@intel.com>
References: <cover.1297014479.git.pierre.tardy@intel.com> <8250E4885F9967469CAC3FB5CBA2CE69935212DEA0@irsmsx501.ger.corp.intel.com> <20110225145440.GA31620@srcf.ucam.org>
In-Reply-To: <20110225145440.GA31620@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102251928.22328.rwys@fuw.edu.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 25, 2011, Matthew Garrett wrote:
> On Fri, Feb 25, 2011 at 07:33:12AM +0000, Tardy, Pierre wrote:
> 
> > My understanding is the pci driver is not supposed to do any set_power_state/pci_save_state/wake_enable.
> > Everything is supposed to be generically handle by pci frameworks's runtime_pm impl.
> > Need confirmation from Rafael.
> 
> The core can only enable PME generation, it can't configure what 
> generates PMEs. There's a register in sdhci that needs to be programmed 
> to enable wakeups on card insert/removal/interrupt. If you don't then 
> you won't get a PME no matter what the core does.

That's correct.  The driver shoulnd't touch the generic-PCI part of wakeup
preparation, but it _should_ configure the device-specific part of it.

It's quite similar to network adapters where you have to configure the adapter
to react to magic packets, for example, in addition to the PCI PME setup done
by the core.

Thanks,
Rafael
