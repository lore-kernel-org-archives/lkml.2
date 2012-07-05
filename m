Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381Ab2GEQHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 12:07:52 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43105 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984Ab2GEQHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 12:07:51 -0400
Message-ID: <4FF5BBD3.6080704@wwwdotorg.org>
Date: Thu, 05 Jul 2012 10:07:47 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: mturquette@ti.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: Fix cached parent ptrs allocation
References: <1341407737-1016-1-git-send-email-pgaikwad@nvidia.com>
In-Reply-To: <1341407737-1016-1-git-send-email-pgaikwad@nvidia.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2012 07:15 AM, Prashant Gaikwad wrote:
> Compiler optimizes code someway that even if clk->parents
> is not NULL it tries to allocate parents array. Change the
> condition so that compiler does not optimize it in wrong
> way.

If simply inverting the if test and swapping the if/else blocks solves
some problem, that sounds like a compiler bug that we need to track down
and file/fix.

> Also, initialize i to num_parents to make sure parent
> is searched using parent name if parents is NULL.

Are you sure the change to initialize i wasn't all that was required to
solve the problem though? Mike has applied a patch for this that'll be
applied to 3.5-rcX and hence trickle into 3.6.
