Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767643Ab2KOL4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 06:56:55 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:60728 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993257Ab2KOL4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 06:56:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [RFC Patch v1 33/55] ARC: ptrace support
Date: Thu, 15 Nov 2012 11:56:51 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com> <201211121351.06023.arnd@arndb.de> <50A4C2C5.90306@synopsys.com>
In-Reply-To: <50A4C2C5.90306@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211151156.52033.arnd@arndb.de>
X-Provags-ID: V02:K0:r+pzAsSZUWDhIk52wZs/ODQ8oI3FagH7N/idkWSqFer
 sO4NSQ8r3zX3Llsefl8JywUpPq7NG4tqyBowNr5mz0j+AMKPYv
 vFNLHNqziUdep5E5lBc8Qigw9uDvyy8UZBU7h0nRmzb+dLN3Yq
 RI+Yl0BUfrDg35AXKaGPYTyEBuNLXbJnTr4BvrpIXZ25TGRjxG
 Gx9EGaKATAUws3dmaTICk8/hkQvTWOvnxLvlNLy0/XIukXQogE
 3JHmXoOfchNKTM4dn8/dxqTMHXlElgNbPWoVQbh8il/vAXfTSx
 jHd3fHRfnD8/eLqrqk2nIYfdAIE+eKDYcaoJUITViv9N+Hp6Ed
 XlOo54UI+4CFtqXx5f2E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 November 2012, Vineet Gupta wrote:
> On Monday 12 November 2012 07:21 PM, Arnd Bergmann wrote:
>
> > I think these should be moved into regsets, as we have done for all
> > other new architectures. Your arch_ptrace then becomes a trivial wrapper
> > around ptrace_request.
> 
> The regset stuff is already complete - and even this code uses the reget
> callbacks. It's just that we need to carry on this dual ABI for some
> time for our legacy gdbserver.

Ok, but please don't submit that patch upstream then. It's ok to
keep it in your own tree for the transitional phase, I assume
that you have other patches in there as well that are not submitted
yet. Once the new gdb is in use everywhere, you can just drop that
patch.

The problem with having this upstream is that this would create
a precedent for having the interface, and if people start relying
on it being there, we can't remove from upstream any more. If you
just have it in your private repository, we can just argue that it
was never officially supported.

	Arnd
