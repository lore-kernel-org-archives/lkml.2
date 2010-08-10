Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777Ab0HJSFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 14:05:31 -0400
Received: from vs244178.vserver.de ([62.75.244.178]:44473 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757679Ab0HJSF1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 14:05:27 -0400
Date: Tue, 10 Aug 2010 20:05:14 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1609756756.20100810200514@eikelenboom.it>
To: Joerg Roedel <joro@8bytes.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [2.6.35] AMD-Vi: Enabling IOMMU at 0000:00:00.2 cap 0x40  BUG: unable to handle kernel NULL pointer dereference at 0000000000000198
In-Reply-To: <20100810180122.GR23755@8bytes.org>
References: <1154489525.20100810164850@eikelenboom.it> <20100810162606.GQ23755@8bytes.org> <419601760.20100810185745@eikelenboom.it> <20100810180122.GR23755@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Joerg,

Could you also provide a perhaps more specific message what is wrong with the bios, that i could forward to MSI, in the hope it will reach the bios engineers someday ? :-)

--
Sander

Tuesday, August 10, 2010, 8:01:22 PM, you wrote:

> On Tue, Aug 10, 2010 at 06:57:45PM +0200, Sander Eikelenboom wrote:
>> The requested info is attached.
>> So that would mean a bios problem ? (those are not on my wishlist :-p)

> Yeah, looks like a BIOS problem. But the driver should handle that
> without crashing the system, so there is a bug in the driver too.

> Problem is:

> AMD-Vi:   DEV_ALIAS_RANGE         devid: 0a:01.0 flags: 00 devid_to: 0a:00.0
> AMD-Vi:   DEV_RANGE_END           devid: 0a:1f.7

> This means that PCI devices from 0a:01.0 to 0a:1f.7 may use their own
> device-id or 0a:00.0. But a device which id 0a:00.0 is not present in
> the system. From the lspci output this looks like your USB3 controler
> should alias to 09:00.0. I prepare a patch for you to fix the crash but
> I can't guarantee that your USB3 controler will work afterwards. If you
> see IO-Page-Faults please report them to me.

>         Joerg




-- 
Best regards,
 Sander                            mailto:linux@eikelenboom.it

