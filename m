Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab1HBHYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 03:24:47 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:50003 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743Ab1HBHYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 03:24:42 -0400
X-ASG-Debug-ID: 1312269881-03d6a510a9224340001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E37A638.2020304@fusionio.com>
Date: Tue, 2 Aug 2011 09:24:40 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        "Israel G. Lugo" <israel.lugo@lugosys.com>
Subject: Re: [PATCH] cfq-iosched: Reduce linked group count upon group  destruction
References: <20110801184702.GF3805@redhat.com>
X-ASG-Orig-Subj: Re: [PATCH] cfq-iosched: Reduce linked group count upon group  destruction
In-Reply-To: <20110801184702.GF3805@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1312269881
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.70668
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-01 20:47, Vivek Goyal wrote:
> CFQ keeps track of number of groups which are linked on blkcg->blkg_list.
> This is useful to avoid races between queue exit and cgroup exit code
> paths. So if at the request queue exit time linked group count is not
> zero, that means there are some group out there which is yet to be
> deleted under rcu read period and queue exit code should wait for
> on rcu period.
> 
> In my previous patch I forgot to decrease the number of group count.
> So in current form, we nr_blkcg_linked_grps is always non-zero and
> we will always wait one rcu period (if BLK_CGROUP=y). The side effect
> of this is that it can increase boot time. I am surprised, nobody
> complained so far.

Thanks Vivek, applied.

-- 
Jens Axboe

