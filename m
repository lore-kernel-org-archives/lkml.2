Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab0JWIRV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 04:17:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53066 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab0JWIRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 04:17:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=o2QojA+uikUQkn4kX2NcCclf2+KqctTF5KX/+CYUxX46H0MxEXhnGBl6dCrvIx0FJ2
         6Tti5a7hARXhQjsUCaGXOjfrVow7VkACDcvNxoJDO909wvTsejc/w/EbSt8d5cxOoKC2
         xkpcY6nGc1QN7nw2iXPAEFkmJ4LG/6HkKM2f8=
Message-ID: <4CC29A0A.7070405@gmail.com>
Date: Sat, 23 Oct 2010 10:17:14 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.11) Gecko/20101013 SUSE/3.1.5 Thunderbird/3.1.5
MIME-Version: 1.0
To: andiry.xu@amd.com
CC: dong.nguyen@amd.com, libin.yang@amd.com, sarah.a.sharp@linux.intel.com,
        Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: XHCI: sleep inside atomic
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Stanse found that commit
    USB: xHCI: PCI power management implementation
added xhci_setup_msix->kmalloc(GFP_KERNEL) and request_irq inside
xhci->lock spinlock. As these functions may sleep, this is deadlockable.
Could you fix that?

thanks,
-- 
js
