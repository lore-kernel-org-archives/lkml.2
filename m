Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab2DPTEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 15:04:40 -0400
Received: from nm34.bullet.mail.bf1.yahoo.com ([72.30.238.192]:35554 "HELO
	nm34.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752578Ab2DPTEj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 15:04:39 -0400
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Apr 2012 15:04:38 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 426069.6173.bm@omp1031.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=MC0LjSttzja91Y665xVbH58WZPPfVlkWsbekejiLICrksMDZxd5BlkXyhmcabYMpKB+NZwQV9Vxj/3pbW1263CVmUv25Ca8mrOg9zdtUypow/gUOsmLLtd2AV46DRMCyXc4x+hWMShEzAYq8WBOKLIOFeiTXldoJaj3tCzOyiMo=;
X-YMail-OSG: nogfN8oVM1nOh8eYH2XknYWBmoyVOmWdXlGw27a2C7ve1za
 pecM5nVGIqz13X4vzSb_7ylRBRyGx78N1sF_V4KzU5oad7iTVeU6InrZOtPD
 RU0YkE7YrPe3613EUuhzQbdylQNwsySBnLzCmWBvewLHGEj3VkSiFW1_F1m3
 vH70Zey.5QVidiNT17xLAPA1WZF6oDsEkjtj5ovHvfaRa4k.6PaTCzL7jLn.
 bH18IJjaneSgAmREe2i2GdUrMDzpEWrLIj1lVJNQpJk8OH76qXVljjG24E3Y
 d79WbUWWvdFto3wx7lC57J_8cSt6b7GTvlOtPW8WwUo2iSZSdW0OggNKSxFT
 Ir3hHfQR3zOWpMGO4_IjrrTgBYdKsDiCOYFsRGvsIqAyByDnUPDdjLViKp9Y
 kjFV_d4OOVFcPGbIgDiRD0Ox3QUxO8rlum.gT.iFMFE3zqWIy1sUIo2fXMHY
 a2yjHds2pKE4WiDFJYyP3DrXI0cfaUJz45M05DCHlWIY6Iah6
X-Mailer: YahooMailWebService/0.8.117.340979
References: <1334310754.17013.YahooMailNeo@web161804.mail.bf1.yahoo.com> <201204152256.03198.rjw@sisk.pl> <1334560992.32851.YahooMailNeo@web161806.mail.bf1.yahoo.com> <201204161817.21800.rjw@sisk.pl>
Message-ID: <1334602665.33371.YahooMailNeo@web161806.mail.bf1.yahoo.com>
Date: Mon, 16 Apr 2012 11:57:45 -0700 (PDT)
From: Mikko Vinni <mmvinni@yahoo.com>
Reply-To: Mikko Vinni <mmvinni@yahoo.com>
Subject: Re: [linux-pm] "i8042: Can't reactivate AUX port" after s2ram on 3.4-rc2
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Allen Kay <allen.m.kay@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
In-Reply-To: <201204161817.21800.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki:

>>  Ok, I tested v4 and also v3, which is in 3.4-rc3. On this laptop both 
> versions
>>  work equally: touchpad works after resume (no help for the card reader
>>  problem, though).
> 
> [...]
> 
>>  Difference from v3:
>>  --- /tmp/v3-uniq        2012-04-16 09:57:42.880521878 +0300
>>  +++ /tmp/v4-uniq        2012-04-16 09:58:03.880545386 +0300
>>  @@ -1019,11 +1018,11 @@
>>         1 Booting Node 0 Processor 1 APIC 0x1
>>         1 CPU1 is up
>>         1 ACPI: Waking up from system sleep state S3
>>  -     11 pcieport 0000:00:02.0: restoring config space at offset 0x1c (was 
> 0x20005151, writing 0x5151)
>>  +      1 pcieport 0000:00:02.0: restoring config space at offset 0x1c (was 
> 0x20005151, writing 0x5151)
> 
> OK, so clearly we need to prevent the writes into the secondary status register
> of the PCIe port from being repreated pointlessly.
> 
> Can you please test the appended patch from completness on top of 3.4-rc3?

I think that's what I did already :)

git pull to 3.4-rc3
(test, result as v3 output/diff in the previous email)
Revert "PCI: Fix regression in pci_restore_state(), v3"
apply v4 of the patch
(test, result as v4 output in the previous email)
git diff v3.4-rc3 -- drivers/pci/pci.c --> matches the patch below


Mikko


> 
> Rafael
> 
> 
> ---
> drivers/pci/pci.c |   18 +++++++++++-------
> 1 file changed, 11 insertions(+), 7 deletions(-)
> 
> Index: linux/drivers/pci/pci.c
> ===================================================================
> --- linux.orig/drivers/pci/pci.c
> +++ linux/drivers/pci/pci.c
> @@ -1015,13 +1015,17 @@ void pci_restore_state(struct pci_dev *d
>     pci_restore_pcie_state(dev);
>     pci_restore_ats_state(dev);
> 
> -    pci_restore_config_space(dev, 10, 15, 0);
> -    /*
> -     * The Base Address register should be programmed before the command
> -     * register(s)
> -     */
> -    pci_restore_config_space(dev, 4, 9, 10);
> -    pci_restore_config_space(dev, 0, 3, 0);
> +    if (dev->hdr_type == PCI_HEADER_TYPE_NORMAL) {
> +        pci_restore_config_space(dev, 10, 15, 0);
> +        /*
> +         * The Base Address register should be programmed before the
> +         * command register(s)
> +         */
> +        pci_restore_config_space(dev, 4, 9, 10);
> +        pci_restore_config_space(dev, 0, 3, 0);
> +    } else {
> +        pci_restore_config_space(dev, 0, 15, 0);
> +    }
> 
>     pci_restore_pcix_state(dev);
>     pci_restore_msi_state(dev);
> 
