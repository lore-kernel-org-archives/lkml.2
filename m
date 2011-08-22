Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab1HVOHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 10:07:39 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52379 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab1HVOHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 10:07:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Miller <davem@davemloft.net>
Subject: Re: of_iomap() matched with plan iounmap()
Date: Mon, 22 Aug 2011 16:07:25 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, davidb@codeaurora.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20110818170226.GA16721@huya.qualcomm.com> <201108191426.19152.arnd@arndb.de> <20110819.062609.1865751197015675220.davem@davemloft.net>
In-Reply-To: <20110819.062609.1865751197015675220.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108221607.25179.arnd@arndb.de>
X-Provags-ID: V02:K0:0hoI6kQolfW9EH1pQPPip0JbIH+aGnFNW6hRrh6bRb3
 zU4i3P75uPuqbOU35woKWk+GZjFOFw1QDxQ4usTru2BpNEBIts
 /91DeC1IATDexegWq6qpMch+tmLm+8Kl/jHffGrSE5hbTw7d7P
 zl+jzLsEOaEbF6povYKzS9cZuHmAWE20Sb0HkMSOma4JyRRkjn
 nqst5IbbYti77IpT9yJrg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 August 2011, David Miller wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> Date: Fri, 19 Aug 2011 14:26:18 +0200
> 
> > We could of course change all existing users of of_iounmap on sparc to use
> > the simpler prototype, because it also just calls iounmap.
> 
> Check again, on sparc64 it needs the resource to release it.
> 
> Only the 32-bit version on sparc evaluates to just a plain iounmap().

Ok, I see.

On Friday 19 August 2011, David Brown wrote:
> What if we left the SPARC calls alone, and changed of_iomap() into
> of_dt_iomap() and could then make of_dt_iounmap().  Or, it could just
> be of_dt_map(), and of_dt_unmap().

I think at some point in the future, we will have a mass-renaming
of of_* to dt_* or similar, which would result in a silly name.

Also, the of_iomap() name is modeled after pci_iomap/pci_iomap.

How about renaming the sparc of_ioremap/of_iounmap pair to
resource_iomap/resource_iounmap? I believe that it is not
(any more) tied to device tree based probing at all, and also
could be useful for other subsystems on non-sparc architectures.

	Arnd
