Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab0GFHPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 03:15:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48205
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753944Ab0GFHPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 03:15:54 -0400
Date: Tue, 06 Jul 2010 00:16:07 -0700 (PDT)
Message-Id: <20100706.001607.186316276.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: dilinger@queued.net, devicetree-discuss@lists.ozlabs.org,
       sparclinux@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, cjb@laptop.org, wmb@laptop.org,
       pgf@laptop.org, linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [PATCH 2/4] sparc: break out some prom device-tree building
 code out into drivers/of
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTil3aZ0IF1KEc2h9MLHPZYW23pnWzEy4IiVb3zxT@mail.gmail.com>
References: <20100707040734.05d625af@debxo>
	<20100705.192221.241453945.davem@davemloft.net>
	<AANLkTil3aZ0IF1KEc2h9MLHPZYW23pnWzEy4IiVb3zxT@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 6 Jul 2010 01:00:06 -0600

> I'm curious... what are your plans here?  Will you be keeping OF alive
> between kexec()?  Will the new kernel get the entire device tree from
> fdt, or will it still be talking to OF?  How will the fdt fragments as
> Andres described above fit into sparc kexec (as opposed to generating
> one big tree as in his first option)?

On certain sparc64 systems, I have to stop making PROM calls early
in the boot right after I fetch the device tree into the kernel.

So yes for a kexec() I'll have to pass an fdt or similar to the
child kernel.

It could be a big linear fdt buffer, or fragments, it really doesn't
matter all that much actually.
