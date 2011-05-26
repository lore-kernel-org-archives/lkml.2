Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab1EZBES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 21:04:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64033 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752574Ab1EZBEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 21:04:16 -0400
Message-ID: <4DDDA7F5.9020001@cn.fujitsu.com>
Date: Thu, 26 May 2011 09:08:05 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>, liubo <liubo2009@cn.fujitsu.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 1/2] tracing: add __print_symbolic_u64 to avoid warnings
 on 32bit machine
References: <4D9573DB.4010009@cn.fujitsu.com>	 <1301665762.2160.22.camel@gandalf.stny.rr.com>	 <4D9C2FF6.7090607@cn.fujitsu.com>	 <1303150309.7181.51.camel@gandalf.stny.rr.com>	 <4DACE6E0.7000507@cn.fujitsu.com> <4DBA8C95.4000300@cn.fujitsu.com>	 <1304264124.25414.1079.camel@gandalf.stny.rr.com>	 <4DDDE9E6.7090303@cn.fujitsu.com>	 <1306326464.1465.85.camel@gandalf.stny.rr.com>	 <20110525091252.8899385e.randy.dunlap@oracle.com> <1306342064.1465.101.camel@gandalf.stny.rr.com>
In-Reply-To: <1306342064.1465.101.camel@gandalf.stny.rr.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-26 09:04:10,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-26 09:04:11,
	Serialize complete at 2011-05-26 09:04:11
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 2011-05-25 at 09:12 -0700, Randy Dunlap wrote:
>>  
>>> But what I sent out previously is not going into 2.6.40 anyway. Ingo
>>> feels that it's too late in the merge window to pull those changes and
>>> wants to wait till the next merge window. Since there's some fixes in
>>> that pull request, I'll need to cherry pick them out and rebase the rest
>>> for the next window.
>>
>> Sorry to hear all of that.  This fix is needed in mainline.
>>
> 
> Hmm, it is a warning fix. Well, I could add this to the cherry picking
> I'm doing (fixes only).
> 
> I'm currently making a fix for a triple fault in the function tracer
> caused by PROVE_RCU causing recursive tracing. When I get this fixed,
> I'll be pushing the "fixes" next.
> 

Actually it's more than a compile warning fix.

After a variable is cast from u64 to u32 and passed to __print_symbolic(),
we'll see incorrect result in the trace output.
