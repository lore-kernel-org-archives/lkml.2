Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933753Ab0FEQvq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 12:51:46 -0400
Received: from vs81.sauer-cs.de ([80.244.252.81]:43029 "EHLO kbdbabel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933666Ab0FEQvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 12:51:44 -0400
Date: Sat, 5 Jun 2010 20:50:57 +0400 (MSD)
From: Alexander Kurz <linux@blala.de>
X-X-Sender: linux@vs81.sauer-cs.de
To: Borislav Petkov <bp@amd64.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Alexander Kurz <linux@kbdbabel.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, gregkh@suse.de
Subject: Re: linux-next: Tree for June 2 (staging/comedi)
In-Reply-To: <20100603091555.GA25287@aftab>
Message-ID: <alpine.DEB.1.10.1006052043140.21893@vs81.sauer-cs.de>
References: <20100602151439.6de66132.sfr@canb.auug.org.au> <20100602100735.0812c063.randy.dunlap@oracle.com> <20100603091555.GA25287@aftab>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
could you please repeat the test on 2.6.35-rc1-git3 or later

On Thu, 3 Jun 2010, Borislav Petkov wrote:
> I get a different set of errors with 2.6.35-rc1:
> 
> ERROR: "cfc_write_array_to_buffer" [drivers/staging/comedi/drivers/usbduxfast.ko] undefined!
> ERROR: "cfc_write_array_to_buffer" [drivers/staging/comedi/drivers/comedi_test.ko] undefined!
was caused by
> CONFIG_COMEDI_FC=y
and is fixed in 824196248c1f28aa7d151fd5b11d76182c751f19
by adding COMEDI_FC depends on COMEDI.
CONFIG_COMEDI_FC=m would be correct.

> ERROR: "subdev_8255_cleanup" [drivers/staging/comedi/drivers/das08.ko] undefined!
> ERROR: "subdev_8255_init" [drivers/staging/comedi/drivers/das08.ko] undefined! 
CONFIG_COMEDI_8255=m should have been set.
this should be as well fixed in 824196248c1f28aa7d151fd5b11d76182c751f19 
by pulling das08 out of the ISA group.

thanks, Alexander
