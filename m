Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab0DNFOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 01:14:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:33526 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097Ab0DNFOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 01:14:14 -0400
Date: Tue, 13 Apr 2010 22:10:17 -0700
From: Greg KH <gregkh@suse.de>
To: Alex Chiang <achiang@canonical.com>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org
Subject: Re: WARNING: at fs/sysfs/dir.c:451 sysfs_add_one: sysfs: cannot
	create duplicate filename '/devices/pci0000:00/0000:00:01.0/slot'
Message-ID: <20100414051017.GA17378@suse.de>
References: <1271099285.9831.13.camel@localhost> <20100414013334.GA24240@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100414013334.GA24240@canonical.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 07:33:34PM -0600, Alex Chiang wrote:
> * Eric Paris <eparis@redhat.com>:
> > 
> > I get one for 1.0, 1.1, 1.2, 2.0, 3.0, 4.0, 5.0.  Below I only show the
> > example for 1.0.  Attached should be the full dmesg and config.  Please
> > let me know about any ideas, tests, questions, or things I can do to
> > help debug the spew....
> 
> These come from a patch I wrote, but unfortunately, I don't have
> the time or hardware to properly debug them. :(

It should be simple, for any dynamically allocated sysfs attribute, just
call sysfs_attribute_initialize() before registering it with the sysfs
core, and you will get rid of these messages.

If you have a pointer to your patch, I'll be glad to generate an add-on
patch to resolve this issue.

thanks,

greg k-h
