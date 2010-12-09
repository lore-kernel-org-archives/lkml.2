Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab0LIT7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 14:59:40 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37228
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756632Ab0LIT7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 14:59:39 -0500
Date: Thu, 09 Dec 2010 12:00:06 -0800 (PST)
Message-Id: <20101209.120006.189701386.davem@davemloft.net>
To: nicolas.ferre@atmel.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH] scatterlist: Initialize the dma_address field with
 invalid dma address
From: David Miller <davem@davemloft.net>
In-Reply-To: <1291900514-7290-1-git-send-email-nicolas.ferre@atmel.com>
References: <1291900514-7290-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>
Date: Thu,  9 Dec 2010 14:15:14 +0100

> Initialize the the dma_address field so that it will be possible to test
> its value while using scatterlists. This field will be compatible with
> testing by dma_mapping_error().
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Please don't do this, it's unjustified and it's going to kill performance.
Even if it were a good change, you should have used the invalid DMA
address definition defined by various architectures instead of a constant.

You should be aware of whether entries in a scatterlist have been setup
by your code path.
