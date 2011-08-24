Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab1HXN7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 09:59:13 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:38250 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129Ab1HXN7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 09:59:10 -0400
X-ASG-Debug-ID: 1314194349-03d6a50f46302c0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E5503AA.3010908@fusionio.com>
Date: Wed, 24 Aug 2011 15:59:06 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2]block: change force plug flush call order
References: <1314176129.29510.34.camel@sli10-conroe>
X-ASG-Orig-Subj: Re: [patch 1/2]block: change force plug flush call order
In-Reply-To: <1314176129.29510.34.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1314194349
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.72697
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-24 10:55, Shaohua Li wrote:
> Do blk_flush_plug_list() first and then add new request at the tail. New
> request can't be merged to existing requests, but later new requests might
> be merged with this new one. If blk_flush_plug_list() is done later, the
> merge doesn't happen.
> Believe it or not, this fixes a 10% regression running sysbench workload.

Heh, funky. But conceptually it makes sense to flush first, since we
already know that this request isn't mergeable already. Applied.

-- 
Jens Axboe

