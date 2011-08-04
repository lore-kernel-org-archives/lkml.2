Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab1HDXc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 19:32:27 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46542 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685Ab1HDXc1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 19:32:27 -0400
MIME-Version: 1.0
In-Reply-To: <20110804162551.2b92b2cf@debxo>
References: <20110804162551.2b92b2cf@debxo>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Fri, 5 Aug 2011 00:32:06 +0100
Message-ID: <CAMPhdO_gC1vQEA6aMhS=4RaM2dNo9WYPPia1+juRH7q1T=E0Og@mail.gmail.com>
Subject: Re: [PATCH RFC v1] ARM: olpc: Add support for calling into the
 XO-1.75's OpenFirmware (OFW)
To: Andres Salomon <dilinger@queued.net>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Russell King <linux@arm.linux.org.uk>, Mitch Bradley <wmb@laptop.org>,
        "H. Peter Anvin" <hpa@zytor.com>, dsd@laptop.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 5, 2011 at 12:25 AM, Andres Salomon <dilinger@queued.net> wrote:
> Add support for saving OFW's cif, and later calling into it to run OFW
> commands from the kernel.  OFW remains resident in memory after boot,
> and the physical/virtual addresses are passed in a boot tag.  We parse
> that, and map the addresses.
>
> This is currently only used by the OLPC XO-1.75, so it's named olpc_ofw().
>
> Signed-off-by: Andres Salomon <dilinger@queued.net>
> ---
>  Documentation/arm/Setup                  |    2 +
>  arch/arm/Kconfig                         |    8 ++
>  arch/arm/include/asm/olpc_ofw.h          |   23 ++++++
>  arch/arm/include/asm/setup.h             |   24 ++++++
>  arch/arm/mach-mmp/Makefile               |    1 +
>  arch/arm/mach-mmp/include/mach/vmalloc.h |    2 +-
>  arch/arm/mach-mmp/olpc-xo-1-75.c         |    7 ++
>  arch/arm/mach-mmp/olpc_ofw.c             |  118 ++++++++++++++++++++++++++++++
>  8 files changed, 184 insertions(+), 1 deletions(-)
>  create mode 100644 arch/arm/include/asm/olpc_ofw.h
>  create mode 100644 arch/arm/mach-mmp/olpc_ofw.c
>
>
> I'm looking for input on our mechanism for calling into OLPC's openfirmware
> on arm.  Some of the x86 folks are cc'd
> as they had lots of comment when we did this for x86 OLPC machines.
>
> There's a device tree patch on top of this that can be seen here:
> http://dev.laptop.org/git/olpc-3.0/patch/?id=12377851f9a64a9e2098adf09f858bed7d3eae7c
>
> Unlike the XO-1, I'd like to get this OFW communication mechanism ACKed prior to
> OLPC's mass production of these units.

Not really sure if it's the standard way of calling back into GFW, Grant?
