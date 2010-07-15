Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358Ab0GOO1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 10:27:00 -0400
Received: from kroah.org ([198.145.64.141]:53454 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933300Ab0GOO07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 10:26:59 -0400
Date: Thu, 15 Jul 2010 07:27:40 -0700
From: Greg KH <greg@kroah.com>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, alsa-devel@alsa-project.org,
        Jens Axboe <axboe@kernel.dk>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Randy Dunlap <randy.dunlap@oracle.com>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Howells <dhowells@redhat.com>, Dave Airlie <airlied@gmail.com>
Subject: Re: [PATCH] driver core: remove CONFIG_SYSFS_DEPRECATED
Message-ID: <20100715142740.GA17005@kroah.com>
References: <20100709185450.GA29473@kroah.com> <20100714163852.b3c09930.akpm@linux-foundation.org> <m1zkxtinlw.fsf@fess.ebiederm.org> <201007150929.03916.konrad@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007150929.03916.konrad@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 09:29:01AM -0400, Konrad Rzeszutek Wilk wrote:
> 
> > > and the box still won't boot.
> >
> > The reason FC6 doesn't boot is there is a userspace tool
> > I believe in the initrd that cares about symlinks when it should
> > not.
> 
> It is not just nash. Also multipathd would fail (as it expects 
> the /sys/scsi_host/..<something> in certain directories), and 'lsscsi'. There 
> might be other tools that depend on libsysfs to be affected by this as well.

No tool should use libsysfs, that code broke a _long_ time ago.  Do you
know of anything using it?

> Oh, and I think 'udev' might have some trouble too - but not 100% certain 
> about that.

Heh, no udev works just fine :)

So basically, it's just the block links that are being affected, so that
might let me narrow down the code covered by the depreciated option.

thanks,

greg k-h
