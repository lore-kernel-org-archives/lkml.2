Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843Ab2HVPHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 11:07:17 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:30581
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932678Ab2HVPHH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 11:07:07 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VS4(zz98dI9371I78fbmzz1202hzz8275bhz2dh2a8h668h839h8e2h8e3hd25hf0ah107ahbe9i1155h)
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Tiejun Chen <tiejun.chen@windriver.com>
CC: "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "jason.wessel@windriver.com" <jason.wessel@windriver.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] powerpc: Bail out of KGDB when we've been triggered
Thread-Topic: [PATCH 2/3] powerpc: Bail out of KGDB when we've been triggered
Thread-Index: AQHNgHfHPfqz5vKODkm0m2GxH8E0Ew==
Date: Wed, 22 Aug 2012 15:07:00 +0000
Message-ID: <6AE080B68D46FC4BA2D2769E68D765B7059AE7E7@039-SN2MPN1-022.039d.mgd.msft.net>
References: <1345632192-19810-1-git-send-email-tiejun.chen@windriver.com>
	<1345632192-19810-2-git-send-email-tiejun.chen@windriver.com>
In-Reply-To: <1345632192-19810-2-git-send-email-tiejun.chen@windriver.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [70.112.118.223]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <6AAA1B076287954CAAD6A9E7C7F49D88@mgd.freescale.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 5:43 AM, Tiejun Chen <tiejun.chen@windriver.com> wrote:

> +int kgdb_skipexception(int exception, struct pt_regs *regs)
> +{
> +       if (kgdb_isremovedbreak(regs->nip))
> +               return 1;
> +
> +       return 0;
> +}

int kgdb_skipexception(int exception, struct pt_regs *regs)
{
        return !!kgdb_isremovedbreak(regs->nip));
}

If the caller only cares about zero vs. non-zero, you can drop the !!.

-- 
Timur Tabi
Linux kernel developer at Freescale
