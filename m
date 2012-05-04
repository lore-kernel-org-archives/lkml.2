Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750871Ab2EDEUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 00:20:11 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40360 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab2EDEUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 00:20:10 -0400
Message-ID: <4FA358ED.1080705@gmail.com>
Date: Fri, 04 May 2012 14:19:57 +1000
From: Francois Rigaut <frigaut@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Nico Schottelius <nico-linux-20120419@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux Support for Thunderbolt using Apple Monitor
References: <20120419163800.GB13977@schottelius.org> <CAMVeQ8r_3vuAxzbLyKoecOHOOGijUDkLfw+MK7o-WoWbuOGSrg@mail.gmail.com> <20120502163629.GE928@schottelius.org> <20120502202509.GA26798@kroah.com> <20120503065003.GB13386@schottelius.org> <CAMVeQ8qYu4bShd_+pwRv8bShhusJMDa-jjoqu7EujS4jt7RSNA@mail.gmail.com> <20120503153547.GD20334@kroah.com> <CAMVeQ8q3PMMGmFSgrnqbW2HVdfmN+LgatX3TSfv5_2Ebuuj=QQ@mail.gmail.com> <20120503233858.GA13453@kroah.com>
In-Reply-To: <20120503233858.GA13453@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg, Nico,

Thanks Greg for giving us some attention. I went ahead and collected a 
number of information that could be useful to track down our hotplug issue.

1) Coldplug: Booting with the thunderbolt display attached. This works. 
Several devices (additional to what I get without the display attached) 
are listed. Here is the relevant info:

http://maumae.net/thunderbolt/coldplug_efi/log  -> kernel.log
http://maumae.net/thunderbolt/coldplug_efi/lspci -> lspci and lspci -vv
http://maumae.net/thunderbolt/coldplug_efi/lsmod
http://maumae.net/thunderbolt/coldplug_efi/config_excerpt.txt
full config @ http://maumae.net/thunderbolt/config.gz
http://maumae.net/thunderbolt/coldplug_efi/disconnect -> message when 
disconnecting (pciehp loaded just before)

note that an attempt to reconnect leads to the same issue as described 
before, i.e. nothing happens.

2) Booting with the display/device not plugged, just for reference:

http://maumae.net/thunderbolt/notplugged_efi/log
http://maumae.net/thunderbolt/notplugged_efi/lsmod
http://maumae.net/thunderbolt/notplugged_efi/misc
http://maumae.net/thunderbolt/notplugged_efi/lspci

3) Again, I have tried to load pciehp and acpiphp with both EFI boot and 
BIOS emulation boot:
- pciehp loads ok but as I said earlier, no message whatsoever in 
everything.log when I try to connect the thunderbolt display
- acpiphp: I was wrong yesterday. In fact, trying to load acpiphp gives 
me a message:
[root@poliahu thunderbolt]# modprobe acpiphp
ERROR: could not insert 'acpiphp': No such device

Not sure what to make of it. I have tried to also load acpiphp after a 
coldplug boot; same error message.

I've read somewhere that this error message may mean that the h/w 
doesn't support hotplugging. However, I think the coldplug lspci -vv 
above tells us the h/w does support pcie hotplug: all the pci bridges 
appear to have D3hot+ capability (and it certainly does, as this works 
under osx on the same machine).

Any suggestion are welcome! Thanks.
Francois

