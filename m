Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759053Ab2ECXjE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 19:39:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59453 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756946Ab2ECXjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 19:39:02 -0400
Date: Thu, 3 May 2012 16:38:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Francois Rigaut <frigaut@gmail.com>
Cc: Nico Schottelius <nico-linux-20120419@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux Support for Thunderbolt using Apple Monitor
Message-ID: <20120503233858.GA13453@kroah.com>
References: <20120419163800.GB13977@schottelius.org>
 <CAMVeQ8r_3vuAxzbLyKoecOHOOGijUDkLfw+MK7o-WoWbuOGSrg@mail.gmail.com>
 <20120502163629.GE928@schottelius.org>
 <20120502202509.GA26798@kroah.com>
 <20120503065003.GB13386@schottelius.org>
 <CAMVeQ8qYu4bShd_+pwRv8bShhusJMDa-jjoqu7EujS4jt7RSNA@mail.gmail.com>
 <20120503153547.GD20334@kroah.com>
 <CAMVeQ8q3PMMGmFSgrnqbW2HVdfmN+LgatX3TSfv5_2Ebuuj=QQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMVeQ8q3PMMGmFSgrnqbW2HVdfmN+LgatX3TSfv5_2Ebuuj=QQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 09:04:33AM +1000, Francois Rigaut wrote:
> Sorry for the lag, I live down under.
> 
> On Fri, May 4, 2012 at 1:35 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> 
>     On Thu, May 03, 2012 at 09:45:00PM +1000, Francois Rigaut wrote:
>     > After Greg pointed to the PCIE, I realized that modules related to PCIE
>     > hotpluging were not loaded in my config. I then did a whole bunch of test
>     > modprobing a couple of modules: pciehp (with and without pciehp_force and
>     /or
>     > pciehp_poll_mode) and acpiphp (not together obviously). No
>     change:connecting
>     > the thunderbolt does not lead to any kernel activity. No message
>     whatsoever in
>     > /var/log/everything.log.
>     > Checked /sys/bus/pci/slots, nothing appeared. No change in lspci. Added a
>     "echo
>     > 1 > /sys/bus/pci/rescan" for good measure to no avail.
> 
>     Does anything show up in there at all?
> 
> Greg, nope, nothing at all shows in either slots or everything.log after a
> hotplug. not a single line in the log file and no files in the /sys/bus/pci/
> slots directory.
>  
> 
> 
>     How about if you load the acpiphp module instead?  Some BIOSes use that
>     instead of pciehp.
> 
> I tried both with pciehp *and* acpiphp.

Odd, one of them should work.  If not, then that's why this isn't
working.

>     You need one of those drivers in order for this to work properly.
> 
>     Also, speaking of BIOS, make sure you have the latest updates, there
>     were a lot of initial problems with Thunderbolt hotplug issues that were
>     fixed in newer BIOS versions, so that will be required to be updated.
> 
> well that might be the problem. In fact, I'm booting EFI directly using the
> 3.3+ kernel direct efi boot feature. Might that be the problem? I though
> booting EFI on an EFI machine was supposed to give you better hardware
> recognition (I am on a macbook air trying to hotplug a thunderbolt display to
> the thunderbolt/displayport connector).
> Anyway, I will try with a more standard (fake) BIOS boot when I get to work.

That "shouldn't" make a difference, but it would be good to find out.

thanks,

greg k-h
