Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209Ab0EBRgH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 13:36:07 -0400
Received: from p01c12o141.mxlogic.net ([208.65.145.64]:48961 "EHLO
	p01c12o141.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab0EBRgB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 13:36:01 -0400
X-MXL-Hash: 4bddb8015a792b29-89c3faba663cf935a11b369eb0d858efd8a26d7c
X-MXL-Hash: 4bddb7fe39d7683c-3eca7ffdfbbc8b9510f1cabae83f613b38f43776
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <greg@kroah.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       "ss@aao.gov.au" <ss@aao.gov.au>
Date: Sun, 2 May 2010 12:35:51 -0500
Subject: RE: [PATCH] Staging: dt3155: Cleanup memory mapped i/o access
Thread-Topic: [PATCH] Staging: dt3155: Cleanup memory mapped i/o access
Thread-Index: AcrpTXSDAe6CiT+tQ1qgv9uArHaulwA0BGkg
Message-ID: <0D753D10438DA54287A00B0270842697636E9B9B08@AUSP01VMBX24.collaborationhost.net>
References: <0D753D10438DA54287A00B0270842697636DAFCD14@AUSP01VMBX24.collaborationhost.net>
 <20100430215645.GA12409@kroah.com>
In-Reply-To: <20100430215645.GA12409@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010043001)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.178]
X-AnalysisOut: [v=1.0 c=1 a=JOBpZgLcNDIA:10 a=VphdPIyG4kEA:10 a=kj9zAlcOel]
X-AnalysisOut: [0A:10 a=N0rcUYRaQg3G+2kUXxmxxA==:17 a=i00gxMtYAAAA:8 a=Dx-]
X-AnalysisOut: [d76IhDorM3sAMhNIA:9 a=3ASGjPp2_wtgu0PsMBCzI0o86nUA:4 a=Cju]
X-AnalysisOut: [IK1q_8ugA:10 a=x1WnkoZAwusA:10 a=0kPLrQdw3YYA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 30, 2010 2:57 PM, Greg KH wrote:
> On Wed, Apr 28, 2010 at 12:23:09PM -0500, H Hartley Sweeten wrote:
>> The macros ReadMReg and WriteMReg are really just private versions of
>> the kernel's readl and writel functions.  Use the kernel's functions
>> instead.  And since ioremap returns a (void __iomem *) not a (u8 *),
>> change all the uses of dt3155_lbase to reflect this.
>> 
>> While here, make dt3155_lbase static since it is only used in the
>> dt3155_drv.c file.  Also, remove the global variable dt3155_bbase
>> since it is not used anywhere in the code.
>> 
>> Where is makes sense, create a local 'mmio' variable instead of using
>> dt3155_lbase[minor] to make the code more readable.
>> 
>> This change also affects the {Read|Write}I2C functions so they are
>> also modified as needed.
>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> Cc: Greg Kroah-Hartman <gregkh@suse.de>
>> Cc: Scott Smedley <ss@aao.gov.au>
>> 
>> --- a/drivers/staging/dt3155/dt3155_drv.c
>
> This doesn't apply at all against the latest linux-next tree.  Care to
> redo it and resend it (not in base64 please.)

Hmm... Strange, I just rechecked the patch against next-20100430.  It
applied with no issues.

I'll resend in just a bit.  Hopefully this is just a mail issue.

> thanks,
>
> greg k-h

Regards,
Hartley
