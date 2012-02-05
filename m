Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab2BELAz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 06:00:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37592 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754568Ab2BELAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 06:00:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: markgross@thegnar.org
Subject: Re: [PATCH] CPU C-state breakage with PM Qos change
Date: Sun, 5 Feb 2012 12:04:38 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: "Pihet-XID, Jean" <j-pihet@ti.com>, Venkatesh Pallipadi <venki@google.com>,
        Kevin Hilman <khilman@ti.com>, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
References: <1328227065-22045-1-git-send-email-venki@google.com> <CAN5iSWo-n7OER4i1tPoeGBhY_RY-nX=7n4B3mFv1f0JK074bhQ@mail.gmail.com> <20120205035057.GA4948@gs62>
In-Reply-To: <20120205035057.GA4948@gs62>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202051204.38717.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 05, 2012, mark gross wrote:
> On Fri, Feb 03, 2012 at 03:04:43PM +0100, Pihet-XID, Jean wrote:
> > Looping in linux-pm
> > 
> > On Fri, Feb 3, 2012 at 1:14 AM, Venkatesh Pallipadi <venki@google.com> wrote:
> > > Looks like change "PM QoS: Move and rename the implementation files"
> > > made pm_qos depend on CONFIG_PM which depends on
> > > PM_SLEEP || PM_RUNTIME
> > >
> > > That breaks CPU C-states with kernels not having these CONFIGs, causing CPUs
> > > to spend time in Polling loop idle instead of going into deep C-states,
> > > consuming way way more power. This is with either acpi idle or intel idle
> > > enabled.
> > >
> > > Either CONFIG_PM should be enabled with any pm_qos users or
> > > the !CONFIG_PM pm_qos_request() should return sane defaults not to break
> > > the existing users. Here's is the patch for the latter option.
> > I think the real question is whether PM QoS should be functional in
> > all cases (as is ACPI) or whether only if certain options are set
> > (CONFIG_PM).
> > In the current code if CONFIG_PM is not enabled, a dummy PM QoS API is
> > provided as function stubs in order for the build to succeed.
> > 
> > Rafael, Mark,
> > What do you think? Should PM QoS be enabled in all cases? Are there
> > any known dependencies with CONFIG_PM?
> 
> Yes I do think pm_qos interfaces should be enabled all the time and be
> independent of CONFIG_PM.  Also, I still am not a fan of the renaming
> patch but, as the argument for and against renaming cannot be based on
> quantifiable things I've chosen not to let it bother me.
> 
> I think Venki's change is a band aid and we should fix it right by not
> having a dependency on config_pm for the interface to behave.
> 
> I'll take a look at why there is now a dependency before I have more to
> say.

In kernel/power/Makefile:

obj-$(CONFIG_PM)                += main.o qos.o

I guess that explains things. :-)

It's quite easy to make qos.o be independent of CONFIG_PM, in which case the
code added by Venki can be removed, so patches welcome (for 3.4, though).

Thanks,
Rafael
