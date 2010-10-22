Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886Ab0JVTxo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:53:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755904Ab0JVTxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:53:43 -0400
Date: Fri, 22 Oct 2010 12:53:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pca953x: pca953x driver fixes for x86 mrst
Message-Id: <20101022125306.ace6ca55.akpm@linux-foundation.org>
In-Reply-To: <20101022124716.19975.12805.stgit@localhost.localdomain>
References: <20101022124716.19975.12805.stgit@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010 13:47:47 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> From: Alek Du <alek.du@intel.com>
> 
> Our Moorestown platform has two max7315 chips which is covered by
> pca953x i2c gpio driver.
> 
> A while ago this driver got updated with nested irq thread support, and it
> broke the compatibity with "request_irq". For example, the gpio_keys.c
> driver can not work with this driver now. This patch fixes the issue by
> switching to generic_handle_irq.
> 
> Also fix the irq_base issue: irq_base == 0 is valid, and a "-1" value
> should mean invalid. IRQ 0 is not a valid IRQ, irq_base of 0 is valid.

This sounds like a regression fix.  Should it be backported into
-stable?

