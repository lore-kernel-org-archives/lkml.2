Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab1CVPuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 11:50:08 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:48473 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751555Ab1CVPuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 11:50:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=WYbX/Y1gxO+5t+uEbB1VEJVPPYZhwCKzIbVmtQzJLhFbmVMp56Wg559/gZBTglUMRtp3XL7L7qS+EnFofgqFkTMXiIWUiNnFFqkhSP9+IFqLRL9GVXfHTsYxcd/iWiRi;
Date: Tue, 22 Mar 2011 08:49:58 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andreas Hartmann <andihartmann@freenet.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: intel_ips produces constant load of 1
Message-ID: <20110322084958.7fa17ae3@jbarnes-desktop>
In-Reply-To: <4D884917.2010400@dualc.maya.org>
References: <im2ik4$3dd$1@ID-44327.news.uni-berlin.de>
	<20110321110404.6a71a404@jbarnes-desktop>
	<4D884917.2010400@dualc.maya.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Mar 2011 08:00:39 +0100
Andreas Hartmann <andihartmann@freenet.de> wrote:

> Jesse Barnes wrote:
> > On Sat, 19 Mar 2011 16:38:38 +0100
> > Andreas Hartmann <andihartmann@01019freenet.de> wrote:
> > 
> >> Hello,
> >>
> >> on my MSI CR620 laptop, intel_ips produces a constant load of 1, even if
> >> the machine is idle.
> >>
> >> The ips-monitor hangs in D state:
> >>
> >> ps aux | grep ips
> >> root       593  0.0  0.0      0     0 ?        S    17:20   0:00
> >> [ips-adjust]
> >> root       594  0.0  0.0      0     0 ?        D    17:20   0:00
> >> [ips-monitor]
> >>
> >> If the module isn't loaded, the load of the machine in idle mode is 0 as
> >> expected.
> > 
> > This is a reporting problem, and probably due to the schedule() call
> > and associated task state in the ips-monitor thread.  I thought setting
> > the task state to interruptible would prevent this, but it seems like
> > it's not enough for the deferrable on-stack timers?
> > 
> > At any rate, it's not actually causing increased CPU usage, so you can
> > safely ignore it until we have a fix.
> > 
> 
> I've got one more question (I found
> http://forum.soft32.com/linux/RFC-Intelligent-power-sharing-driver-ftopict510146.html):
> 
> Where is the difference to the functionality the bios provides? I can't
> see (and hear :-)) any difference between with intel_ips and without
> intel_ips.
> The fan always runs at a minimal speed, very quiet.
> The fan is getting loader, if the load is getting high (during
> compile-sessions e.g.). If the compile session is ready, the fan get's
> slower again.
> 
> If I check the "cpu MHz" in /proc/cpuinfo with or without intel_ips, I
> can't see any difference. The value never exceeds the value given in the
> model name. The lowest values are equal, too.
> 
> 
> What is the added value compared to the bios functionality? How can I
> check it?

Loading the IPS driver will allow graphics turbo.  This can improve gfx
performance quite a bit (up to 3x on some synthetic workloads).  If
you're not really using gfx though, the driver won't really do anything
for you.

-- 
Jesse Barnes, Intel Open Source Technology Center
