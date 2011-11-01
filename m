Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab1KABKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 21:10:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63745 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750798Ab1KABKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 21:10:33 -0400
Message-ID: <4EAF476C.2060900@cn.fujitsu.com>
Date: Tue, 01 Nov 2011 09:12:12 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ilya Dryomov <idryomov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing: fix event_subsystem ref counting
References: <1320052062-7846-1-git-send-email-idryomov@gmail.com> <1320077699.4793.5.camel@gandalf.stny.rr.com>
In-Reply-To: <1320077699.4793.5.camel@gandalf.stny.rr.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-01 09:10:37,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-01 09:10:38,
	Serialize complete at 2011-11-01 09:10:38
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Mon, 2011-10-31 at 11:07 +0200, Ilya Dryomov wrote:
>> Fix a bug introduced by e9dbfae5, which prevents event_subsystem from
>> ever being released.
>>
>> Ref_count was added to keep track of subsystem users, not for counting
>> events.  Subsystem is created with ref_count = 1, so there is no need to
>> increment it for every event, we have nr_events for that.  Fix this by
>> touching ref_count only when we actually have a new user -
>> subsystem_open().
> 
> Good catch, I'll pull this in.
> 

I made a different fix last week:

http://marc.info/?l=linux-kernel&m=131978486911595&w=2

but I guess Ilya's version is a bit better.
