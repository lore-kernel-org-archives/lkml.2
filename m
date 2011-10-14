Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304Ab1JNJkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 05:40:21 -0400
Received: from ezo.ezono.com ([50.22.105.208]:54452 "EHLO ezo.ezono.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617Ab1JNJkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 05:40:19 -0400
Message-ID: <4E98037C.4000403@ezono.com>
Date: Fri, 14 Oct 2011 11:40:12 +0200
From: Abdelghani Ouchabane <abdelghani@ezono.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: PCIe can not rescan for new PCIe device ( FPGA board )
References: <4E8EA746.6030103@ezono.com> <CAErSpo6YEp2v9xzVJHsu5WSJDqb+sWZUfS-e7UmGEXENRiWmnQ@mail.gmail.com> <4E8F2758.3040408@ezono.com> <CAErSpo6Lo2bXw=yjscQ6zzRMnpMZ-cUzbBxN3dDS1D3M67sQ8g@mail.gmail.com> <4E939E5D.3010208@jp.fujitsu.com> <4E93FA3D.2030400@ezono.com> <4E953579.6050807@jp.fujitsu.com> <4E95516F.60300@ezono.com> <4E96DE8A.6050404@jp.fujitsu.com>
In-Reply-To: <4E96DE8A.6050404@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ezo.ezono.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - ezono.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/10/11 14:50, Kenji Kaneshige wrote:
> Thank you for the information. Though I don't have any good news for you,
> I think as follows based on the info.
>
> - There are two hot-plug capable PCIe slots on your machine.
>
> - But, it seems you are using fakephp driver, not pciehp (is that
>   correct?). The fakephp cannot handle hot-plug event such as presence
>   change event on the slot. This is why the bus is not scanned automatically.
>
> - Unfortunately, the bus would not be scanned automatically even if you
>   use pciehp. As I told you in the previous email, current pciehp don't
>   scan the bus automatically only if the slot is hot-plug surprise
>   capable. According to the lspci output, your hotplug controller is not
>   hot-plug surprise capable.
>
> - I don't think pciehp solve invalid register read problem. According to
>   the lspci output, power controller capability isn't present on your
>   hotplug controller. On such environment, pciehp driver does almost the
>   same thing as fakephp does (just scan the bus/remove the pci device data
>   structure) except hot-plug event handling.
>
> But it's worth whole trying pciehp.
> By the way, have you tried acpiphp? It might help you.
>
> Regards,
> Kenji Kaneshige
>

Hallo Kenji,

many thanks for your great supports. The new BIOS from Congatec solves
the problem.

I using both fakephp & pciehp drivers, Can I use both drivers at the
same time?

I am using fakephp because I need "/sys/bus/pci/slots/0000\:02\:00.0/power".

Other thing: my Kernel has "CONFIG_ACPI_PROC_EVENT is not set", does
this explain why the scan is not performed automatically?

[root@localhost ~]# modprobe acpiphp
FATAL: Error inserting acpiphp
(/lib/modules/2.6.40.3-0.119.delos.i686/kernel/drivers/pci/hotplug/acpiphp.ko):
No such device

What is the advantage to use acpiphp ?


Cheers,
Ghani





