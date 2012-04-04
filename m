Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab2DDVFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 17:05:11 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37678 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751498Ab2DDVFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 17:05:09 -0400
X-Sasl-enc: Js1xUpEi2KMa+4llNzYpHzoCZ+KdUK/9JvW5ZxuzqOkz 1333573508
Date: Wed, 4 Apr 2012 14:05:07 -0700
From: Greg Kroah-Hartmann <greg@kroah.com>
To: Kay Sievers <kay@vrfy.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk: support structured and multi-facility log
 messages
Message-ID: <20120404210507.GA1716@kroah.com>
References: <1333569554.864.3.camel@mop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333569554.864.3.camel@mop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2012 at 09:59:14PM +0200, Kay Sievers wrote:
> - Full-featured syslog facility value support. Different facilities
>   can tag their messages. All userspace-injected messages enforce a
>   facility value > 0 now, to be able to reliably distinguish them from
>   the kernel-generated messages. Independent subsystems like a
>   baseband processor running its own firmware, or a kernel-related
>   userspace process can use their own unique facility values. Multiple
>   independent log streams can co-exist that way in the same
>   buffer. All share the same global sequence number counter to ensure
>   proper ordering (and interleaving) and to allow the consumers of the
>   log to reliably correlate the events from different facilities.
> 
> - Output of dev_printk() is reliably machine-readable now. In addition
>   to the printed plain text message, it creates a log dictionary with the
>   following properties:
>     SUBSYSTEM=     - the driver-core subsytem name
>     DEVICE=
>       b12:8        - block dev_t
>       c127:3       - char dev_t
>       n8           - netdev ifindex
>       +sound:card0 - subsystem:devname

I like this a lot, thanks for doing this.

Is there somewhere in Documentation/ABI that we can document this
interface so that people know what it is, what is defined, and how to
use it?

> - Support for multiple concurrent readers of /dev/kmsg, with read(),
>   seek(), poll() support. Output of message sequence numbers, to allow
>   userspace log consumers to reliably reconnect and reconstruct their
>   state at any given time. After open("/dev/kmsg"), read() always
>   returns *all* buffered records. If only future messages should be
>   read, SEEK_END can be used. In case records get overwritten while
>   /dev/kmsg is held open, or records get faster overwritten than they
>   are read, the next read() will return -EPIPE and the current reading
>   position gets updated to the next available record. The passed
>   sequence numbers allow the log consumer to calculate the amount of
>   lost messages.

I just noticed that 'tail -f' doesn't seem to work on /dev/kmsg, should
it?  Or does it need to do something else to get "just the new ones"?

thanks,

greg k-h
