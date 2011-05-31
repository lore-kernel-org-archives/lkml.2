Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab1EaO22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 10:28:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:37775 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab1EaO21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 10:28:27 -0400
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Snitzer <snitzer@redhat.com>,
        "msb\@chromium.org" <msb@chromium.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dm-devel\@redhat.com" <dm-devel@redhat.com>
Subject: Re: [PATCH 2/3] block: Move non-rotational flag to queue limits
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <4DDEA689.2090004@fusionio.com>
	<1306464169-4291-1-git-send-email-martin.petersen@oracle.com>
	<1306464169-4291-3-git-send-email-martin.petersen@oracle.com>
	<20110527130248.GA17219@redhat.com>
	<yq1k4d7zk56.fsf@sermon.lab.mkp.net> <4DE4E9A6.8060006@fusionio.com>
Date: Tue, 31 May 2011 10:28:01 -0400
In-Reply-To: <4DE4E9A6.8060006@fusionio.com> (Jens Axboe's message of "Tue, 31
	May 2011 15:14:14 +0200")
Message-ID: <yq1d3izx7v2.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110013 (No Gnus v0.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090209.4DE4FB02.0059:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jens" == Jens Axboe <jaxboe@fusionio.com> writes:

Jens> On 2011-05-31 04:19, Martin K. Petersen wrote:
>> - queue_flag_set_unlocked(QUEUE_FLAG_NONROT, disk->queue);
>> + blk_queue_non_rotational(queue);

Jens> I don't like this part of the change. Before it was immediately
Jens> apparently that we were setting this flag, know you have no idea
Jens> what it does. Please make that blk_queue_set_non_rotational().

I was just trying to mimic the rest of the topology calls.

How about:

  blk_queue_rotational(q, BLK_QUEUE_ROTATIONAL|BLK_QUEUE_NON_ROTATIONAL)

Doing it that way would make the code clearer a few places too, I
think...

-- 
Martin K. Petersen	Oracle Linux Engineering
