Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab1LVAma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 19:42:30 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:17923
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752562Ab1LVAm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 19:42:27 -0500
X-SpamScore: -21
X-BigFish: VPS-21(zzbb2dI9371I936eK1432N98dK14ffOzz1202hzz8275dhz2fh668h839h93fh)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4EF27CDD.9060801@am.sony.com>
Date: Wed, 21 Dec 2011 16:42:05 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Greg KH <gregkh@suse.de>, linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Brian Swetland <swetland@google.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: RFC: android logger feedback request
References: <4EF264C3.6000104@am.sony.com> <20111221231956.GB23859@suse.de> <1324513091.30527.139.camel@work-vm>
In-Reply-To: <1324513091.30527.139.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2011 04:18 PM, john stultz wrote:
> On Wed, 2011-12-21 at 15:19 -0800, Greg KH wrote:
>> On Wed, Dec 21, 2011 at 02:59:15PM -0800, Tim Bird wrote:
>>> Hi all,
>>>
>>> I'm looking for feedback on the Android logger code, to see what
>>> it would take to make this code acceptable for inclusion in
>>> the mainline kernel.
>>>
>>> Information about the features of Android logging system
>>> can be found at: http://elinux.org/Android_Logging_System
>>>
>>> This system creates a new system-wide logging service, in
>>> the kernel, for user-space message.  It is more comparable
>>> to syslog than to the kernel log buffer, as it holds only
>>> user-space messages.  It is optimized for write
>>> performance, since most of the time the log is written to
>>> and never read.  It creates multiple log channels, to prevent
>>> an abundance of log messages in one channel from overwriting
>>> messages in another channel.  The log channels have sizes
>>> fixed at kernel compile-time.
>>>
>>> Log messages are stored in very simple in-kernel buffers, that
>>> overflow old messages upon wrapping.  A fixed set of attributes
>>> (pid, tid, timestamp and message), is kept for each message.
>>> By convention, Android puts a message priority and context tag
>>> into each message.
>>>
>>> In Android, this system uses a fixed set of device nodes with
>>> well-known names: /dev/log/main, /dev/log/events, /dev/log/radio
>>> and /dev/log/system.
>>>
>>> Operations on the log are done via a character device, using
>>> standard file operations and some ioctls.
>>>
>>> The code for this is below (I've moved it from linux-next
>>> drivers/staging/android for my own testing).
>>>
>>> Please let me know what issues you see with this code.
>>
>> That all describes the current code, but you haven't described what's
>> wrong with the existing syslog interface that requires this new driver
>> to be written.  And why can't the existing interface be fixed to address
>> these (potential) shortcomings?
>>
>>> One specific question I have is where is the most appropriate
>>> place for this code to live, in the kernel source tree?
>>> Other embedded systems might want to use this system (it
>>> is simpler than syslog, and superior in some ways), so I don't
>>> think it should remain in an android-specific directory.
>>
>> What way is it superior?  Again, why not extend syslog?  Why not "fix"
>> syslog if this really is a superior thing?  How does this tie into Kay
>> and Lennard's proposal for work in this area?
> 
> There is also some overlap functionality wise with pstore as well, as I
> believe the logger is used as a known location in memory where messages
> can be fetched from after a kernel panic or crash.

I don't know if that's true or not.  I think you may be thinking
of Android's RAM console feature.  If there's a way to save
application messages over a reboot using the logger buffers, I'm
unfamiliar with it.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

