Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab2FLT6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 15:58:47 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2136 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab2FLT6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 15:58:44 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6740"; a="198014015"
Message-ID: <f9b014a8098cce8e4bac8d333d7101c0.squirrel@www.codeaurora.org>
In-Reply-To: <x4962awk4fs.fsf@segfault.boston.devel.redhat.com>
References: <1339491984-8462-1-git-send-email-merez@codeaurora.org>
    <1339491984-8462-2-git-send-email-merez@codeaurora.org>
    <x4962awk4fs.fsf@segfault.boston.devel.redhat.com>
Date: Tue, 12 Jun 2012 12:58:44 -0700 (PDT)
Subject: Re: [PATCH v4 1/1] block: Add test-iosched scheduler
From: merez@codeaurora.org
To: "Jeff Moyer" <jmoyer@redhat.com>
Cc: "Maya Erez" <merez@codeaurora.org>, linux-mmc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        "DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, June 12, 2012 7:09 am, Jeff Moyer wrote:
> Maya Erez <merez@codeaurora.org> writes:
>
>> The test scheduler allows testing a block device by dispatching
>> specific requests according to the test case and declare PASS/FAIL
>> according to the requests completion error code
>
> What sort of tests have you written that make use of this
> infrastructure?
>
>> @@ -1072,8 +1072,6 @@ struct request *blk_get_request(struct
>> request_queue *q, int rw, gfp_t gfp_mask)
>>  {
>>  	struct request *rq;
>>
>> -	BUG_ON(rw != READ && rw != WRITE);
>> -
>
> Please explain this.
get_request and get_request_wait, called by blk_get_request, expects to
get the REQ_SYNC flag in addition to the read/write flag. Moreover, it
uses the REQ_SYNC flag in its algorithm decision making.
However blk_get_request expects to get a Boolean to indicate only
read/write flag and cannot handle the REQ_SYNC flag.
>
> Cheers,
> Jeff
>


-- 
Sent by consultant of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum

