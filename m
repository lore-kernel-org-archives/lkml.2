Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab1CIKw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 05:52:58 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:36249 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098Ab1CIKw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 05:52:57 -0500
X-ASG-Debug-ID: 1299667975-01de284cf82f810001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D775C03.9090600@fusionio.com>
Date: Wed, 9 Mar 2011 11:52:51 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: "hch@infradead.org" <hch@infradead.org>
CC: Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/10] fs: make generic file read/write functions plug
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com> <1295659049-2688-8-git-send-email-jaxboe@fusionio.com> <20110304040907.GB32404@redhat.com> <4D70E78D.9000402@fusionio.com> <20110304132551.GA2407@infradead.org> <4D762330.8000003@fusionio.com> <20110309103828.GA26181@infradead.org>
X-ASG-Orig-Subj: Re: [PATCH 07/10] fs: make generic file read/write functions plug
In-Reply-To: <20110309103828.GA26181@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1299667975
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.60
X-Barracuda-Spam-Status: No, SCORE=0.60 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=MARKETING_SUBJECT
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.57495
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.60 MARKETING_SUBJECT      Subject contains popular marketing words
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-09 11:38, hch@infradead.org wrote:
> On Tue, Mar 08, 2011 at 01:38:08PM +0100, Jens Axboe wrote:
>> -#define DP_UNPLUG             8 /* equals REQ_UNPLUG  */
>> +#define DP_UNPLUG             8 /* not used anymore   */
> 
> The way this is used might need some more review.  It seems like DRBD is
> trying to propagate unplug requests over the wire, which is
> functionality we lose now.

But that use case is pretty questionable. The receiving end should just
do its own plugging, if it's beneficial.

>> + * The various wait functions, such as wait_on_writeback_range() will
>> + * ultimately call sync_page() which will ultimately call
>> + * blk_run_backing_dev(), which will end up unplugging the device queue.
> 
> This comment describes code that doesn't exist anymore on your branch.

Thanks, I'll kill those.


-- 
Jens Axboe

