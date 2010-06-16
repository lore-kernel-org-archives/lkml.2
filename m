Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723Ab0FPGH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 02:07:59 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62014 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab0FPGH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 02:07:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ULiFmu8NY3qpdsEKdJqCaqMJ7DuzqFQ7en0ycO4rbTJEC8BB/9kJi4PDYcO1mbuElJ
         mX6yjOwW/zOATXc1GR8/qEB/cCCNus8qpgbyzEmdnWIEGpdAqdm84ifphXw4YMMht8nl
         oMfuYiNC65QgByPFAN6KxX7SC4BeRCvnAZCU0=
Date: Wed, 16 Jun 2010 14:07:41 +0800
From: Junchang Wang <junchangwang@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/5]pci:bus.c Fix variable 'retval' set but not used
Message-ID: <20100616060738.GA12461@host-a-229.ustcsz.edu.cn>
References: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>
 <1276666434-11227-4-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276666434-11227-4-git-send-email-justinmattock@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 10:33:52PM -0700, Justin P. Mattock wrote:
>@@ -234,12 +234,10 @@ void pci_bus_add_devices(const struct pci_bus *bus)
> void pci_enable_bridges(struct pci_bus *bus)
> {
> 	struct pci_dev *dev;
>-	int retval;
> 
> 	list_for_each_entry(dev, &bus->devices, bus_list) {
> 		if (dev->subordinate) {
> 			if (!pci_is_enabled(dev)) {
>-				retval = pci_enable_device(dev);
Hi Justin,

pci_enable_device initializes device before it's used by a driver.

I think you should add check instead of eliminating pci_enable_device.

For example,
retval = pci_enable_device(dev);
if (retval < 0) {
	goto handle_err;
}

--Junchang

