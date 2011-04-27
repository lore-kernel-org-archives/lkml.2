Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759035Ab1D0MY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 08:24:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40804 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075Ab1D0MY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 08:24:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=jOzd0BSA7J9ytmS+7xfrsjR8WqVz5BH72h4J2UDLOk+zdBbBzrVLMJSafFn26x+LT7
         yyLSz5RHrPLFi60TlQAW5eM0YukhguUETRPSBDfy+lXFR6vcUNPd3UWeAgmuC+7zUx13
         BYrFX+OdjHLhj2JKtivGxJbYNYClmS567V0ds=
Message-ID: <4DB80B15.6050502@gmail.com>
Date: Wed, 27 Apr 2011 14:24:53 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Oren Weil <oren.jer.weil@intel.com>
CC: gregkh@suse.de, devel@driverdev.osuosl.org, david@woodhou.se,
        linux-kernel@vger.kernel.org, alan@linux.intel.com
Subject: Re: [PATCH 1/8] staging/mei: PCI device and char driver support.
References: <1303900057-21694-1-git-send-email-oren.jer.weil@intel.com> <1303900057-21694-2-git-send-email-oren.jer.weil@intel.com>
In-Reply-To: <1303900057-21694-2-git-send-email-oren.jer.weil@intel.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2011 12:27 PM, Oren Weil wrote:
> +	dev->mem_addr = pci_iomap(pdev, 0, 0);
...
> +	iounmap(dev->mem_addr);
...
> +	if (dev->mem_addr)
> +		iounmap(dev->mem_addr);

Just what I noticed after a quick look: you shall use pci_iounmap for
pci_iomap'ped space.

regards,
-- 
js
