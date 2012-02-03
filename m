Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab2BCT6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 14:58:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36238 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309Ab2BCT6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 14:58:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Pihet-XID, Jean" <j-pihet@ti.com>
Subject: Re: [PATCH] CPU C-state breakage with PM Qos change
Date: Fri, 3 Feb 2012 21:02:16 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Venkatesh Pallipadi <venki@google.com>, markgross <markgross@thegnar.org>,
        Kevin Hilman <khilman@ti.com>, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
References: <1328227065-22045-1-git-send-email-venki@google.com> <1328228079-20716-1-git-send-email-venki@google.com> <CAN5iSWo-n7OER4i1tPoeGBhY_RY-nX=7n4B3mFv1f0JK074bhQ@mail.gmail.com>
In-Reply-To: <CAN5iSWo-n7OER4i1tPoeGBhY_RY-nX=7n4B3mFv1f0JK074bhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202032102.16936.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 03, 2012, Pihet-XID, Jean wrote:
> Looping in linux-pm
> 
> On Fri, Feb 3, 2012 at 1:14 AM, Venkatesh Pallipadi <venki@google.com> wrote:
> > Looks like change "PM QoS: Move and rename the implementation files"
> > made pm_qos depend on CONFIG_PM which depends on
> > PM_SLEEP || PM_RUNTIME
> >
> > That breaks CPU C-states with kernels not having these CONFIGs, causing CPUs
> > to spend time in Polling loop idle instead of going into deep C-states,
> > consuming way way more power. This is with either acpi idle or intel idle
> > enabled.
> >
> > Either CONFIG_PM should be enabled with any pm_qos users or
> > the !CONFIG_PM pm_qos_request() should return sane defaults not to break
> > the existing users. Here's is the patch for the latter option.
> I think the real question is whether PM QoS should be functional in
> all cases (as is ACPI) or whether only if certain options are set
> (CONFIG_PM).
> In the current code if CONFIG_PM is not enabled, a dummy PM QoS API is
> provided as function stubs in order for the build to succeed.
> 
> Rafael, Mark,
> What do you think? Should PM QoS be enabled in all cases? Are there
> any known dependencies with CONFIG_PM?

At least we should keep the current behavior to avoid breaking things
for now.  We can change that in the next cycle, however, if everyone
agrees, but more carefully.

The patch has been applied to linux-pm/linux-next and will be pushed to Linus
early next week.

Thanks,
Rafael
