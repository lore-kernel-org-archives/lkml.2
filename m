Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab0FGCbK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 22:31:10 -0400
Received: from sh.osrg.net ([192.16.179.4]:49323 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755037Ab0FGCbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 22:31:08 -0400
Date: Mon, 7 Jun 2010 11:30:48 +0900
To: mitov@issp.bas.bg
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG][PATCH]dma-coherent.c: error path bug
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <201006061353.05310.mitov@issp.bas.bg>
References: <201006061353.05310.mitov@issp.bas.bg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100607113001S.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 07 Jun 2010 11:30:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jun 2010 13:53:04 +0300
Marin Mitov <mitov@issp.bas.bg> wrote:

> Hi all,
> 
> The error path in dma_declare_coherent_memory() leaves 
> the pointer dev->dma_mem non completely initialized.
> 
> If allocation of dev->dma_mem succeeds, 
> but allocation of dev->dma_mem->bitmap fails
> dev->dma_mem is freed, but left non NULL
> and non completely initialized.
> 
> Either zero it after being freed (one liner patch), or assign to 
> dev->dma_mem only completely initialized structure (patch included).
> 
> Comments welcome.
> 
> Marin Mitov
> 
> Signed-off-by: Marin Mitov <mitov@issp.bas.bg>

Hmm, if dma_declare_coherent_memory() fails, the driver doesn't use
dev->dma_mem. So even if dev->dma_mem points to a freed memory, I'm
not sure that it causes a real problem. We could call this patch a
cleanup though.
