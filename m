Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab0IVUmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 16:42:40 -0400
Received: from smtp106.sbc.mail.mud.yahoo.com ([68.142.198.104]:46594 "HELO
	smtp106.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753964Ab0IVUmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 16:42:39 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: h.Y46J4VM1mq_A1V04SkWRtKF2rCSAF7CwHgVJjfvfp_7rx
 TABeAaI0Sr2hWo.mn1fN_OKg4XwZ5sMn8Kp53aDWvugk8Uq7BhScSn9U3M4L
 KDebBLlYHWc2Pw4uDqoxBavrm0x_yiB1jNAn7Ek6mTfo9xw3VJeQEO5bv6M1
 H4oT6AJA77Oq4Z1JW0ol5noyU2fmZHsD4zJmO3oiEQBXC2vb.lM9egJfbAq7
 p5bEdu5aH0qT2yexJYWKuh7NB9IgYFqh_3K5XjmJmCdxHWnodsxvxqn3BcME
 IW5zPrCO8o6Yf1rqedPGRxz9xPTpkhKVRAOrHZmZDSMLnwrpVCIYu7Jo_eNa
 GFOYHDydS9k.LTcjFRRM-
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [PATCH 2/2] siw: Add support for CRC32C offload instruction
	using libcrypto crc32c-intel
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Bernard Metzler <BMT@zurich.ibm.com>,
        David Miller <davem@davemloft.net>,
        Matthew Wilcox <willy@linux.intel.com>,
        Roland Dreier <rdreier@cisco.com>
In-Reply-To: <4C9A698B.90806@linux.intel.com>
References: <1285187425-10950-1-git-send-email-nab@linux-iscsi.org>
	 <4C9A698B.90806@linux.intel.com>
Content-Type: text/plain
Date: Wed, 22 Sep 2010 13:38:21 -0700
Message-Id: <1285187901.1849.85.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-22 at 22:39 +0200, Andi Kleen wrote:
> On 9/22/2010 10:30 PM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger<nab@linux-iscsi.org>
> >
> > This patch updates siw_create_qp() to check for the CONFIG_X86 + cpu_has_xmm4_2
> > dependent use of the CRC32C instruction offload using libcrypto crc32c-intel.ko.
> > This patch will by default use crc32c-intel when available, and fall back to the
> > legacy slicing by 1x libcrypto crc32c.ko code when the instruction offload is not
> > availabe.
> 
> I don't think every caller should handle checks like this. The crypto 
> layer should load the right driver
> instead and provide the best driver under a generic algorithm name.
> 

Indeed, this would clean up the explict RX/TX CRC32C case quite a bit..
Unfortuately I am too busy with other items atm to cook up this patch,
but I would be happy to test it if someone wants to take it.  ;)

> Need CPUID module auto probing. I have an older patch that needs some fixes.
> 

Hmm, I don't see how that fits in here exactly.  Would you mind
elaborating a bit..?

Thanks!

--nab


