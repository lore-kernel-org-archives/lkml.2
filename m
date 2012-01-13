Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721Ab2AMS2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 13:28:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44896 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932487Ab2AMS2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 13:28:31 -0500
Date: Fri, 13 Jan 2012 10:24:33 -0800
From: Greg KH <gregkh@suse.de>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] driver core merge for 3.3
Message-ID: <20120113182433.GB30411@suse.de>
References: <20120106201126.GA7239@kroah.com>
 <CA+55aFzH1cqoxr5RR8yqPdjf4XphKHk9YmcDozPn_z7Aq3nDcg@mail.gmail.com>
 <CAPXgP120MoEUK9vSiELx4nzkL9X3w=YBgXGs3Q-VPm-4ZjgvZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPXgP120MoEUK9vSiELx4nzkL9X3w=YBgXGs3Q-VPm-4ZjgvZQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 02:39:27AM +0100, Kay Sievers wrote:
> On Fri, Jan 13, 2012 at 02:11, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Fri, Jan 6, 2012 at 12:11 PM, Greg KH <gregkh@suse.de> wrote:
> >>
> >> Big thing here, that caused all of the merge issues, is the removal of
> >> the sysdev code.  It has been long needed to be removed, Kay finally
> >> just did it, thankfully.  There are patches pending that take advantage
> >> of this, providing properly CPU hotplug driver loading support, that
> >> will have to wait until 3.4, as they didn't make the merge window in
> >> time.  Note, the sysdev code isn't removed from the tree just yet, to
> >> help catch any other tree that might not have noticed this in the
> >> linux-next merge process.  I'll send a follow-on patch after 3.3-rc1 is
> >> out that removes this code, after ensuring that no other in-tree code is
> >> using the sysdev structures.
> >
> > Hmm. I think this is the cause of one of the suspend/resume problems I'm seeing:
> >
> >   Device 'machinecheck3' does not have a releae() function, it is
> > broken and must be fixed
> >
> > that's the WARN_ON() in drivers/base/core.c (line 192), and it comes
> > from disable_nonboot_cpus() doing the whole device_unregister() thing.
> >
> > Afaik, it's arch/x86/kernel/cpu/mcheck/mce.c.
> 
> I guess this kind of warning just did not exist for the old sysdev
> devices. The 'machinecheck' devices are DEFINE_PER_CPU(struct device,
> mce_device) devices, so we will probably just add a dummy release
> function, which might not fix the problem you are seeing.

Shouldn't we have a "real" release function here for when we remove
sysdev devices?  The cpu hotplug code should remove them, as should
unloading the kernel module here.

Care to make up a patch?

thanks,

greg k-h
