Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760218Ab1JGQgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 12:36:51 -0400
Received: from smtp-out.google.com ([74.125.121.67]:18304 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760163Ab1JGQgt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 12:36:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=SranC/lUrZcvpTnD8tkeuVS7vaR5LrV1sipTZ9nPr7cumyWefpdUwLOFi6R2D1VWo
	qVTeyaspCcw6Lt8ih/ItA==
MIME-Version: 1.0
In-Reply-To: <4E8F2758.3040408@ezono.com>
References: <4E8EA746.6030103@ezono.com> <CAErSpo6YEp2v9xzVJHsu5WSJDqb+sWZUfS-e7UmGEXENRiWmnQ@mail.gmail.com>
 <4E8F2758.3040408@ezono.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 7 Oct 2011 10:36:26 -0600
Message-ID: <CAErSpo6Lo2bXw=yjscQ6zzRMnpMZ-cUzbBxN3dDS1D3M67sQ8g@mail.gmail.com>
Subject: Re: PCIe can not rescan for new PCIe device ( FPGA board )
To: Abdelghani Ouchabane <abdelghani@ezono.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 7, 2011 at 10:22 AM, Abdelghani Ouchabane
<abdelghani@ezono.com> wrote:
> Bjorn Helgaas wrote:
>>
>> [added cc: linux-pci@vger.kernel.org]
>>
>> On Fri, Oct 7, 2011 at 1:16 AM, Abdelghani Ouchabane
>> <abdelghani@ezono.com> wrote:
>>
>>>
>>> Hallo,
>>>
>>>  We are developing a FPGA board connected to a Fedora 15 PC host over
>>> PCIe.
>>> Right now, in the implementation and debug phase, I often need to power
>>> off
>>> and
>>> power on the device or try different boards. This causes a problem with
>>> the
>>> Fedora 15 running on the AMD PC.
>>>
>>> Typically the PC is booted when I need to insert the device under test.
>>> As
>>> expected, the Linux doesn't find the device and the software app cannot
>>> talk
>>> to it.
>>>
>>> * If I do "lspci -v" then it does not list our device.
>>>
>>
>> Do you have pciehp enabled and loaded?  I would think a PCIe hot-add
>> should automatically rescan the bus.  Does dmesg say anything when you
>> do the hot-add?
>>
>
> Thanks Bjorn,
>
> Yes, I have them :
>
> ****************************************************************************************************
> lsmod :
>
> pciehp                 20282  0
> cgosdrv                17632  0
> ****************************************************************************************************
> /etc/modprobe.d/pciehp.conf
> alias pci:v00001234d00000002sv00001234sd00000001bc11sc80i00 pciehp
> options pciehp pciehp_force=1 pciehp_debug=1
> ****************************************************************************************************
>
> After I plug my board in,  I executed  echo 1 > /sys/bus/pci/rescan

It seems like a pciehp bug that you have to rescan explicitly.  But
I'm not a pciehp expert and I haven't looked at the code.

>>> * But our software returns : 0xFFFFFFFF

This is reading from your device's memory region.  It looks like the
device is configured correctly (BAR values are reasonable and memory
decoding is enabled) and I assume the bridges leading to it are
configured correctly (if you posted the complete dmesg log we could
tell for sure).  After that point, Linux is out of the way and it's
just a question of whether your device responds correctly to the
memory access.

Are you sure the device is supposed to return something other than
0xFFFFFFFF?  If it's memory, can you write to it and read the new
value back?  Can you use a PCIe analyzer and see if the device is
responding correctly on the bus?

Other than the possible pciehp rescan problem, this just looks like a
problem with your FPGA.

Bjorn
