Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab1FOQzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 12:55:18 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60938 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab1FOQzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 12:55:16 -0400
Date: Wed, 15 Jun 2011 09:54:14 -0700
From: Ram Pai <linuxram@us.ibm.com>
To: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: sdhci-pci fails on 3.0.0-rc1 on Dell E6510
Message-ID: <20110615165414.GA11421@ram-laptop>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <4DEBCA3F.8050205@hartkopp.net>
 <BANLkTin_WHuy5MExNBHdeLiDmdmn7SZYkg@mail.gmail.com>
 <4DED05C4.7050903@hartkopp.net>
 <m3hb82wx6m.fsf@pullcord.laptop.org>
 <4DEE6FC6.9040308@hartkopp.net>
 <4DEE84AD.6050104@hartkopp.net>
 <4DEEA3CD.30507@kernel.org>
 <4DEF1606.5030803@hartkopp.net>
 <20110612204406.GC30738@ram-laptop>
 <4DF8E083.1080006@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF8E083.1080006@hartkopp.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 06:40:35PM +0200, Oliver Hartkopp wrote:
> On 12.06.2011 22:44, Ram Pai wrote:
> > On Wed, Jun 08, 2011 at 08:26:14AM +0200, Oliver Hartkopp wrote:
> >> On 08.06.2011 00:18, Yinghai Lu wrote:
> >>> thanks.
> >>>
> >>> second report.
> >>>
> >>> can you send out whole boot log.
> >>
> >> See attached dmesg output. The 'dirty' is due to the revert test of the sd/mmc
> >> stuff (see below) - the rest is plain 3.0.0-rc2.
> >>
> >> Good luck :-)
> > 
> > Looks like the kernel; by default, tries to allocate mem resource of size
> > 0x4000000 each to the BARs of the cardbus bridge. This cannot be satisfied
> > meeting all the constraints. The BIOS had not allocated the resource to
> > begin with.
> > 
> > Anyone knows if the default value can be reduced to something smaller?
> > Or Should the resource requirements of cardbus bridge be made nice-to-have?
> 
> Don't know ...
> 
> Is anyone already working on this issue?
> 
> I'm currently running 3.0.0-rc3-00055-gada9c93 which still does not work.
> 
> Will say: 'Send more patches!' ... that i can test, if you still like the
> problematic commit's idea ;-)

Oliver,

	Yes. I am working on this. I will send you a patch soon; probably by
the end of this week. See if they work for you.

Currently my thought is to make cardbus-bridge resource allocation
nice-to-have, which means it will be attempted to allocate. But if in case of
failures, we wont go the full length of releasing other resources to satisfy
this resource.


RP
