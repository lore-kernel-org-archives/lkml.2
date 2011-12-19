Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab1LSAgF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 19:36:05 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57550 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab1LSAgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 19:36:03 -0500
Date: Sun, 18 Dec 2011 22:36:52 -0200
From: Gustavo Padovan <padovan@profusion.mobi>
To: David Fries <david@fries.net>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arek Lichwa <arkadiusz.lichwa@tieto.com>, iliak@ti.com,
        ulrik.lauren@stericsson.com, peter@hurleysoftware.com
Subject: Re: [REGRESSION] 3.2.0-rc3 Bluetooth L2CAP Linux to Linux rfcomm
 fails
Message-ID: <20111219003652.GN2621@joana>
Mail-Followup-To: David Fries <david@fries.net>,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
	Arek Lichwa <arkadiusz.lichwa@tieto.com>, iliak@ti.com,
	ulrik.lauren@stericsson.com, peter@hurleysoftware.com
References: <1319621002-7122-1-git-send-email-arkadiusz.lichwa@tieto.com>
 <20111031190129.GA10164@joana>
 <20111211051624.GA12050@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111211051624.GA12050@spacedout.fries.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

* David Fries <david@fries.net> [2011-12-10 23:16:24 -0600]:

> On Mon, Oct 31, 2011 at 05:01:29PM -0200, Gustavo Padovan wrote:
> > Hi Arek,
> > 
> > * Arek Lichwa <arkadiusz.lichwa@tieto.com> [2011-10-26 11:23:21 +0200]:
> > 
> > > Hi
> > > 
> > > We found during testing problem when setting rfcomm (SPP) channel between
> > > two 2.1 devices. 
> > > The test case always failed mostly saying security block on l2cap level 
> > > but sometimes the fail root cause was 'Command not understood' on l2cap 
> > > as well.
> > > Analyzing security block issue, I found that there's unencrypted link when
> > > l2cap command 'connection request' is sent to remote.
> > > The second issue with 'command not understood' has turn out to be related to 
> > > expiration of l2cap timer and its implications.
> > > 
> > > Solution that I found to fix the problem seems to be related to old commit 
> > > 330605423ca6eafafb8dcc27502bce1c585d1b06 made by Ilia Kolomisnky. When there's
> > > authentication ongoing, 'encryption pending' should be turn on, otherwise 
> > > there're situations when link stays unencrypted. 
> > > The issue with timer expiration is related to Andrzej Kaczmarek's patch 
> > > sent to community a couple days ago (~ 2011/10/20). 
> > > This patch actually recalculates (repairs) timer values on l2cap which were 
> > > wrongly converted before. 
> > > With this patch the expiration issue disappears during the test case 
> > > I've made, otherwise just reverting 330605423ca6eafafb8dcc27502bce1c585d1b06
> > > is not enough, since timer issue blocks very often passing the test case.
> > 
> > Are you saying that Andrzej's patch together with revert of 330605423 fixes
> > the problem? and are you sure that we are not creating any new regression?
> > 
> > 	Gustavo
> 
> I just found that I can't connect rfcomm any more from Linux (desktop)
> to Linux (N900) with bluetooth.  On the desktop side, 3.2.0-rc2 works,
> but 3.2.0-rc3 (and on) fails, I even merged in
> git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-next
> master 5a13b09531420d230616bd524b68a5b0c23cd487 without any change.
> Fortunately there were only three bluetooth patches between rc2 and rc3.
> Reverting 4dff523a913197e3314c7b0d08734ab037709093 fixed the issue and
> I can connect again.

I wen ahead and reverted this one.

	Gustavo
