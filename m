Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432Ab2BXWuN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 17:50:13 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:40874 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab2BXWuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 17:50:11 -0500
Date: Fri, 24 Feb 2012 17:50:06 -0500 (EST)
Message-Id: <20120224.175006.1161090053765926485.davem@davemloft.net>
To: santoshprasadnayak@gmail.com
Cc: benve@cisco.com, roprabhu@cisco.com, neepatel@cisco.com,
        nistrive@cisco.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2] enic: Silence Sparse Warning: "dubious: x | !y"
From: David Miller <davem@davemloft.net>
In-Reply-To: <1330102654-2474-1-git-send-email-santoshprasadnayak@gmail.com>
References: <1330102654-2474-1-git-send-email-santoshprasadnayak@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 24 Feb 2012 14:50:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: santosh nayak <santoshprasadnayak@gmail.com>
Date: Fri, 24 Feb 2012 22:27:34 +0530

> From: Santosh Nayak <santoshprasadnayak@gmail.com>
> 
> Sparse is giving the following warning:
> "warning: dubious: x | !y"
> 
> "enic_are_pp_different" is static and expected to return true or false.
> Logical or is indended here. With logical or, in best case, execution will be
> faster because if leftmost operand is true then no need to check other operands.
> 
> Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>

As others have explained, this code is intentional.  It's faster because
the resulting code has less branches and therefore less potential
branch mispredictions.
