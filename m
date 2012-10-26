Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966298Ab2JZTyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 15:54:18 -0400
Received: from mail.kernel.org ([198.145.19.201]:39141 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966277Ab2JZTyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 15:54:17 -0400
Date: Fri, 26 Oct 2012 12:54:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [pci:pci/misc 1/2] drivers/staging/telephony/ixj.c:7732:38:
 error: expected ';' before 'pci_resource_start'
Message-ID: <20121026195415.GA1517@kroah.com>
References: <50898531.SQlMpMyNVfj8BHXY%fengguang.wu@intel.com>
 <1351199661.2581.4.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351199661.2581.4.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 02:14:21PM -0700, Joe Perches wrote:
> On Fri, 2012-10-26 at 02:30 +0800, Fengguang Wu wrote:
> > Hi Joe,
> > 
> > FYI, kernel build failed on
> > 
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git pci/misc
> > head:   334a57560cf08a04f530aa5546b4c9379c622544
> > commit: f23a277e64d8173e8cddd9e1903c3f9a564aaae5 [1/2] PCI: Convert pci_resource_<foo> macros to static inlines
> > config: x86_64-allmodconfig # make ARCH=x86_64 allmodconfig
> > 
> > All error/warnings:
> > 
> > drivers/staging/telephony/ixj.c: In function 'ixj_probe_pci':
> > drivers/staging/telephony/ixj.c:7732:13: warning: assignment makes integer from pointer without a cast [enabled by default]
> > drivers/staging/telephony/ixj.c:7732:38: error: expected ';' before 'pci_resource_start'
> > --
> > drivers/scsi/gdth.c: In function 'gdth_init_pci':
> > drivers/scsi/gdth.c:1111:34: error: lvalue required as left operand of assignment
> > 
> > vim +7732 drivers/staging/telephony/ixj.c
> > 
> > ^1da177e drivers/telephony/ixj.c Linus Torvalds 2005-04-16  7726  		if (pci_enable_device(pci))
> > ^1da177e drivers/telephony/ixj.c Linus Torvalds 2005-04-16  7727  			break;
> > ^1da177e drivers/telephony/ixj.c Linus Torvalds 2005-04-16  7728  		j = new_ixj(pci_resource_start(pci, 0));
> > ^1da177e drivers/telephony/ixj.c Linus Torvalds 2005-04-16  7729  		if (!j)
> > ^1da177e drivers/telephony/ixj.c Linus Torvalds 2005-04-16  7730  			break;
> > ^1da177e drivers/telephony/ixj.c Linus Torvalds 2005-04-16  7731  
> > ^1da177e drivers/telephony/ixj.c Linus Torvalds 2005-04-16 @7732  		j->serial = (PCIEE_GetSerialNumber)pci_resource_start(pci, 2);
> > ^1da177e drivers/telephony/ixj.c Linus Torvalds 2005-04-16  7733  		j->XILINXbase = j->DSPbase + 0x10;
> > ^1da177e drivers/telephony/ixj.c Linus Torvalds 2005-04-16  7734  		j->cardtype = QTI_PHONEJACK_PCI;
> > ^1da177e drivers/telephony/ixj.c Linus Torvalds 2005-04-16  7735  		j->board = *cnt;
> > 
> 
> Hi Fengguang.
> 
> telephony is scheduled for removal one day soon.
> Likely no one has a working card.

Ah, I forgot about that one, I'll just go delete it, it's past when we
said it would go away, so we've waited long enough now.

thanks,

greg k-h
