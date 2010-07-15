Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600Ab0GOPpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 11:45:52 -0400
Received: from mtagate5.de.ibm.com ([195.212.17.165]:50973 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab0GOPpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 11:45:50 -0400
Message-Id: <20100715153410.774329000@de.ibm.com>
User-Agent: quilt/0.47-1
Date: Thu, 15 Jul 2010 17:34:10 +0200
From: Christof Schmitt <christof.schmitt@de.ibm.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 0/1] Apply segment size and segment boundary to integrity data
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While experimenting with the data integrity support in the Linux
kernel, i found that the block layer integrity code can send integrity
data segments for a request that do not adhere to the queue limits. 
The integrity data segment can be larger than queue_max_segment_size
and the segment does not adhere to the queue_segment_boundary.

It appears to me that the right way would be to apply the same
restrictions that are in place for data segments also to integrity
data segments. The patch works for my experiments and applies on top
of the current Linux tree (2.6.35-rc5).

Christof
