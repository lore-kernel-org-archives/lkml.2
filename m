Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594Ab1BKBY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 20:24:59 -0500
Received: from kroah.org ([198.145.64.141]:53451 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268Ab1BKBY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 20:24:58 -0500
Date: Thu, 10 Feb 2011 17:25:52 -0800
From: Greg KH <greg@kroah.com>
To: Mike Waychison <mikew@google.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Tim Hockin <thockin@google.com>,
        Robert Lippert <rlippert@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: SMBIOS / DMI Event Logs in Linux?
Message-ID: <20110211012552.GA28995@kroah.com>
References: <4D547236.6080702@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D547236.6080702@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 03:18:14PM -0800, Mike Waychison wrote:
> Hey guys,
> 
> I need some guidance. Do either of you know of any attempts to have
> the kernel decode and display/interact with DMI type 15: System
> Event Log?

I don't have any experience in this area, but I do have one comment on
your proposal below:

> The event log I'm dealing with while cleaning up the "gsmi" driver
> interacts with a log that is modeled after the System Event Log.
> I'm wondering if there is any precedent for a clean way to expose
> the event log, I'd like to use it (replacing the ioctls from my
> earlier patch series send-out).
> 
> FYI, we use OEM specific headers and descriptors, which probably
> doesn't help.
> 
> Do most folks that need access to this data rely on /dev/mem and
> dmidecode?  I'd like to avoid going that route if possible.
> 
> Lacking any better ideas though, I was thinking of something along
> the lines of the following:
> 
> 
> $ cat /sys/firmware/gsmi/eventlog
> <offset> <boot number> <recorded time> <quoted reason> <optional data>
> ...
> 
> with a single event log entry per line.
>   <offset> would be the record number,
>   <boot number> is the recorded boot number
>   <recorded time> comes from each record,
>   <quoted reason> is the English translation of Event Log Types from
> the DMTF standard + vendor extended types we use.
>   <optional data> is space separated values associated with <quoted reason>

Ick, no, remember, sysfs is "one value per file".  doing even a single
line like you describe here isn't ok, not to mention a huge buffer of
these lines.

And no, a "binary" sysfs file is not ok either.

Now your idea for such a log file is fine, I'm not saying that's not ok,
or acceptable, just don't put it in sysfs, sorry.  Try using the ring
buffer framework from the tracing code perhaps?

Or use debugfs?  Or make a 'firmwarefs'?  I can easily knock that
together if you need it.

thanks,

greg k-h
