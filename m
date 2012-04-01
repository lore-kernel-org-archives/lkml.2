Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab2DAQLO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 12:11:14 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:28883 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751820Ab2DAQLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:11:13 -0400
Date: Sun, 1 Apr 2012 17:11:08 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Matthew Garrett <mjg@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [ 06/41] PCI: ignore pre-1.1 ASPM quirking when ASPM is disabled
Message-ID: <20120401161108.GA6448@milliways>
References: <20120316233829.GA14022@kroah.com>
 <20120316233811.136320350@linuxfoundation.org>
 <20120331032356.GA6664@milliways>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120331032356.GA6664@milliways>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=wom5GMh1gUkA:10 a=2EL98pTPio4A:10 a=uObrxnre4hsA:10 a=8nJEP1OIZ-IA:10 a=20KFwNOVAAAA:8 a=TBVoxVdAAAAA:8 a=ag1SF4gXAAAA:8 a=fiPtClUq_frGzZq9riYA:9 a=wPNLvfGTeEIA:10 a=jEp0ucaQiEUA:10 a=rW6DTWptwo0A:10 a=1TSTQ8KKaH4A:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 04:23:56AM +0100, Ken Moffat wrote:

[ update : 3.4.0-rc1 boots without reverting this ]
> On Fri, Mar 16, 2012 at 04:38:16PM -0700, Greg KH wrote:
> > 3.2-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Matthew Garrett <mjg@redhat.com>
> > 
> > commit 4949be16822e92a18ea0cc1616319926628092ee upstream.
> > 
> > Right now we won't touch ASPM state if ASPM is disabled, except in the case
> > where we find a device that appears to be too old to reliably support ASPM.
> > Right now we'll clear it in that case, which is almost certainly the wrong
> > thing to do. The easiest way around this is just to disable the blacklisting
> > when ASPM is disabled.
> > 
> > Signed-off-by: Matthew Garrett <mjg@redhat.com>
> > Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> 
>  Sorry for the late response, but I bought a new machine this week
> (low-end i3) and this has bitten me.  I prepared a "generic" x86_64
> kernel using 3.2.9, which I hoped would be good enough to get me
> started, and later prepared another using 3.3.0.  Long story short -
> 3.2.9 was adequate, 3.3.0 crashes early in boot (before switching
> from the 80x25 console to kms).  All the interesting part has
> scrolled off the screen, and it's too early to get logged.
> 
[...]
>   Trial and error showed this commit seemed to be the
> problem.
> 
>  I then reverted this commit from 3.3.0, and took my amended .config
> which works adequately in vanilla 3.2.8.  I'm now running that.
> 
 BUT, for 3.4.0-rc1 I don't need to revert it - just went with the
defaults for additions in menuconfig, and it boots fine.  Maybe
something else needs to be backported ?

ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
