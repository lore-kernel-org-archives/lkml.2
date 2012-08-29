Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab2H2QTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 12:19:55 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:39549 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab2H2QTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 12:19:53 -0400
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: Fix bad range check in bio_sector_offset
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <yq1a9xesxll.fsf@sermon.lab.mkp.net>
	<x49wr0hn65c.fsf@segfault.boston.devel.redhat.com>
Date: Wed, 29 Aug 2012 12:19:45 -0400
In-Reply-To: <x49wr0hn65c.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's
	message of "Wed, 29 Aug 2012 10:07:27 -0400")
Message-ID: <yq1fw75pt5q.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jeff" == Jeff Moyer <jmoyer@redhat.com> writes:

>> DM would occasionally end up splitting data integrity-enabled
>> requests incorrectly. The culprit was a bad range check in
>> bio_sector_offset.

Jeff> The patch looks ok to me, but what is the user visible behavior
Jeff> when this happens?

We'd occasionally end up mapping a bad integrity scatterlist and the HBA
would abort the I/O with a protection information error.

-- 
Martin K. Petersen	Oracle Linux Engineering
