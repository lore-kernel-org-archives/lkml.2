Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492Ab0HJVtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 17:49:19 -0400
Received: from vs244178.vserver.de ([62.75.244.178]:43031 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390Ab0HJVtS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 17:49:18 -0400
Date: Tue, 10 Aug 2010 23:48:55 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1344272543.20100810234855@eikelenboom.it>
To: Joerg Roedel <joro@8bytes.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [2.6.35] AMD-Vi: Enabling IOMMU at 0000:00:00.2 cap 0x40  BUG: unable to handle kernel NULL pointer dereference at 0000000000000198
In-Reply-To: <20100810212551.GU23755@8bytes.org>
References: <1154489525.20100810164850@eikelenboom.it> <20100810162606.GQ23755@8bytes.org> <419601760.20100810185745@eikelenboom.it> <20100810180122.GR23755@8bytes.org> <1609756756.20100810200514@eikelenboom.it> <20100810202839.GS23755@8bytes.org> <618241473.20100810223635@eikelenboom.it> <20100810204721.GT23755@8bytes.org> <1893257730.20100810225726@eikelenboom.it> <20100810212551.GU23755@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,

Ok it boots ok now, but plugging in a USB device in the 2.0 controller (0a.01.*) results in a flood of error messages about the usb controller not functioning.
When running same kernel with amd_iommu=off results in ...the device at least registering properly as usb device (altough trying to use it now resulted in an entirely new oops probably in the driver of the videograbber.)

--
Sander

Tuesday, August 10, 2010, 11:25:51 PM, you wrote:

> On Tue, Aug 10, 2010 at 10:57:26PM +0200, Sander Eikelenboom wrote:
>> Hmmm the fun part seems to be .. that the usb devices on that usb2
>> controller seemed to work fine on Xen.

> Hmm, thats weird. In this case these devices probably do not alias at
> all. But lets wait for the results when you test my patch.


>>            +-0a.0-[0000:09-0a]----00.0-[0000:0a]--+-01.0
>>            |                                      +-01.1
>>            |                                      \-01.2

> Yeah, device 09:00.0 is a PCIe-to-PCI bridge and the addtional USB
> controlers are behind that bridge as legacy PCI devices. Thats why the
> BIOS sets up the alias-entry. It should set up 09:00.0 instead of
> 0a:00.0 to make things work correctly.

>         Joerg




-- 
Best regards,
 Sander                            mailto:linux@eikelenboom.it

