Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab1CNKk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 06:40:58 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42182 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab1CNKk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 06:40:56 -0400
Date: Mon, 14 Mar 2011 10:40:38 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        tony@atomide.com, nicolas.pitre@linaro.org, joe@perches.com,
        Po-Yu Chuang <ratbert@faraday-tech.com>
Subject: Re: [PATCH] arm: cmpxchg syscall should data abort if page not
	write or not young
Message-ID: <20110314104038.GB26085@n2100.arm.linux.org.uk>
References: <1300098516-1601-1-git-send-email-ratbert.chuang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300098516-1601-1-git-send-email-ratbert.chuang@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 06:28:36PM +0800, Po-Yu Chuang wrote:
> From: Po-Yu Chuang <ratbert@faraday-tech.com>
> 
> If the page to cmpxchg is user mode read only (not write)
> or invalid (not young), we should simulate a data abort first.

No.  If it is not young then it should be made young.  Age is an effect
of accesses.  It's not a permission.
