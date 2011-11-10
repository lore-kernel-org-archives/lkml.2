Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934739Ab1KJOEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 09:04:24 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:7286 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab1KJOEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 09:04:22 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4EBBD9DF.6080100@freescale.com>
Date: Thu, 10 Nov 2011 08:04:15 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: Kyle Moffett <Kyle.D.Moffett@boeing.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Baruch Siach <baruch@tkos.co.il>,
        Kumar Gala <galak@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Anatolij Gustschin <agust@denx.de>, Paul Bolle <pebolle@tiscali.nl>,
        Sonny Rao <sonnyrao@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 02/17] powerpc: Split up PHYS_64BIT config option
 to fix "select" issues
References: <4E42AB6F.1050900@freescale.com> <1320883635-17194-3-git-send-email-Kyle.D.Moffett@boeing.com>
In-Reply-To: <1320883635-17194-3-git-send-email-Kyle.D.Moffett@boeing.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
>   CONFIG_PHYS_64BIT_SUPPORTED:
>     This hidden option should be selected by any CPU type which supports
>     64-bit physical addresses.  This will enable the PHYS_64BIT option
>     to be selected.  It is (obviously) always set on PPC64.
> 
>   CONFIG_PHYS_64BIT_DT_REQUIRED:
>     This hidden option should be selected by any board or platform which
>     has >32-bit physical devices present in hardware.  If this is set
>     then the CONFIG_PHYS_64BIT option will be forcibly enabled and
>     hidden from the user.  It is (obviously) always set on PPC64.
> 
>   CONFIG_PHYS_64BIT:
>     This option is user-controllable, where allowed by CPU and platform
>     settings, and should never be pointed at with a "select" statement.
>     Due to the values of the above two options, this is never visible on
>     PPC64.

I'm with Kumar on this.  I don't see the point of making it so complicated.  No kernel should ever have to care with a DT is 64-bit or 32-bit.  If you build a kernel with 64-bit phys support, then it will work with any DT.

U-Boot already warns you if the DT and the actual physical addresses of the devices don't match.

There are only two reasons to create a 32-bit kernel:

1) A small performance improvement on systems with 2GB or less.
2) Some SOC devices only support 32-bit physical addresses, so the easiest way to ensure a compatible address is to prohibit memory above 4GB.

Item #2 is not something that we really worry about.  It's only a real problem on true 64-bit kernels, and in those cases, we cannot build a kernel with 32-bit phys support, so the driver needs to handle it internally.

-- 
Timur Tabi
Linux kernel developer at Freescale

