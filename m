Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab0C2PnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 11:43:01 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:33130 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab0C2Pm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 11:42:59 -0400
X-Spam-Processed: digidescorp.com, Mon, 29 Mar 2010 10:42:58 -0500
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=17043c47b5=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] Xilinx MPMC SDMA subsystem
From: "Steven J. Magnani" <steve@digidescorp.com>
Reply-To: steve@digidescorp.com
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Sergey Temerkhanov <temerkhanov@cifronik.ru>,
       microblaze-uclinux@itee.uq.edu.au,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@lists.ozlabs.org
In-Reply-To: <fa686aa41003261653j5a9be6e8gbe8f12e19a563cd6@mail.gmail.com>
References: <201003172118.41559.temerkhanov@cifronik.ru>
	 <fa686aa41003261653j5a9be6e8gbe8f12e19a563cd6@mail.gmail.com>
Content-Type: text/plain
Organization: Digital Design Corporation
Date: Mon, 29 Mar 2010 10:42:53 -0500
Message-Id: <1269877373.6173.27.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-26 at 17:53 -0600, Grant Likely wrote:
> I've not got time to review this patch right now, but Sergey and
> Steven, you both posted MPMC drivers on the same day; Steven on the
> microblaze list and Sergey on the powerpc list.  Can you two please
> coordinate and figure out how to mork toward a single driver that will
> meet both your needs?  I don't want to have 2 drivers (3 if you count
> the ll_temac driver) in mainline for the same hardware interface.
> 

I don't think we'll end up with a single driver. A MPMC DMA Engine
driver is useful only on "loopback" SDMA ports. Sergey's code looks like
a nice generic interface to Xilinx SDMA HW that could be used by the
xlldma and ll_temac drivers, for instance. Both of those will get
smaller, but won't go away.

For this to be useful to me, it would need to be located somewhere more
accessible than arch/powerpc and it would need to have initialization
methods that don't depend on OF. In my build I would have platform code
that binds to the xlldma platform attachment, which would call Sergey's
SDMA code to assign it the proper resources. 

Any objections to having Sergey's code live in drivers/dma, and putting
sdma.h out in include/linux? Might need to tweak the file/function names
some to head off namespace issues. Or is there some other strategy for
managing Xilinx-related drivers common to both Microblaze and PowerPC?

Steve


