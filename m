Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab2K2QeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 11:34:21 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45519 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab2K2QeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 11:34:20 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2] drivers/of: Constify device_node->name and ->path_component_name
To: Michael Neuling <mikey@neuling.org>
Cc: Jimi Xenidis <jimix@pobox.com>, sfr@canb.auug.org.au,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, sparclinux@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S. Miller" <davem@davemloft.net>,
        Julian Calaby <julian.calaby@gmail.com>
In-Reply-To: <23435.1354059964@neuling.org>
References: <1353075625-7755-1-git-send-email-grant.likely@secretlab.ca> <23435.1354059964@neuling.org>
Date: Thu, 29 Nov 2012 16:34:16 +0000
Message-Id: <20121129163416.7CC4F3E0A04@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2012 10:46:04 +1100, Michael Neuling <mikey@neuling.org> wrote:
> > Neither of these should ever be changed once set. Make them const and
> > fix up the users that try to modify it in-place. In one case
> > kmalloc+memcpy is replaced with kstrdup() to avoid modifying the string.
> > 
> > Build tested with defconfigs on ARM, PowerPC, Sparc, MIPS, x86 among
> > others.
> 
> Grant,
> 
> This breaks powerpc chroma_defconfig in next-20121127 with:
> 
> arch/powerpc/sysdev/scom.c:160:17: error: assignment discards 'const' qualifier from pointer target type [-Werror]
> 
> The following fixes it.  The change is to generic code, so I'm not sure
> it's the right fix as it may break other configs/archs.

That is rather risky. Post it as a patch to core code, but in the mean
time I'll patch the powerpc scom code.

g.

