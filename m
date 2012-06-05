Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab2FEWVF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 18:21:05 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58924 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab2FEWVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 18:21:04 -0400
Date: Tue, 05 Jun 2012 15:20:58 -0700 (PDT)
Message-Id: <20120605.152058.828742127223799137.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: r65777@freescale.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, galak@kernel.crashing.org,
        bharat.bhushan@freescale.com
Subject: Re: [PATCH] powerpc: Fix assmption of end_of_DRAM() returns end
 address
From: David Miller <davem@davemloft.net>
In-Reply-To: <1338934659.7150.113.camel@pasglop>
References: <1338904504-2750-1-git-send-email-bharat.bhushan@freescale.com>
	<1338934659.7150.113.camel@pasglop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Wed, 06 Jun 2012 08:17:39 +1000

> On Tue, 2012-06-05 at 19:25 +0530, Bharat Bhushan wrote:
>> memblock_end_of_DRAM() returns end_address + 1, not end address.
>> While some code assumes that it returns end address.
> 
> Shouldn't we instead fix it the other way around ? IE, make
> memblock_end_of_DRAM() does what the name implies, which is to return
> the last byte of DRAM, and fix the -other- callers not to make bad
> assumptions ?

That was my impression too when I saw this patch.
