Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316Ab0JJGC2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 02:02:28 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43942 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab0JJGC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 02:02:27 -0400
MIME-Version: 1.0
In-Reply-To: <1285739538-29058-1-git-send-email-monstr@monstr.eu>
References: <1285739538-29058-1-git-send-email-monstr@monstr.eu>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 10 Oct 2010 00:02:06 -0600
X-Google-Sender-Auth: BET8p2dvYU92iWwtiUpzRoRpZZE
Message-ID: <AANLkTinTgO_kk=gcd50UQnwsm47fwyOX3BbGhJ1pPxUP@mail.gmail.com>
Subject: Re: Microblaze little-endian port + driver changes
To: Michal Simek <monstr@monstr.eu>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, john.williams@petalogix.com,
        edgar.iglesias@gmail.com, duyl@xilinx.com, linnj@xilinx.com,
        microblaze-uclinux@itee.uq.edu.au
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 11:52 PM, Michal Simek <monstr@monstr.eu> wrote:
> Hi everybody,
>
> here is the first bunch of patches which is necessary to apply
> to get microblaze little-endian AXI version work.
>
> All patches are placed in microblaze-next branch and they are also
> merged to linux-next branch.
>
> Grant: I would like to ask you if you can please take a look
> at little-endian driver changes.

[cc'ing sfr re: pending linux-next merge conflict]

Hi Michal,

Can you please remove the following patches from your linux-next branch:

of: GPIO: Fix OF probing on little-endian systems
of: MTD: Fix OF probing on little-endian systems
of: Fix uart16550 initialization on little-endian systems

The emaclite patch can stay since it has a proper acked-by from both
davem and I.

I had picked up all three, and then later replaced the of_serial patch
with a better one. However, because it is also in your tree it will
cause a linux-next conflict when Stephen tries to merge.

For device tree patches that touch code outside of arch/microblaze, I
would like them to not show up in linux-next before I've acked them to
avoid this exact problem.  I don't have a problem with device tree
patches going in via another tree, but I need to know about it so that
I can keep things coordinated.

Stephen, when/if you see the conflict, please take the copy of
of_serial.c from my tree.

Thanks,
g.
