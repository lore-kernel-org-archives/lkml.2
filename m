Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082Ab2EARTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 13:19:06 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38409 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193Ab2EARTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 13:19:04 -0400
Date: Tue, 1 May 2012 18:19:01 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-bluetooth@vger.kernel.org
Subject: Re: [now bisected] Weird bluetooth keyboard regression - just me?
Message-ID: <20120501171901.GA26006@srcf.ucam.org>
References: <20120501073711.028d31d6@lwn.net>
 <20120501110156.2b6e0561@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120501110156.2b6e0561@lwn.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 11:01:56AM -0600, Jonathan Corbet wrote:
> OK, git bisect has rendered its verdict:
> 
> d35e70d50a0641ebc1502fd343bef9b4011ada27 is the first bad commit
> commit d35e70d50a0641ebc1502fd343bef9b4011ada27
> Author: Matthew Garrett <mjg@redhat.com>
> Date:   Fri Feb 3 17:11:55 2012 -0500
> 
>     usb: Use hub port data to determine whether a port is removable
>     
>     Hubs have a flag to indicate whether a given port carries removable devices
>     or not. This is not strictly accurate in that some built-in devices
>     will be flagged as removable, but followup patches will make use of platform
>     data to make this more reliable.
>     
>     Signed-off-by: Matthew Garrett <mjg@redhat.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ...and, indeed, things do seem to break right there.
> 
> I assume there's something funky about the (oldish) USB bluetooth dongle
> that came with my keyboard that interacts badly with this patch.  Matthew,
> is there anything I can do or tell you to help figure this one out?

On its own, this should do precisely nothing. What userspace are you 
running, and what does the removable node in the sysfs entry for the 
dongle's USB device say?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
