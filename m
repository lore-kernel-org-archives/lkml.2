Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab1LUXUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 18:20:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46569 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab1LUXUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 18:20:06 -0500
Date: Wed, 21 Dec 2011 15:19:56 -0800
From: Greg KH <gregkh@suse.de>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, john stultz <johnstul@us.ibm.com>,
        Brian Swetland <swetland@google.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: RFC: android logger feedback request
Message-ID: <20111221231956.GB23859@suse.de>
References: <4EF264C3.6000104@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF264C3.6000104@am.sony.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 02:59:15PM -0800, Tim Bird wrote:
> Hi all,
> 
> I'm looking for feedback on the Android logger code, to see what
> it would take to make this code acceptable for inclusion in
> the mainline kernel.
> 
> Information about the features of Android logging system
> can be found at: http://elinux.org/Android_Logging_System
> 
> This system creates a new system-wide logging service, in
> the kernel, for user-space message.  It is more comparable
> to syslog than to the kernel log buffer, as it holds only
> user-space messages.  It is optimized for write
> performance, since most of the time the log is written to
> and never read.  It creates multiple log channels, to prevent
> an abundance of log messages in one channel from overwriting
> messages in another channel.  The log channels have sizes
> fixed at kernel compile-time.
> 
> Log messages are stored in very simple in-kernel buffers, that
> overflow old messages upon wrapping.  A fixed set of attributes
> (pid, tid, timestamp and message), is kept for each message.
> By convention, Android puts a message priority and context tag
> into each message.
> 
> In Android, this system uses a fixed set of device nodes with
> well-known names: /dev/log/main, /dev/log/events, /dev/log/radio
> and /dev/log/system.
> 
> Operations on the log are done via a character device, using
> standard file operations and some ioctls.
> 
> The code for this is below (I've moved it from linux-next
> drivers/staging/android for my own testing).
> 
> Please let me know what issues you see with this code.

That all describes the current code, but you haven't described what's
wrong with the existing syslog interface that requires this new driver
to be written.  And why can't the existing interface be fixed to address
these (potential) shortcomings?

> One specific question I have is where is the most appropriate
> place for this code to live, in the kernel source tree?
> Other embedded systems might want to use this system (it
> is simpler than syslog, and superior in some ways), so I don't
> think it should remain in an android-specific directory.

What way is it superior?  Again, why not extend syslog?  Why not "fix"
syslog if this really is a superior thing?  How does this tie into Kay
and Lennard's proposal for work in this area?

thanks,

greg k-h
