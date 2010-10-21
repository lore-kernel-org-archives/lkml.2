Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab0JUM6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 08:58:15 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:37547 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755742Ab0JUM6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 08:58:14 -0400
Date: Thu, 21 Oct 2010 13:58:09 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 8/9] MIPS: Honor L2 bypass bit
Message-ID: <20101021125809.GA15031@linux-mips.org>
References: <74b5d3ba9506b2e6d885546bd6dcdaec@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74b5d3ba9506b2e6d885546bd6dcdaec@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 08:05:42PM -0700, Kevin Cernekee wrote:

> On many of the newer MIPS32 cores, CP0 CONFIG2 bit 12 (L2B) indicates
> that the L2 cache is disabled and therefore Linux should not attempt
> to use it.

I did a bit of research in the meantime.  Turns out that some MIPS
customers are using their own L2 cache controller.  That means a simple
check by the CPU PrID is not sufficient and we will need some sort of
platform-specific probe, sigh.

I've moved all the code your patch adds to a separate function and added
a comment so at least people working on platforms with different L2
conntrollers will have a small chance of figuring out what mine blew up
under their feet.

  Ralf
