Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab1LVFOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 00:14:44 -0500
Received: from mail.lang.hm ([64.81.33.126]:59989 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892Ab1LVFOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 00:14:40 -0500
Date: Wed, 21 Dec 2011 21:14:26 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Brian Swetland <swetland@google.com>
cc: NeilBrown <neilb@suse.de>, Tim Bird <tim.bird@am.sony.com>,
        Greg KH <gregkh@suse.de>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, john stultz <johnstul@us.ibm.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: RFC: android logger feedback request
In-Reply-To: <CANqkERBPayBWjFp2nCDZA2CByJQwHMoeXe62ZutZr8QkWtcTLg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1112212107550.28597@asgard.lang.hm>
References: <4EF264C3.6000104@am.sony.com> <20111221231956.GB23859@suse.de> <4EF27B85.9080801@am.sony.com> <20111222122026.3a0fae36@notabene.brown> <alpine.DEB.2.02.1112212050060.28597@asgard.lang.hm>
 <CANqkERBPayBWjFp2nCDZA2CByJQwHMoeXe62ZutZr8QkWtcTLg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Dec 2011, Brian Swetland wrote:

>>> The result would be much the same amount of code, but an interface which
>>> has
>>> fewer details hard-coded and is generally more versatile and accessible.
>>
>> That sounds better than what has been done in android, but it is still _far_
>> more limited than doing something that could be replaced by a fairly
>> standard syslog daemon.
>
> We're really not interested in adding another daemon to the platform
> -- the logging system we have has served us well, is integrated with
> our existing development tools, and we're definitely interested in
> improving it, but throwing it out and replacing it with a userspace
> solution is not interesting to us right now.

Think very hard before you reject any possibility of doing this in 
userspace, especially with all the things that you are talking about doing 
with logging in the future. I really don't think aht a lot of your 
long-0term plans for logging are going to sit well with the kernel 
developers, and if your justification is "you don't want to change your 
build process", I really doubt that you will get this upstream.

It should be possible to do this without having to change the tools 
writing the logs, any change in logging will change what it takes to read 
the logs.

I am not saying that you need to have a logging daemon as heavyweight as 
syslog-ng or rsyslog for the low-end phones, but I do think that as 
android moves up the stack a bit into talets and netbooks (especially in 
applications where it will have wifi connectivity almost all the time) 
having the capability to move to a full-blown syslog daemon will make a 
huge amount of sense, so you should look at how big a minimalist daemon 
would be, and what sort of performance it would have.

David Lang
