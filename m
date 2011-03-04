Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759158Ab1CDCFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 21:05:15 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55626 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751283Ab1CDCFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 21:05:13 -0500
Message-ID: <4D70495D.8010403@cn.fujitsu.com>
Date: Fri, 04 Mar 2011 10:07:25 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] lock issue in perf cgroup with jump label enabled
References: <4D6F51C9.3020800@cn.fujitsu.com>	 <1299146787.1310.41.camel@laptop> <1299161840.1310.54.camel@laptop>
In-Reply-To: <1299161840.1310.54.camel@laptop>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-04 10:04:02,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-04 10:04:03,
	Serialize complete at 2011-03-04 10:04:03
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2011-03-03 at 11:06 +0100, Peter Zijlstra wrote:
>>
>>> list_add_event() is called with spin lock ctl->lock held,  while
>>> jump_label_inc() will acquire jump_label_mutex..
>>
> 
> The below seems to actually work, I totally overlooked the dec case
> earlier.
> 

Yes, it works. Thanks!
