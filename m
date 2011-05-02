Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759659Ab1EBOi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 10:38:58 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:16410 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136Ab1EBOiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 10:38:52 -0400
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 3/3] blkdev: honor discard_granularity in blkdev_issue_discard()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1304345841-20063-1-git-send-email-lczerner@redhat.com>
	<1304345841-20063-3-git-send-email-lczerner@redhat.com>
Date: Mon, 02 May 2011 10:38:38 -0400
In-Reply-To: <1304345841-20063-3-git-send-email-lczerner@redhat.com> (Lukas
	Czerner's message of "Mon, 2 May 2011 16:17:21 +0200")
Message-ID: <yq17ha94175.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110013 (No Gnus v0.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DBEC1F9.00B6:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Lukas" == Lukas Czerner <lczerner@redhat.com> writes:

Lukas> As Jeff Moyer pointed out we do not honor discard granularity
Lukas> while submitting REQ_DISCARD bios of size smaller than
Lukas> max_discard_sectors.  That fact might have unwanted consequences
Lukas> of device ignoring the request, or even worse if device firmware
Lukas> is buggy.

We've discussed this before and the consensus was not to do it. The
granularity is a hint, not a hard limit like max_discard_sectors.

We want the reporting to be comprehensive throughout the block layer. If
we start aligning to the granularity at the top we lose information for
stacked devices below with a finer granularity.

So if we were to align to the granularity we'd want to do it at the
bottom of the stack when we issue the command to the device. We've had a
few proposed patches to did that but so far we've only found one device
where it made a difference. And that case didn't justify adding a quirk.

-- 
Martin K. Petersen	Oracle Linux Engineering
