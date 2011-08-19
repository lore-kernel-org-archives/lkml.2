Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab1HSGeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 02:34:06 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:56657 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378Ab1HSGeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 02:34:02 -0400
X-ASG-Debug-ID: 1313735641-03d6a510a82f4580001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E4E03D5.40404@fusionio.com>
Date: Fri, 19 Aug 2011 08:33:57 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: "teravest@google.com" <teravest@google.com>,
        lkml <linux-kernel@vger.kernel.org>, "Shi, Alex" <alex.shi@intel.com>
Subject: Re: cfq-iosched: a regression
References: <1313462826.27321.22.camel@sli10-conroe>
X-ASG-Orig-Subj: Re: cfq-iosched: a regression
In-Reply-To: <1313462826.27321.22.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1313735641
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.72191
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-16 04:47, Shaohua Li wrote:
> We have a kernel build regression since 3.1-rc1, which is about 10%
> regression. The kernel source is in an ext3 filesystem.
> Alex Shi bisect it to commit:
> commit a07405b7802691d29ab3b23bdc76ee6d006aad0b
> Author: Justin TerAvest <teravest@google.com>
> Date:   Sun Jul 10 22:09:19 2011 +0200
> 
>     cfq: Remove special treatment for metadata rqs.
> 
> Apparently this is caused by lack metadata preemption, where ext3/ext4
> do use READ_META. I didn't see a way to fix the issue, so suggest
> reverting the patch.
> 
> Reported-by: Alex Shi<alex.shi@intel.com>
> Reported-by: Shaohua Li<shaohua.li@intel.com>

I had a gut feeling on that meta data, it's hard to know exactly where
it helps at this point. I'll revert the commit and then we can diagnose
this on the side.

-- 
Jens Axboe

