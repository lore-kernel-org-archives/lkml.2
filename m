Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab0IIJ3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 05:29:21 -0400
Received: from mtagate7.de.ibm.com ([195.212.17.167]:32897 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab0IIJ3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 05:29:17 -0400
Date: Thu, 9 Sep 2010 11:29:06 +0200
From: Christof Schmitt <christof.schmitt@de.ibm.com>
To: Anil kumar <anils_r@yahoo.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: scsi_cmnd data_buffer checksum
Message-ID: <20100909092906.GA21760@schmichrtp.mainz.de.ibm.com>
References: <20100909085142.GA15327@schmichrtp.mainz.de.ibm.com>
 <215508.92384.qm@web32402.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <215508.92384.qm@web32402.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 09, 2010 at 02:09:28AM -0700, Anil kumar wrote:
> I quickly tried copying the data buffer to local buffers as follows:
> 
> In Queuecommand:
> 
> cmd->local_write_buf = pci_alloc_consistent(...);
> cmd->write_buf = (u8 *)(kmap_atomic(sg->page, KM_IRQ0) + sg->offset);
> 
> memcpy(cmd->local_write_buf, cmd->write_buf, scsibufflen(scsi_cmnd));
> 
> Now I calculate checksums of cmd->write_buf and my local cmd->local_write_buf
> 
> and the checksum fails. Am I doing something wrong here?

Are you only copying one element of the sg list? Are you sure that
there is only one element? If not, you have to use something like
scsi_kmap_atomic_sg and create a copy of each element (maybe use
scsi_for_each_sg).

Or maybe there is another problem... hard to guess from the distance.

Christof
