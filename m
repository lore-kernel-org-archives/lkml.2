Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab1D2GlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 02:41:00 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35432 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab1D2Gk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 02:40:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Igrw/GY6PCeheJk7SsbP/lpDuI2ReFGFGACk6d71oEKgpRc2kWSDsJHW4/uolQCQA+
         NWJUba6JTtIbKk6+vglSVJzwt9ygNVHiq1+0c+XNUd6cxAgKAQJ2kc2TtrR8ojJx8XEY
         J5ySas1E2ZUBUVxJAXmulWH4fnMYjs/LeNN90=
MIME-Version: 1.0
In-Reply-To: <BANLkTikFGJheY3XmdA7h8gFNvvHTjZjJnQ@mail.gmail.com>
References: <BANLkTikFGJheY3XmdA7h8gFNvvHTjZjJnQ@mail.gmail.com>
Date: Thu, 28 Apr 2011 23:40:58 -0700
X-Google-Sender-Auth: T4SZdyWBrBKGef8TcDYCzoEB9YY
Message-ID: <BANLkTimSAGzAye7idHT1nRW_oJuYZvXCqg@mail.gmail.com>
Subject: Re: PCIe/PCI rescan for new FPGA devices
From: Yinghai Lu <yinghai@kernel.org>
To: Xianghua Xiao <xiaoxianghua@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 4:06 PM, Xianghua Xiao <xiaoxianghua@gmail.com> wrote:
> I have a FPGA-PCIe device and a FPGA-PCI device that are empty at
> kernel boot time, they're only loaded after kernel is up. After I load
> FPGA images, "lspci" can not show the device, "echo 1 >
> /sys/bus/pci/rescan" also does nothing about it. With a reboot I can
> see the devices are allocated correctly though, but I want to avoid
> the reboot.
>
> I checked at fakephp(which is to be deprecated) and hotplug/rescan,
> none of that worked for this scenario.
>
> Can 'rescan' handle cases like this? or, is there a way that I tell
> the kernel to reserve a few BARs somehow in the PCI topology at
> bootime so I can "insert" the FPGAs later?

well, you did not send out the lspci -tv yet.

assume lspci tree like this

 +-[0000:c0]-+-00.0-
 |           |
 |           +-01.0-[c3]--
 |           +-03.0-[c4-c9]----00.0-[c5-c7]--+-02.0-[c6]--+-00.0 your FPGA

so c0:03.0 is pcie root port,
c4:00.0 is your pcie switch upstream port
c5:02.0 is your pcie switch downstream port
c6:0 is your FPGA controller.

so you could remove c0:03.0 or c4:00.0 or c5:02.0, then do rescan.
--- depend if your BIOS allocate the right value to the c0:03.0

Yinghai
