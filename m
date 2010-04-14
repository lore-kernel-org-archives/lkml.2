Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab0DNMzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 08:55:10 -0400
Received: from adelie.canonical.com ([91.189.90.139]:34836 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab0DNMzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 08:55:08 -0400
Date: Wed, 14 Apr 2010 06:55:02 -0600
From: Alex Chiang <achiang@canonical.com>
To: Greg KH <gregkh@suse.de>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org
Subject: Re: WARNING: at fs/sysfs/dir.c:451 sysfs_add_one: sysfs: cannot
 create duplicate filename '/devices/pci0000:00/0000:00:01.0/slot'
Message-ID: <20100414125502.GA20755@canonical.com>
Mail-Followup-To: Alex Chiang <achiang@canonical.com>,
	Greg KH <gregkh@suse.de>, Eric Paris <eparis@redhat.com>,
	linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org
References: <1271099285.9831.13.camel@localhost>
 <20100414013334.GA24240@canonical.com>
 <20100414051017.GA17378@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100414051017.GA17378@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <gregkh@suse.de>:
> On Tue, Apr 13, 2010 at 07:33:34PM -0600, Alex Chiang wrote:
> > * Eric Paris <eparis@redhat.com>:
> > > 
> > > I get one for 1.0, 1.1, 1.2, 2.0, 3.0, 4.0, 5.0.  Below I only show the
> > > example for 1.0.  Attached should be the full dmesg and config.  Please
> > > let me know about any ideas, tests, questions, or things I can do to
> > > help debug the spew....
> > 
> > These come from a patch I wrote, but unfortunately, I don't have
> > the time or hardware to properly debug them. :(
> 
> It should be simple, for any dynamically allocated sysfs attribute, just
> call sysfs_attribute_initialize() before registering it with the sysfs
> core, and you will get rid of these messages.

Oh hm, I didn't realize that.

> If you have a pointer to your patch, I'll be glad to generate an add-on
> patch to resolve this issue.

In Jesse's linux-next branch:

commit 8b9cd07e02d69bb9e746a57fc987643d648c4b13
Author: Alex Chiang <achiang@hp.com>
Date:   Mon Mar 8 10:24:29 2010 -0700

    PCI: create function symlinks in /sys/bus/pci/slots/N/

Thanks Greg.

/ac

