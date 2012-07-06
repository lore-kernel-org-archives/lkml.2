Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480Ab2GFRzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 13:55:05 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59813 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757859Ab2GFRzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 13:55:03 -0400
X-Sasl-enc: AnbwnPT0TcbRUIzZL1oqd/kubGTRVHaCYf8i9N1NGQHw 1341597302
Date: Fri, 6 Jul 2012 10:55:01 -0700
From: Greg KH <greg@kroah.com>
To: Jukka Ollila <jiiksteri@gmail.com>
Cc: linux-kernel@vger.kernel.org, kay@vrfy.org, jbeulich@novell.com,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Bug 44211 - /proc/kmsg does not (always) block for 1-byte reads
Message-ID: <20120706175501.GA11908@kroah.com>
References: <CAGoecWyMKF4gC7FaoBCrBs+rD=u6oJRHS5Q2qVkkwoZZ1_4RCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGoecWyMKF4gC7FaoBCrBs+rD=u6oJRHS5Q2qVkkwoZZ1_4RCg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 08:45:44PM +0300, Jukka Ollila wrote:
> Hello,
> 
> A few days ago I filed a kernel regression report concerning a change
> in /proc/kmsg behaviour with short reads:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=44211
> 
> The comments suggest that this is probably intentional, but that it
> would be best make sure that the current semantics wrt short reads are
> as intended.
> 
> The problem appears on a Debian (unstable) system that drains
> /proc/kmsg into a separate fifo read by klogd(8):
> 
> /bin/dd bs=1 if=/proc/kmsg  of=/var/run/klogd/kmsg
> 
> With the recent kernel logging changes this /bin/dd exits immediately,
> as 1-byte reads are shorter than any log message could possibly be and
> read() returns 0. No dd feeding the fifo results in no logging and a
> rather unhappy klogd on the reading end of /var/run/klogd/kmsg.
> 
> I suppose a safe solution is to only do reads that are big enough for
> any single kernel message, but this is still a change that affects
> user space being shipped, so some might find it surprising.
> 
> I don't know what other distros do. Is it just Debian being the odd one out?

I think we just fixed this, what kernel version are you seeing this
problem on?

Kay did your other patches that I just accepted resolve this?

thanks,

greg k-h
