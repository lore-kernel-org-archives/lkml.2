Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab0FDCX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 22:23:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51967 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932071Ab0FDCX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 22:23:58 -0400
Message-ID: <4C086452.1070005@cn.fujitsu.com>
Date: Fri, 04 Jun 2010 10:26:26 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>,
       James Bottomley <James.Bottomley@suse.de>,
       Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH][GIT PULL][v2.6.35] tracing/events: Convert format output
 to seq_file
References: <1275594103.15884.35.camel@gandalf.stny.rr.com>	 <4C0860DE.5020609@cn.fujitsu.com> <1275617591.15884.67.camel@gandalf.stny.rr.com>
In-Reply-To: <1275617591.15884.67.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Fri, 2010-06-04 at 10:11 +0800, Li Zefan wrote:
>>> +static void *f_start(struct seq_file *m, loff_t *pos)
>>> +{
>>> +	loff_t l = 1;
>>> +	void *p;
>>> +
>>> +	/* Start by showing the header */
>>> +	if (!*pos) {
>>> +		(*pos)++;
>> We shoudn't increment *pos in start() handler. It's a common mistake when
>> using seqfile. 
> 
> And a common mistake I do :-p
> 
> I'll rebase it with the fix.
> 
>> What we need to do in start() is move the pointer to postion *pos.
> 
> So the rest is OK then? All that is needed is the removal of *pos++ ?
> 

I think you should also change "loff_t l = 1" to "loff_t l = 0". :)

Otherwise:

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
