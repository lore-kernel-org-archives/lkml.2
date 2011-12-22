Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab1LVEwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 23:52:32 -0500
Received: from mail.lang.hm ([64.81.33.126]:42354 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097Ab1LVEw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 23:52:28 -0500
Date: Wed, 21 Dec 2011 20:52:14 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: NeilBrown <neilb@suse.de>
cc: Tim Bird <tim.bird@am.sony.com>, Greg KH <gregkh@suse.de>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, john stultz <johnstul@us.ibm.com>,
        Brian Swetland <swetland@google.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: RFC: android logger feedback request
In-Reply-To: <20111222122026.3a0fae36@notabene.brown>
Message-ID: <alpine.DEB.2.02.1112212050060.28597@asgard.lang.hm>
References: <4EF264C3.6000104@am.sony.com> <20111221231956.GB23859@suse.de> <4EF27B85.9080801@am.sony.com> <20111222122026.3a0fae36@notabene.brown>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Dec 2011, NeilBrown wrote:

> On Wed, 21 Dec 2011 16:36:21 -0800 Tim Bird <tim.bird@am.sony.com> wrote:
>
>> On 12/21/2011 03:19 PM, Greg KH wrote:
>>> That all describes the current code, but you haven't described what's
>>> wrong with the existing syslog interface that requires this new driver
>>> to be written.  And why can't the existing interface be fixed to address
>>> these (potential) shortcomings?
>>
>>
>>>> One specific question I have is where is the most appropriate
>>>> place for this code to live, in the kernel source tree?
>>>> Other embedded systems might want to use this system (it
>>>> is simpler than syslog, and superior in some ways), so I don't
>>>> think it should remain in an android-specific directory.
>>>
>>> What way is it superior?
>>
>> Here are some ways that this code is superior to syslog:
>
> It is certainly nice and simple.  It really looks more like a filesystem than
> a char device though...  though they aren't really files so much as lossy
> pipes.  I don't think that's a problem though, lots of things in filesystems
> don't behave exactly like files.
>
> If you created a 'logbuf' filesystem that used libfs to provide a single
> directory in which privileged processes could create files then you wouldn't
> need the kernel to "know" the allowed logs: radio, events, main, system.
> The size could be set by ftruncate() (by privileged used again) rather than
> being hardcoded.
>
> You would defined 'read' and 'write' much like you currently do to create a list of
> datagrams in a circular buffer and replace the ioctls by more standard
> interfaces:
>
> LOGGER_GET_LOG_BUG_SIZE would use 'stat' and the st_blocks field
> LOGGER_GET_LOG_LEN would use 'stat' and the st_size field
> LOGGER_GET_NEXT_ENTRY_LEN could use the FIONREAD ioctl
> LOGGER_FLUSH_LOG could use ftruncate
>
> The result would be much the same amount of code, but an interface which has
> fewer details hard-coded and is generally more versatile and accessible.

That sounds better than what has been done in android, but it is still 
_far_ more limited than doing something that could be replaced by a fairly 
standard syslog daemon.

David Lang
