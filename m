Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab2BHQoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 11:44:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755635Ab2BHQoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 11:44:11 -0500
Date: Wed, 8 Feb 2012 11:44:09 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, seiji.aguchi@hds.com, dzickus@redhat.com
Subject: Re: [PATCH] kmsg_dump: Don't run on non-error paths by default
Message-ID: <20120208164409.GB19323@redhat.com>
References: <1328717646-17121-1-git-send-email-mjg@redhat.com>
 <20120208163007.GA19323@redhat.com>
 <20120208163720.GB3322@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120208163720.GB3322@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 04:37:20PM +0000, Matthew Garrett wrote:
> On Wed, Feb 08, 2012 at 11:30:07AM -0500, Vivek Goyal wrote:
> 
> > > +	if (reason > KMSG_DUMP_PANIC && !always_kmsg_dump)
> > > +		return;
> > 
> > Did you mean reason > KMSG_DUMP_OOPS to enable oops logging by default?
> 
> Bah. Yes, I think my test system was set to panic on oops so I didn't 
> catch that.
> 
> > Given the fact that not everybody likes kmsg_dump() and it is not known
> > how stable it with various backends, will it make sense to keep it disabled
> > by default and provide a knob to enable it (instead of always_kmsg_dump).
> 
> I think logging panics and oopses by default is a useful feature. It may 
> be desirable to have a mechanism to disable it if some other way of 
> handling that (serial console, kdump) is available.

Ok, keeping it enabled by default for panic and oops might be better.

Thinking more about it. This problem sounds similar to different kernel log
levels where we enable desired level of logging. May be instead of having
a boolean knob, we can have multivalue knob.

Thanks
Vivek
