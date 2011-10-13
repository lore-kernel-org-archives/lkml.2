Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab1JMOhX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 10:37:23 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:9858
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753262Ab1JMOhW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 10:37:22 -0400
X-SpamScore: -12
X-BigFish: VS-12(zz9371K1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>
CC: "hjk@hansjkoch.de" <hjk@hansjkoch.de>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        Jiang Kai-B18973 <B18973@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][v2] uio: Support 36-bit physical addresses on 32-bit
 systems
Thread-Topic: [PATCH][v2] uio: Support 36-bit physical addresses on 32-bit
 systems
Thread-Index: AQHMibWb+QoiIE1b5kKN3zEc18M0tw==
Date: Thu, 13 Oct 2011 14:37:17 +0000
Message-ID: <CAOZdJXWd_u_EWXNhh3-t258+Y8mx=JuJhU93CeZfaocPZvhOFA@mail.gmail.com>
References: <1318453063-17349-1-git-send-email-galak@kernel.crashing.org>
In-Reply-To: <1318453063-17349-1-git-send-email-galak@kernel.crashing.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.17.22.104]
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <EF87DB870E893A4885D1DB4DB7831664@freescale.net>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 3:57 PM, Kumar Gala <galak@kernel.crashing.org> wrote:
> From: Kai Jiang <Kai.Jiang@freescale.com>
>
> To support >32-bit physical addresses for UIO_MEM_PHYS type we need to
> extend the width of 'addr' in struct uio_mem.  Numerous platforms like
> embedded PPC, ARM, and X86 have support for systems with larger physical
> address than logical.
>
> Since 'addr' may contain a physical, logical, or virtual address the
> easiest solution is to just change the type to 'unsigned long long'
> regardless of which type is utilized.

You forgot to update this description.

>  struct uio_mem {
>        const char              *name;
> -       unsigned long           addr;
> +       phys_addr_t             addr;

Please add a comment here saying:

1) That 'addr' can be a virtual or physical address
2) That the kernel guarantees that sizeof(phys_addr_t) >= sizeof(void
*), so it's safe to use phys_addr_t for a virtual pointer.

-- 
Timur Tabi
Linux kernel developer at Freescale
