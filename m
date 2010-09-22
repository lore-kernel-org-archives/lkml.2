Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab0IVVE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 17:04:59 -0400
Received: from smtp104.sbc.mail.gq1.yahoo.com ([67.195.15.63]:31844 "HELO
	smtp104.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753150Ab0IVVE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 17:04:57 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: QZa2G4gVM1mtp7hsOTuBjRkNtRxGfn3lkzJPBcR._4V_FeN
 34pTGeowGQ87OkLyjJdys97lVfqhKl3RNXuQevgeDw_RHEQPCa8JAhW.l7i6
 YfsUWGTJoKPZu86wW7ZfHMQb_AeqEvJUXMpnRETgShOsEY1oGiq.UpTwRF21
 Txf2mUQIKkZQmstwod7EH_WGuaHzzZShOPA1MYxEcmtXRszTRFUfPzqr0yVo
 oP0cPxjvr4qHo5zhNQHBil2Ml1OcNf781dntVG1V2CGGXsiP8TtNFY2V_IbR
 AHQihRw9QOExrtgQu5DI7l7w-
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [PATCH 2/2] siw: Add support for CRC32C offload instruction
	using libcrypto crc32c-intel
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Andi Kleen <ak@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Bernard Metzler <BMT@zurich.ibm.com>,
        David Miller <davem@davemloft.net>,
        Matthew Wilcox <willy@linux.intel.com>,
        Roland Dreier <rdreier@cisco.com>
In-Reply-To: <20100922205943.GI11157@obsidianresearch.com>
References: <1285187425-10950-1-git-send-email-nab@linux-iscsi.org>
	 <4C9A698B.90806@linux.intel.com>
	 <1285187901.1849.85.camel@haakon2.linux-iscsi.org>
	 <20100922205943.GI11157@obsidianresearch.com>
Content-Type: text/plain
Date: Wed, 22 Sep 2010 14:00:41 -0700
Message-Id: <1285189241.1849.112.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-22 at 14:59 -0600, Jason Gunthorpe wrote:
> On Wed, Sep 22, 2010 at 01:38:21PM -0700, Nicholas A. Bellinger wrote:
> 
> > Indeed, this would clean up the explict RX/TX CRC32C case quite a
> > bit..  Unfortuately I am too busy with other items atm to cook up
> > this patch, but I would be happy to test it if someone wants to take
> > it.  ;)
> 
> Do you even need to do anything at all? crc32c is provided by
> crc32c-intel at a higher priority already, so it should be used if it
> is available..

I believe with the current libcrypto code that consumers are still
required to explictly ask for crc32c-intel offload.

>  
> > > Need CPUID module auto probing. I have an older patch that needs
> > > some fixes.
> 
> > Hmm, I don't see how that fits in here exactly.  Would you mind
> > elaborating a bit..?
> 
> Unless the module is loaded the optimized algorithm will not be
> available for automatic use. Maybe your patch causes it to autoload
> because of the by-name reference? Identifying modules to load by CPUID
> will let userspace auto load the appropriate ones based on CPU...
> 

Correct, this patch is so that autoload of crc32c-intel.ko 'just works'
and we do the fallback to the legacy slicing by 1x crc32c.ko when the
former is not availabe.

But I definately agree with Andi here that we should just add a wrapper
around the crypto_alloc_hash() usage of crc32c-intel and crc32c for
libcrypto consumers..

Thanks for your comments Jason!

--nab


