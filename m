Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab2LNJEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 04:04:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652Ab2LNJEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 04:04:39 -0500
Date: Fri, 14 Dec 2012 09:04:18 +0000
From: "Daniel P. Berrange" <berrange@redhat.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH] core_pattern: set core helpers root and namespace to
 crashing process
Message-ID: <20121214090418.GA6044@redhat.com>
Reply-To: "Daniel P. Berrange" <berrange@redhat.com>
References: <1355255996-25953-1-git-send-email-nhorman@tuxdriver.com>
 <20121213122048.GF5246@sergelap>
 <20121213181220.GB14796@hmsreliant.think-freely.org>
 <20121213142534.ea07a3c8.akpm@linux-foundation.org>
 <20121214024938.GA6591@neilslaptop.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121214024938.GA6591@neilslaptop.think-freely.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 09:49:39PM -0500, Neil Horman wrote:
> On Thu, Dec 13, 2012 at 02:25:34PM -0800, Andrew Morton wrote:
> > On Thu, 13 Dec 2012 13:12:20 -0500
> > Neil Horman <nhorman@tuxdriver.com> wrote:
> > 
> > > On Thu, Dec 13, 2012 at 06:20:48AM -0600, Serge Hallyn wrote:
> > > > Quoting Neil Horman (nhorman@tuxdriver.com):
> > > > > Theres one problem I currently see with it, and that is that I'm not sure we can
> > > > > change the current behavior of how the root fs is set for the pipe reader, lest
> > > > > we break some user space expectations. As such, I've added a sysctl in this
> > > > > patch to allow administrators to globally select if a core reader specified via
> > > > > /proc/sys/kernel/core_pattern should use the global rootfs, or the (possibly)
> > > > > chrooted fs of the crashing process.
> > > > 
> > > > Practical question:  How is the admin to make an educated decision on
> > > > how to set the sysctl?
> > 
> > By reading the documentation which Neil didn't include?
> > 
> Yeah, that was stupid of me, I'll respin this with docs.
> 
> > > My thought was that the admin typically wouldn't touch this at all.  I really
> > > added it as a backwards compatibility option only.  Setting the user space
> > > helper task to the root of the crashing parent has the possibility of breaking
> > > existing installs because the core_pattern helper might be expecting global file
> > > system access.  Moving forward, my expectation would be that core_pattern
> > > helpers would be written with the default setting in mind, and we could
> > > eventually deprecate the control entirely.
> > > 
> > > If you have a better mechanism in mind however (or if you think that removing
> > > the control is a resaonable approach), I'm certainly open to that.
> > 
> > Yeah, this is a tiresome patch but I can't think of a better way.
> > 
> > Except, perhaps, adding a new token to the core_pattern which says
> > "switch namespaces"?
> >
> I like that idea, perhaps '||' instead of '|' as the leading token can indicate
> "use the namespace root" vs. "use the global root".  Thoughts?

That seems like a nicer idea to me, than the extra sysctl knob.

Daniel
-- 
|: http://berrange.com      -o-    http://www.flickr.com/photos/dberrange/ :|
|: http://libvirt.org              -o-             http://virt-manager.org :|
|: http://autobuild.org       -o-         http://search.cpan.org/~danberr/ :|
|: http://entangle-photo.org       -o-       http://live.gnome.org/gtk-vnc :|
