Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab2CMRFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 13:05:17 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:46550 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546Ab2CMRFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 13:05:14 -0400
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Shaohua Li <shli@fusionio.com>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, neilb@suse.de, axboe@kernel.dk,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch 6/7] blk: add plug for blkdev_issue_discard
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20120312030412.375458948@fusionio.com>
	<20120312031305.946211513@fusionio.com>
	<20120313155120.GG29169@redhat.com>
Date: Tue, 13 Mar 2012 13:04:58 -0400
In-Reply-To: <20120313155120.GG29169@redhat.com> (Vivek Goyal's message of
	"Tue, 13 Mar 2012 11:51:20 -0400")
Message-ID: <yq1vcm8a0ud.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110017 (No Gnus v0.17) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090207.4F5F7E3F.008E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Vivek" == Vivek Goyal <vgoyal@redhat.com> writes:

Vivek> On Mon, Mar 12, 2012 at 11:04:18AM +0800, Shaohua Li wrote:
>> In raid 0 case, a big discard request is divided into several small
>> requests in chunk_size unit. Such requests can be merged in low layer
>> if we have correct plug added. This should improve the performance a
>> little bit.

Vivek> Martin posted a patch to remove the support for allowing merging
Vivek> of discard requests. But this seems to be a reasonable use case
Vivek> for allowing mering discard requests. CCing Martin.

Merging discard requests is hard given how we need to prepare the
command payload at the bottom of the stack. The current upstream merge
code pretends to be working but it actually doesn't. That's why I want
it dead and buried.

I have some changes pending (that I need for the REQ_COPY support) that
will make merging of non-rw requests easier to deal with. But that's a
kernel release cycle away...

-- 
Martin K. Petersen	Oracle Linux Engineering
