Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab0FVFPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 01:15:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969Ab0FVFPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 01:15:15 -0400
Subject: Re: Possible NetworkManager problem with 2.6.35-rc3
From: Dan Williams <dcbw@redhat.com>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Alan <alan@clueserver.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20100615085007.GN20317@bombadil.infradead.org>
References: <54979.10.6.6.23.1276550815.squirrel@10.6.6.2>
	 <20100615085007.GN20317@bombadil.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Jun 2010 22:15:28 -0700
Message-ID: <1277183728.1407.22.camel@dcbw>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-15 at 04:50 -0400, Kyle McMartin wrote:
> On Mon, Jun 14, 2010 at 02:26:55PM -0700, Alan wrote:
> > In order to get my sata controller to work I built a current kernel using
> > the config file from my Fedora 13 system.
> > 
> > Everything works except for networking.
> > 
> > It uses the forcedeth driver, but network manager does not want to see the
> > card whatsoever.
> > 
> <snip>
> > Jun 14 13:43:43 zowie NetworkManager[894]: <warn> /sys/class/net/eth0:
> > couldn't determine device driver; ignoring...
> > Jun 14 13:43:43 zowie NetworkManager[894]: <warn> /sys/class/net/eth1:
> > couldn't determine device driver; ignoring...
> 
> Even if there is a sysfs bug in 2.6.35-rc3, it looks pretty braindead
> that network-manager falls over for this.
> 
> Dan, any ideas?

Yes, we require a correctly set up sysfs.  It's not strictly necessary,
but the checks for driver are there to validate the driver that the
hardware uses.  If the driver isn't setting up sysfs correctly, it's a
sure bet something else is wrong or that the driver is a pile of
steaming junk.

cd -P /sys/class/net/eth0/device
ls -al
cd -P driver
pwd

and lets see what we get.  If the "cd -P driver" doesn't dump you into
the directory for that driver (ie 'forcedeth' or 'e1000e' etc) then the
driver needs to get fixed.

Dan

