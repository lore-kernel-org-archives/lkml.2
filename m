Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab1CPDEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 23:04:06 -0400
Received: from waste.org ([173.11.57.241]:37735 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456Ab1CPDD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 23:03:59 -0400
Subject: Re: [PATCH 2/8] drivers/char/random: Split out __get_random_int
From: Matt Mackall <mpm@selenic.com>
To: George Spelvin <linux@horizon.com>
Cc: penberg@cs.helsinki.fi, herbert@gondor.hengli.com.au, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110316022804.27682.qmail@science.horizon.com>
References: <20110316022804.27682.qmail@science.horizon.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Mar 2011 22:03:56 -0500
Message-ID: <1300244636.3128.426.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-03-13 at 20:57 -0400, George Spelvin wrote:
> The unlocked function is needed for following work.
> No API change.

As I mentioned last time this code was discussed, we're already one
crypto-savvy attacker away from this code becoming a security hole. 
We really need to give it a serious rethink before we make it look
anything like a general-use API. 

And you've got it backwards here: __ should be the unlocked, dangerous
version. But the locked version already has a __ because it's already
dangerous.

-- 
Mathematics is the supreme nostalgia of our time.


