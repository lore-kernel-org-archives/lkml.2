Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab1LVCwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 21:52:12 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:57607
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753146Ab1LVCwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 21:52:07 -0500
X-SpamScore: -11
X-BigFish: VPS-11(zzbb2dI9371I1432N98dKzz1202hzzz2fh668h839h93fh)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4EF29217.7040408@am.sony.com>
Date: Wed, 21 Dec 2011 18:12:39 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, john stultz <johnstul@us.ibm.com>,
        Brian Swetland <swetland@google.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: RFC: android logger feedback request
References: <4EF264C3.6000104@am.sony.com> <20111221231956.GB23859@suse.de> <4EF27B85.9080801@am.sony.com> <20111222005114.GA22541@suse.de> <4EF288B4.1070601@am.sony.com> <20111222014718.GA13085@suse.de>
In-Reply-To: <20111222014718.GA13085@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2011 05:47 PM, Greg KH wrote:
> On Wed, Dec 21, 2011 at 05:32:36PM -0800, Tim Bird wrote:
>> On 12/21/2011 04:51 PM, Greg KH wrote:
>>> On Wed, Dec 21, 2011 at 04:36:21PM -0800, Tim Bird wrote:
>>>> On 12/21/2011 03:19 PM, Greg KH wrote:
>>
>>> Huh, I'm not talking about syslogd, I'm talking about the syslog(2)
>>> syscall we have.
>>
>> OK - switching gears.  Since the kernel log buffer isn't normally
>> used to store use-space messages, I thought you were referring
>> to syslog(3) and the associated (logger(1) and syslogd(8)).
> 
> The kernel log buffer has been storing userspace messages for a while
> now, look at your boot log on the latest Fedora and openSUSE releases
> (or any other distro using systemd for booting).

Sorry - I don't have a distro that uses systemd.
I'm completely unaware of this use of the kernel log for user-space
message logging.  No wonder Lennart and Kay
are so hot on making a new logging system.  It seems sub-optimal
to me, to intermingle a structured log with a pure-ASCII log.

> Again, please see what we are already doing in the kernel and userspace,
> I think a lot of the above is already implemented.

I don't know what systemd has got going on in user-space.  I'm looking
at a very recent kernel, and I see no support for multiple log channels,
or an optimized open/write path.

Maybe Lennart could save me some time doing this research.

Lennart,

How does current systemd prevent user-space messages from crowding
out kernel messages?  (or vice-versa).  Since you've been doing
a lot of work on logging, do you have any existing metrics for logging
overhead via the kernel log buffer?

> Which brings me back to my original question, what does this code do,
> that is not already present in the kernel, and why is a totally new
> interface being proposed for it?

At the least, it supports multiple log channels.  Quite frankly my mind
has been blown a bit by the suggestion to overload the kernel log buffer
with user-space messages.  I would never have gone that route. But I'll have
to find out more about this systemd thing to answer your question.

Secondly, this is not a particularly new or radical interface. It is new
to legacy Linux, but it's been in the Android Linux kernel for some years
now, and it has worked well.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

