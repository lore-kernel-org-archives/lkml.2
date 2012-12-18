Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab2LRWKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 17:10:35 -0500
Received: from [213.199.154.142] ([213.199.154.142]:35119 "EHLO
	db3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755347Ab2LRWKe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 17:10:34 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dI9371Izz1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839h8e2h8e3h947hd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758hbe9i1155h)
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Tiejun Chen <tiejun.chen@windriver.com>
CC: "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "jason.wessel@windriver.com" <jason.wessel@windriver.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] powerpc/book3e: load critical/machine/debug
 exception stack
Thread-Topic: [PATCH 1/3] powerpc/book3e: load critical/machine/debug
 exception stack
Thread-Index: AQHN3WxsQXDGFOT7pEKzD6fGIvb/gQ==
Date: Tue, 18 Dec 2012 22:10:01 +0000
Message-ID: <6AE080B68D46FC4BA2D2769E68D765B7081D305D@039-SN2MPN1-023.039d.mgd.msft.net>
References: <1351147410-17452-1-git-send-email-tiejun.chen@windriver.com>
In-Reply-To: <1351147410-17452-1-git-send-email-tiejun.chen@windriver.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [70.112.99.80]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <1DC2418650335241AAA492FB90299DF1@mgd.freescale.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 1:43 AM, Tiejun Chen <tiejun.chen@windriver.com> wrote:
> We always alloc critical/machine/debug check exceptions. This is
> different from the normal exception. So we should load these exception
> stack properly like we did for booke.

Tiejun,

I'm a little confused by these patches, because the actual critical
exception handlers are still commented out:

/* Critical Input Interrupt */
	START_EXCEPTION(critical_input);
	CRIT_EXCEPTION_PROLOG(0x100, BOOKE_INTERRUPT_CRITICAL,
			      PROLOG_ADDITION_NONE)
//	EXCEPTION_COMMON(0x100, PACA_EXCRIT, INTS_DISABLE)
//	bl	special_reg_save_crit
//	CHECK_NAPPING();
//	addi	r3,r1,STACK_FRAME_OVERHEAD
//	bl	.critical_exception
//	b	ret_from_crit_except
	b	.

Are you working on fixing this?  I'm trying to fix it, too, but I
think you're way ahead of me.

-- 
Timur Tabi
Linux kernel developer at Freescale
