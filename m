Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab1IIM0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 08:26:53 -0400
Received: from smarthost1.greenhost.nl ([195.190.28.78]:44150 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab1IIM0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 08:26:52 -0400
Message-ID: <93a9bd6624aa6a991d688bfaba766a91.squirrel@webmail.greenhost.nl>
In-Reply-To: <201109090754.50272.vda.linux@googlemail.com>
References: <1315500802.18043.45.camel@dhcp-25-63.brq.redhat.com>
    <20110909001853.GA29319@htj.dyndns.org>
    <201109090754.50272.vda.linux@googlemail.com>
Date: Fri, 9 Sep 2011 14:26:48 +0200
Subject: Re: Why I want PTRACE_O_TRACESTOP option
From: "Indan Zupancic" <indan@nul.nu>
To: "Denys Vlasenko" <vda.linux@googlemail.com>
Cc: "Tejun Heo" <tj@kernel.org>, "Denys Vlasenko" <dvlasenk@redhat.com>,
        "Oleg Nesterov" <oleg@redhat.com>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: c09395f469c52153b963e4ff2d10f427
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, September 9, 2011 07:54, Denys Vlasenko wrote:
> On Friday 09 September 2011 02:18, Tejun Heo wrote:
>> Hello, Denys.
>>
>> On Thu, Sep 08, 2011 at 06:50:01PM +0200, Denys Vlasenko wrote:
>> > Consider what will happen when a next ptrace fix will require
>> > a way to change ptrace API at runtime. A new option will likely
>> > be introduced, say, PTRACE_O_TRACEPONY, with next available
>> > bit position 7, and perhaps some new event will be generated,
>> > PTRACE_EVENT_PONY, with value.... yes, it can't be 7,
>> > PTRACE_EVENT_STOP took it. So it will probably be 8.
>>
>> Then, just give it the next matching number.
>
> My point is that previously, ptrace behavior was modified by setting
> options. Why don't we use this mechanism? Why we invent a different
> wheel? Ptrace is ugly as-is, why complicate it even further?
>
> The argument was that SETOPTIONS wasn't suitable for modifying
> attach behavior, but this is fixed by "set options on SEIZE"
> patch. I don't see why we can't use options mechanist to affect
> group-stop behavior now.

I totally agree with Denys here.

It is very useful to set options atomically at SEIZE time. Having
SEIZE set some hidden option implicitly only makes things more
confusing and harder to explain what SEIZE does. Please apply Denys'
SEIZE API improvements.

Another important reason to make PTRACE_O_TRACESTOP an option is
because not everyone uses SEIZE: Users using PTRACE_TRACEME can't
set this option at all. For those PTRACE_O_TRACESTOP is needed.
Using PTRACE_TRACEME is the common case for both strace and gdb.

That is an indication that mixing up the setting of an option with
a specific attach request is wrong.

Greetings,

Indan


P.S. It seems messages to tj@kernel.org have trouble getting through,
I hope they arrive eventually.


