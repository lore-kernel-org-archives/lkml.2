Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966237Ab2JZTnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 15:43:20 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39895 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966153Ab2JZTnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 15:43:18 -0400
Message-ID: <1351199661.2581.4.camel@joe-AO722>
Subject: Re: [pci:pci/misc 1/2] drivers/staging/telephony/ixj.c:7732:38:
 error: expected ';' before 'pci_resource_start'
From: Joe Perches <joe@perches.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <50898531.SQlMpMyNVfj8BHXY%fengguang.wu@intel.com>
References: <50898531.SQlMpMyNVfj8BHXY%fengguang.wu@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 25 Oct 2012 14:14:21 -0700
Mime-Version: 1.0
X-Mailer: Evolution 3.6.0-0ubuntu3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-26 at 02:30 +0800, Fengguang Wu wrote:
> Hi Joe,
> 
> FYI, kernel build failed on
> 
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git pci/misc
> head:   334a57560cf08a04f530aa5546b4c9379c622544
> commit: f23a277e64d8173e8cddd9e1903c3f9a564aaae5 [1/2] PCI: Convert pci_resource_<foo> macros to static inlines
> config: x86_64-allmodconfig # make ARCH=x86_64 allmodconfig
> 
> All error/warnings:
> 
> drivers/staging/telephony/ixj.c: In function 'ixj_probe_pci':
> drivers/staging/telephony/ixj.c:7732:13: warning: assignment makes integer from pointer without a cast [enabled by default]
> drivers/staging/telephony/ixj.c:7732:38: error: expected ';' before 'pci_resource_start'
> --
> drivers/scsi/gdth.c: In function 'gdth_init_pci':
> drivers/scsi/gdth.c:1111:34: error: lvalue required as left operand of assignment
> 
> vim +7732 drivers/staging/telephony/ixj.c
> 
> ^1da177e drivers/telephony/ixj.c Linus Torvalds 2005-04-16  7726  		if (pci_enable_device(pci))
> ^1da177e drivers/telephony/ixj.c Linus Torvalds 2005-04-16  7727  			break;
> ^1da177e drivers/telephony/ixj.c Linus Torvalds 2005-04-16  7728  		j = new_ixj(pci_resource_start(pci, 0));
> ^1da177e drivers/telephony/ixj.c Linus Torvalds 2005-04-16  7729  		if (!j)
> ^1da177e drivers/telephony/ixj.c Linus Torvalds 2005-04-16  7730  			break;
> ^1da177e drivers/telephony/ixj.c Linus Torvalds 2005-04-16  7731  
> ^1da177e drivers/telephony/ixj.c Linus Torvalds 2005-04-16 @7732  		j->serial = (PCIEE_GetSerialNumber)pci_resource_start(pci, 2);
> ^1da177e drivers/telephony/ixj.c Linus Torvalds 2005-04-16  7733  		j->XILINXbase = j->DSPbase + 0x10;
> ^1da177e drivers/telephony/ixj.c Linus Torvalds 2005-04-16  7734  		j->cardtype = QTI_PHONEJACK_PCI;
> ^1da177e drivers/telephony/ixj.c Linus Torvalds 2005-04-16  7735  		j->board = *cnt;
> 

Hi Fengguang.

telephony is scheduled for removal one day soon.
Likely no one has a working card.

I presume that's an existing bug in the code that this
change exposed only for x86-64 as there's no failure for
this code x86-32.  Likely too this code never worked for
x86-64.

I presume that line should have been something like this
as otherwise PCIEE_GetSerialNumber is not called.

 drivers/staging/telephony/ixj.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/telephony/ixj.c b/drivers/staging/telephony/ixj.c
index 1cfa0b0..df45ad0 100644
--- a/drivers/staging/telephony/ixj.c
+++ b/drivers/staging/telephony/ixj.c
@@ -7729,7 +7729,7 @@ static int __init ixj_probe_pci(int *cnt)
 		if (!j)
 			break;
 
-		j->serial = (PCIEE_GetSerialNumber)pci_resource_start(pci, 2);
+		j->serial = PCIEE_GetSerialNumber(pci_resource_start(pci, 2));
 		j->XILINXbase = j->DSPbase + 0x10;
 		j->cardtype = QTI_PHONEJACK_PCI;
 		j->board = *cnt;


