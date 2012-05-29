Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab2E2KE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 06:04:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab2E2KE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 06:04:57 -0400
Date: Tue, 29 May 2012 11:21:56 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Kamil Grzebien <ciptok@gmail.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Initializing iwl3945 error
Message-ID: <20120529092154.GA2441@redhat.com>
References: <CANHD2=rF6dBkLLkWAj8uS3nq0B1wCt7Uvu=HzO84UNz2kuiaFg@mail.gmail.com>
 <20120313081235.GC15333@redhat.com>
 <CAErSpo6t-cVBdJfyARi3ifEuBUvopbG5GQSP5YywrvumDK8HFA@mail.gmail.com>
 <CANHD2=qSWRv76mjwhTNMgO=u5yYCh2QZzxbNLNaPWm1d52FtOg@mail.gmail.com>
 <20120528140448.GA22783@redhat.com>
 <CAErSpo6XVgzeQiWjXJs6vxdQ5_O7LFG-j4p=4S7rQSyBdq7-SA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <CAErSpo6XVgzeQiWjXJs6vxdQ5_O7LFG-j4p=4S7rQSyBdq7-SA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 28, 2012 at 12:21:34PM -0600, Bjorn Helgaas wrote:
> linked in vs. loaded as a module after boot?  What if you add a long
> delay in the driver probe routine?

I'm attaching patch which add 200 ms delay after pci_enable_device() in
->probe routine.

Stanislaw

--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="iwl3945_pci_probe_delay.patch"

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index faec404..96fe43d 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -3635,6 +3635,8 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_ieee80211_free_hw;
 	}
 
+	msleep(200);
+
 	pci_set_master(pdev);
 
 	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));

--sm4nu43k4a2Rpi4c--
