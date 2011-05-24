Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab1EXHzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 03:55:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51778 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753576Ab1EXHzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 03:55:10 -0400
Message-ID: <4DDB64C1.90709@cn.fujitsu.com>
Date: Tue, 24 May 2011 15:56:49 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Hu Tao <hutao@cn.fujitsu.com>
Subject: Re: Test for CFS Bandwidth Control V6
References: <20110323030326.789836913@google.com> <4DD5CE05.3030500@cn.fujitsu.com> <4DDB0199.6030805@jp.fujitsu.com>
In-Reply-To: <4DDB0199.6030805@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-24 15:55:09,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-24 15:55:11,
	Serialize complete at 2011-05-24 15:55:11
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2011 08:53 AM, Hidetoshi Seto wrote:

> I confirmed that running your test cause hung-up on my box.
> And after some investigation, I found that this is an infinite loop
> in migrate_task() due to miscalculation of rq->nr_running; when a
> task is queued to throttled entity the nr_running is incremented at
> the queuing and also the unthrottling.
> 
> I made a fix for this bug and it seems works well for me.
> Could you try this patch and give us your feedback, Xiao?
> 

Thanks for your nice fix, Seto! Everything goes well now!

Tested-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
