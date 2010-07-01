Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759899Ab0GAWoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:44:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33819 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755483Ab0GAWof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 18:44:35 -0400
Date: Thu, 1 Jul 2010 15:43:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Torokhov <dtor@vmware.com>
Cc: Bruno =?ISO-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
       Alexander Clouter <alex@digriz.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] VMware balloon: force compiling as a module
Message-Id: <20100701154347.e3c1094b.akpm@linux-foundation.org>
In-Reply-To: <201007011531.52291.dtor@vmware.com>
References: <20100628230035.GA18971@dtor-ws.eng.vmware.com>
	<201006290940.38821.dtor@vmware.com>
	<20100701151835.33874101.akpm@linux-foundation.org>
	<201007011531.52291.dtor@vmware.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Jul 2010 15:31:50 -0700
Dmitry Torokhov <dtor@vmware.com> wrote:

> On Thursday, July 01, 2010 03:18:35 pm Andrew Morton wrote:
> > On Tue, 29 Jun 2010 09:40:38 -0700
> > 
> > Dmitry Torokhov <dtor@vmware.com> wrote:
> > > On Tuesday, June 29, 2010 09:28:59 am Bruno Pr__mont wrote:
> > > > On Tue, 29 June 2010 Alexander Clouter <alex@digriz.org.uk> wrote:
> > > > > Dmitry Torokhov <dtor@vmware.com> wrote:
> > > > > > VMware Tools installer requires the upstream driver to be compiled
> > > > > > as a module in order to detect its presence and avoid installing
> > > > > > our own version on top of it. To avoid surprises with 2 versions
> > > > > > of the driver being installed and fighting with each other, let's
> > > > > > force the driver to be compiled as a module unless user selects
> > > > > > CONFIG_EMBEDDED.
> > > > > 
> > > > > *barf*
> > > > > 
> > > > > This surely is a problem in the installer and not the kernel?  Can
> > > > > you not nosey around in /sys/class/misc or where-ever your driver
> > > > > appears? If it does not, then I would probably suggest a patch to
> > > > > your balloon driver that dumps some details in there, including
> > > > > module version information.
> > > > > 
> > > > > Eugh.
> > > > 
> > > > In addition, the installer may check under /sys/module/ for it (as for
> > > > any/most code that can be built as a module), even for built-in code.
> > > > (if balloon driver does not show up there when built-in it would be
> > > > better to get it to show up there)
> > > 
> > > When driver is built-in the only thing exported in /sys/module/XXX are
> > > module parameters.
> > > 
> > > We also need to handle scenario when module is not loaded into the
> > > kernel.
> > 
> > - check for the /sys/module directory.
> 
> Empty.

But the presence of the empty /sys/module/vmware_balloon tells you that
the driver is loaded?

Confused.

> > 
> > - if that failed, modprobe the driver
> > 
> 
> Succeeds since the driver name changed (we renamed it to vmware_balloon
> before submitting into mainline to avoid confusion based on our experience
> with pvscsi; the existing one in the wild is called vmmemctl).
> 
> Now we have 2 drivers fighting. There is no backing device and so driver
> core will not save us by refusing to bind to already claimed device.

If vmware_balloon is present in /sys/modules or is loaded, don't load
vmmemctl.  And vice versa.

I dunno - it's silly for me to sit here proposing solutions.  it's
better that you do it!


