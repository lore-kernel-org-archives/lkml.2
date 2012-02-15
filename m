Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab2BOLzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 06:55:19 -0500
Received: from coyote.quickmin.net ([217.14.112.24]:57505 "EHLO
	coyote.quickmin.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab2BOLzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 06:55:18 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Feb 2012 06:55:17 EST
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=default; d=telemotive.de;
  b=pXeoEyozgGCUoUJ7ik9LoC4nVWN9ZWDRa27891ck0uhNte7iYMtG/g2NGF3uQrXJyPRAzIIEUEM2eDAKhnoqo7DWJCIcFEEfed0OXn1YX58Fj0bf5UpXvymFTq2QDdTKqJr4gRF39rVBP9JIfM4kqOmoSmS3hPmv6jv4d//6N5Y=  ;
From: Roman Fietze <roman.fietze@telemotive.de>
Organization: Telemotive AG
To: Shaohua Li <shaohua.li@intel.com>
Subject: ASPM, devices with mixed PCIe/PCI functions
Date: Wed, 15 Feb 2012 12:48:34 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-0.11-default; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-Id: <201202151248.34578.roman.fietze@telemotive.de>
X-MIMETrack: Itemize by SMTP Server on muc/Telemotive(Release 8.5.3|September 15, 2011) at
 15.02.2012 12:48:34,
	Serialize by Router on muc/Telemotive(Release 8.5.3|September 15, 2011) at
 15.02.2012 12:48:34,
	Serialize complete at 15.02.2012 12:48:34
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7bit
Content-Type: Text/Plain;
  charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm referring to commit ddc9753fcddfe5f.

On our system we use a PCIe-Local-Bridge, the PEX8311, which
internally is a quick and dirty design glued together using a PEX8111
and a PEX9056. I'm now just talking about the PEX8111, which is a PCIe
to PCI-X bridge.

The function pcie_aspm_sanity_check() in drivers/pci/pcie/aspm.c
disables ASPM for this bridge, because the child (PEX9056) is not
PCIe, hereby disabling power savings on the upstream PCIe link.

Is this a flaw? What is the reason for this? Could please someone with
more PCI(e) knowledge enlighten me?

I'm of course willing to deliver a patch to fix this (IMHO) problem,
but this only makes sense if I'm not totally wrong in my assumption,
that ASPM should be enabled on such devices (besides the fact, that
the PEX8111 does not have PCI_EXP_DEVCAP_RBER set).


Roman

-- 
Roman Fietze              Telemotive AG Buero Muehlhausen
Breitwiesen                             73347 Muehlhausen
Tel.: +49(0)7335/18493-45        http://www.telemotive.de
