Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab2IBGr7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 02:47:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45777 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab2IBGr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 02:47:57 -0400
MIME-Version: 1.0
In-Reply-To: <FD18E5D573A8AB48A365D4D78185DE992E5C0D@039-SN1MPN1-001.039d.mgd.msft.net>
References: <1344500448-10927-1-git-send-email-qiang.liu@freescale.com>
	<FD18E5D573A8AB48A365D4D78185DE992E5C0D@039-SN1MPN1-001.039d.mgd.msft.net>
Date: Sat, 1 Sep 2012 23:47:56 -0700
Message-ID: <CAA9_cmc3y5fix=QrqPEOhD5TP=4MEOmv_V5OaJcsPXmCAha-Rg@mail.gmail.com>
Subject: Re: [PATCH v7 1/8] Talitos: Support for async_tx XOR offload
From: Dan Williams <dan.j.williams@gmail.com>
To: Geanta Neag Horia Ioan-B05471 <B05471@freescale.com>
Cc: Liu Qiang-B32616 <B32616@freescale.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.hengli.com.au" <herbert@gondor.hengli.com.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Li Yang-R58472 <r58472@freescale.com>,
        Phillips Kim-R1AAHA <R1AAHA@freescale.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 7:23 AM, Geanta Neag Horia Ioan-B05471
<B05471@freescale.com> wrote:
>
> Besides these:
> 1. As Dan Williams mentioned, you should explain why you are using
> both spin_lock_bh and spin_lock_irqsave on the same lock.

It looks like talitos_process_pending() can be called from hardirq
context via talitos_error().  So spin_lock_bh is not sufficient.
