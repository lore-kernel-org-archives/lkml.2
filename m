Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab2CHPx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 10:53:29 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:59345 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757258Ab2CHPx1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 10:53:27 -0500
MIME-Version: 1.0
In-Reply-To: <m2lincifj9.fsf@bob.laptop.org>
References: <20120301185044.29210.44521.stgit@kaulin.local>
	<20120301185535.29210.71546.stgit@kaulin.local>
	<4F50643B.9050500@ti.com>
	<20120302172251.GJ18901@atomide.com>
	<4F548457.5050205@ti.com>
	<CANrkHUZysOnHKKUuLm0Vbo1KsNp0yUd=udjGvQ43=gTTXbWeCw@mail.gmail.com>
	<CANrkHUaYDpv=p0p81oKWCoewyjheyZYkCqvZY7_ZQxWi_=8YFw@mail.gmail.com>
	<m2lincifj9.fsf@bob.laptop.org>
Date: Thu, 8 Mar 2012 21:23:10 +0530
Message-ID: <CANrkHUbsiTz9+cRM83845=nYp82BSyje+ikV_sg3BT+64uD2XA@mail.gmail.com>
Subject: Re: [PATCH 4/4] mmc: omap_hsmmc: Simplify init for twl6030 MMC card detect
From: "T Krishnamoorthy, Balaji" <balajitk@ti.com>
To: Chris Ball <cjb@laptop.org>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tony Lindgren <tony@atomide.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Rajendra Nayak <rnayak@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 9:12 PM, Chris Ball <cjb@laptop.org> wrote:
> Hi Balaji,
>
> On Wed, Mar 07 2012, T Krishnamoorthy, Balaji wrote:
>> OMAP4 and OMAP3 HSMMC IP registers differ by 0x100 offset.
>> Addng the offset to platform_device resource structure
>> increments the start address for every insmod operation.
>> MMC command fails on re-insertion as module due incorrect register base.
>> Fix this by updating the ioremap base address only.
>>
>> Signed-off-by: Balaji T K <balajitk@ti.com>
>
> Is this a regression, or has it never worked in mainline?

Not a regression introduced in current merge window.
It happens on re-insertion of module.
will post a patch with $SUBJECT

>
>> Note:  eMMC detection is still failing on resertion due to card vcc
>> power off on rmmod
>
> And this?

This issue was hidden and uncovered after this fix.
This problem is Vcc being powered off without sleep command.

>
> Thanks,
>
> - Chris.
> --
> Chris Ball   <cjb@laptop.org>   <http://printf.net/>
> One Laptop Per Child
