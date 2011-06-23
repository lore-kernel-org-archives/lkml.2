Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934458Ab1FWUlt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 16:41:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54235 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933908Ab1FWUlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 16:41:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 4/4] PCI: make cardbus-bridge resources nice-to-have
Date: Thu, 23 Jun 2011 22:42:29 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Ram Pai <linuxram@us.ibm.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        svenkatr@ti.com, yinghai@kernel.org, cjb@laptop.org,
        linux-pci@vger.kernel.org, linux-net-drivers@solarflare.com,
        bhutchings@solarflare.com, Bjorn Helgaas <bhelgaas@google.com>
References: <1308610037-6261-1-git-send-email-linuxram@us.ibm.com> <20110622004816.GC22917@ram-laptop> <20110623133137.03c74ea4@jbarnes-desktop>
In-Reply-To: <20110623133137.03c74ea4@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106232242.29753.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 23, 2011, Jesse Barnes wrote:
> On Tue, 21 Jun 2011 17:48:16 -0700
> Ram Pai <linuxram@us.ibm.com> wrote:
> > I assume majority of the platforms will have enough resources to satisfy all
> > the resource requests, and their BIOS would have done a decent job.
> > 
> > Even if the BIOS has not done a decent job, and there are enough resources
> > available we should not see a regression.
> > 
> > The only platforms that would expose a regression is when resources are under
> > contention and the BIOS has assigned enough resource to the cardbus bridge but
> > not to some other device. It will be hard to find such a platform, but I am
> > sure there is one out somewhere there.
> > 
> > I am sure we will see; some day, reports of regression because that platform
> > would have the exact right characteristics to expose the issue. But then that
> > platform is a highly constrained platform in the first place. Its debatable if
> > that should be characterised as a regression, or a platform that was riding on
> > good luck till now.
> > 
> > Even Oliver's platform is a highly constrained platform, and we probably can
> > treat his platform as 'riding on good luck till now'.
> > 
> > We won't be able to satisfy all the platforms with resource constraints.  I
> > think our probable choice is to select a solution that breaks least number of
> > platforms and special case those broken platforms through kernel command line
> > parameters.
> 
> Another option is to hide the new allocation behavior behind a kernel
> parameter.  I know Bjorn has opposed this in the past because really
> this sort of thing should "just work".  But so far it hasn't, and we've
> had to revert both Bjorn's resource tracking changes as well as the
> re-allocation code.
> 
> Hiding it behind a boot option would at least let us improve things
> over time and potentially switch over to new resource code in the
> future...
> 
> Thoughts?

Do I understand correctly that at the moment we have two set of systems,
one of which works with the new code and doesn't work with the old code
and the other one conversely?

Rafael
