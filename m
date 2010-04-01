Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833Ab0DAUFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 16:05:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50265 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758769Ab0DAUF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 16:05:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Parag Warudkar <parag.lkml@gmail.com>
Subject: Re: S2RAM broken on HP 8530p
Date: Thu, 1 Apr 2010 22:08:37 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <alpine.DEB.2.00.1003312050370.1876@parag-laptop> <201004010316.17898.rjw@sisk.pl> <alpine.DEB.2.00.1003312136220.1726@parag-laptop>
In-Reply-To: <alpine.DEB.2.00.1003312136220.1726@parag-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004012208.37540.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 April 2010, Parag Warudkar wrote:
> 
> On Thu, 1 Apr 2010, Rafael J. Wysocki wrote:
> 
> > On Thursday 01 April 2010, Parag Warudkar wrote:
> > > 
> > > Running Ubuntu Lucid 64-bit I noticed suspending fails with current git. 
> > > Unsure since when it started - perhaps a while ago since the stock distro 
> > > kernel 2.6.32-18 also fails to suspend - albeit little differently - 
> > > git will fail before shutting off the display, distro one succeeds in 
> > > shutting off the display and then hangs.
> > > 
> > > Any ideas how to go about debugging this? 
> > 
> > Please first try to suspend after echoing 0 to /sys/power/pm_async.
> 
> No change - hangs the same way as before.
> 
> I recall it used to work with prior kernels and so I tried 2.6.31 from 
> kernel.ubuntu.com/~kernel-ppa/
> 
> mainline/v2.6.31/ but that fails similarly. 
> 
> May be I could try 2.6.30 but from a bisect stand point thats not all that 
> attractive even if we find it works..

Yeah, kind of.

Please try:

# echo devices > /sys/power/pm_test
# echo mem > /sys/power/state

and see if that breaks too (it should get back to the command line in about
5-10 seconds).

Rafael
