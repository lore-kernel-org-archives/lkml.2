Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab2F1WeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 18:34:20 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:38052 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab2F1WeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 18:34:18 -0400
Date: Fri, 29 Jun 2012 00:23:25 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Nix <nix@esperi.org.uk>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 3.4.x regression: rtl8169: frequent resets
Message-ID: <20120628222325.GA1579@electric-eye.fr.zoreil.com>
References: <87y5n7qup0.fsf@spindle.srvr.nix> <20120628193026.GA31627@electric-eye.fr.zoreil.com> <87fw9fp2e1.fsf@spindle.srvr.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fw9fp2e1.fsf@spindle.srvr.nix>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nix <nix@esperi.org.uk> :
> Francois Romieu <romieu@fr.zoreil.com> :
> > Can you try and revert 036dafa28da1e2565a8529de2ae663c37b7a0060 ?
> 
> I can try, but there's been a *lot* of code motion since then, 'git
> revert' fails hilariously (trying to patch obviously the wrong places):
> I'll have to do it by hand.

There is a single line reject in rtl8169_start_xmit. Other than that it
should patch -p1 -R fine.

[...]
> I note that at some time (after the first reset?), my MTU either flipped
> back to 1500, from its initial jumbo default, or simply refused to go
> jumbo in the first place. I bring it up like so:
> 
> ip link set fastnet up multicast on txqueuelen 100 mtu 7200
> ip addr add local 192.168.16.20/24 broadcast 192.168.16.255 dev fastnet
> 
> but its MTU is now shown as 1500 :( so at some point either jumbo frames
> have stopped working or the reset is flipping them off.
[...]
> [    1.341389] r8169 0000:06:00.0: eth0: jumbo features [frames: 6128 bytes, tx checksumming: ko]

This chipset is not supposed to be pushed beyond 6128 bytes.

-- 
Ueimor
