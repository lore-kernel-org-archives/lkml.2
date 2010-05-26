Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638Ab0EZSoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 14:44:14 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41442 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab0EZSoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 14:44:13 -0400
Date: Wed, 26 May 2010 19:43:58 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, Julia Lawall <julia@diku.dk>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 7/17] arch/arm/common: Add missing
	spin_unlock_irqrestore
Message-ID: <20100526184358.GC6232@n2100.arm.linux.org.uk>
References: <Pine.LNX.4.64.1005261756000.23743@ask.diku.dk> <201005261907.06198.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005261907.06198.marek.vasut@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 07:07:06PM +0200, Marek Vasut wrote:
> Why are "readl"s protected by spinlock anyway ? Can't we just move the locking 
> past the code above ?

Good question - and there seems to be a deadlock waiting to happen -
sa1111_wake() re-takes the same lock.

I think we should kill all the spinlock in sa1111_resume().
