Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab1HPQwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 12:52:14 -0400
Received: from masquerade.micron.com ([137.201.242.130]:35128 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab1HPQwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 12:52:12 -0400
Message-ID: <4E4AA00E.60107@micron.com>
Date: Tue, 16 Aug 2011 10:51:26 -0600
From: Asai Thambi S P <asamymuthupa@micron.com>
Reply-To: <asamymuthupa@micron.com>
Organization: Micron
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Moyer <jmoyer@redhat.com>,
        <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>, Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH v3 1/3] drivers/block/mtip32xx: Adding header file and
 source for pci and block related operation
References: <22A973199D2C2F46933448F6E7990A3002C80025@ntxboimbx31.micron.com> <20110811224629.GA10182@infradead.org>
In-Reply-To: <20110811224629.GA10182@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.16.30.125]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.500.1024-18254.002
X-TM-AS-Result: No--19.927700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/11/2011 4:46 PM, Christoph Hellwig wrote:
> On Thu, Aug 11, 2011 at 12:52:43PM -0600, Asai Thambi Samymuthu Pattrayasamy (asamymuthupa) [CONTRACTOR] wrote:
>> This is the first part of the new block driver,mtip32xx, for Micron
>> PCIe SSD, which contains the header file and source for pci and
>> block related operations.
> 
> There should be not split between pci/block and hardware related
> functions, as there is no logical split either.  Please remove that
> layering and merge the files into one.  Also given that the hardware
> really just is AHCI with extensions please use the constants from
> include/linux/ata.h and drivers/ata/ahci.h instead of redefining them.
> The latter might need to be move to include/linux before merging the
> driver for that, but for the next iteration a hacky relative include
> might be enough.
> 
> Also please get rid of the MTIP_USE_TASKLET, if it really is worth it
> it needs to be seletable at runtime.
> 
> I can't see any point of the CONFIG_PCI_MSI ifdefs - all the functions
> called under it are properly stubbed out if it's not enabled.

Thanks for the feedback. We have taken care of these. There are two
follow-ups to do.
  1. moving whole or part of drivers/ata/ahci.h to include/linux
  2. mtip32xx support 32-bit ioctls too. For now, we have defined compat
equivalent of struct ide_task_request_s locally. We need this support in
hdreg.h

-- 
Regards,
Asai Thambi
