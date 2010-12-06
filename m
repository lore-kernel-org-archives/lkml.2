Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab0LFAL1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 19:11:27 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55214 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab0LFAL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 19:11:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GvOejhTkroiDLXyDfAURWcLSf5aojt5i5ZsebMiScjkMd/xc2xYkASUPr0Yw7iTuOp
         dzwOtG0YFexVxG/5VLCACaHU26Burn54M5UFuEHTC7+9ROSCpWC9H1uiTSx0BU/WNzvV
         qxJ2hNLslLxSLZgcuhArUJuthYl9fSkaU7+pQ=
Subject: Re: Issue with firewire from 2.6.35.9 to 2.6.36.1
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Robin Cook <rcook@wyrms.net>
Cc: linux-kernel@vger.kernel.org,
        linux1394-devel <linux1394-devel@lists.sourceforge.net>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
In-Reply-To: <1291592226.7134.1.camel@pheuri.wyrms.net>
References: <1291592226.7134.1.camel@pheuri.wyrms.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Dec 2010 02:11:19 +0200
Message-ID: <1291594279.9196.2.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-12-05 at 17:37 -0600, Robin Cook wrote:
> Hello,
> 
> I recently upgraded from 26.35.9 to 2.6.36.1 and now the /dev/fwX
> devices are not being created.  I have udev 164 installed.
> 
> 2.6.35.9 dmesg firewire lines...
> 
> firewire_ohci 0000:07:00.0: PCI INT A -> GSI 44 (level, low) -> IRQ 44
> firewire_ohci 0000:07:00.0: setting latency timer to 64
> firewire_ohci: Added fw-ohci device 0000:07:00.0, OHCI v1.10, 4 IR + 8 IT contexts, quirks 0x1
> firewire_core: created device fw0: GUID 0010dc0001adc862, S400
> firewire_core: created device fw1: GUID 00808803072803a5, S100
> firewire_core: phy config: card 0, new root=ffc1, gap_count=5
> 
> 2.6.36.1 dmesg firewire lines...
> 
> firewire_ohci 0000:07:00.0: PCI INT A -> GSI 44 (level, low) -> IRQ 44
> firewire_ohci 0000:07:00.0: setting latency timer to 64
> firewire_ohci 0000:07:00.0: irq 75 for MSI/MSI-X
> firewire_ohci: Added fw-ohci device 0000:07:00.0, OHCI v1.10, 4 IR + 8 IT contexts, quirks 0x1
> 
> I have compared the difference between the two kernel configs and the
> only differences that I see that may apply to the firewire are:
> 
>  CONFIG_DNOTIFY=y
> -CONFIG_INOTIFY=y
>  CONFIG_INOTIFY_USER=y
> 
>  # CONFIG_IEEE1394 is not set 
> +CONFIG_FIREWIRE_NOSY=m  
>  CONFIG_I2O=m
> 
> On the ieee1394 wiki page it says that these kernel option are expected
> to be on for the libraw1394:
> 
> CONFIG_INOTIFY=y
> CONFIG_INOTIFY_USER=y
> CONFIG_EPOLL=y
> 
> These option are correct in the 2.6.35.9 kernel but the CONFIG_INOTIFY
> option is missing completely in the 2.6.36.1 kernel.
> 
> Is this a change in how the firewire works in the kernel and that udev
> needs to be modified or is there something else wrong?

CC'ed linux1394-devel

It looks like now firewire stack doesn't discover any devices?
I don't think its Kconfig issue.

Best regards,
	Maxim Levitsky


