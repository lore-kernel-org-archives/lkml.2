Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab0IINYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 09:24:30 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:30196 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098Ab0IINY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 09:24:28 -0400
To: Anil kumar <anils_r@yahoo.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: scsi_cmnd data_buffer checksum
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <215508.92384.qm@web32402.mail.mud.yahoo.com>
Date: Thu, 09 Sep 2010 09:23:24 -0400
In-Reply-To: <215508.92384.qm@web32402.mail.mud.yahoo.com> (Anil kumar's
	message of "Thu, 9 Sep 2010 02:09:28 -0700 (PDT)")
Message-ID: <yq1fwxjt5ir.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Anil" == Anil kumar <anils_r@yahoo.com> writes:

Anil> cmd-> write_buf = (u8 *)(kmap_atomic(sg->page, KM_IRQ0) + sg->offset);
Anil> memcpy(cmd->local_write_buf, cmd->write_buf, cmd->scsibufflen(scsi_cmnd));

You need to walk the scatterlist.  You can't assume that the pages are
contiguous in memory.

But why are you doing this checksumming stuff manually when the existing
DIX/DIF code can do it for you?

-- 
Martin K. Petersen	Oracle Linux Engineering
