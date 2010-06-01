Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab0FAGk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 02:40:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:16248 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753647Ab0FAGkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 02:40:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,339,1272870000"; 
   d="scan'208";a="522828840"
Message-ID: <4C04AB6E.1080305@linux.intel.com>
Date: Tue, 01 Jun 2010 08:40:46 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>
CC: device-mapper development <dm-devel@redhat.com>,
       herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
       agk@redhat.com
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs
References: <20100531160425.GA20344@basil.fritz.box> <Pine.LNX.4.64.1005312239520.6372@hs20-bc2-1.build.redhat.com>
In-Reply-To: <Pine.LNX.4.64.1005312239520.6372@hs20-bc2-1.build.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

, Mikulas Patocka wrote:
> Questions:
>
> If you are optimizing it,
>
> 1) why don't you optimize it in such a way that if one CPU submits
> requests, the crypto work is spread among all the CPUs? Currently it
> spreads the work only if different CPUs submit it.

This case is only useful with very slow CPUs and is handled by pcrypt
in theory

(but I haven't tested it)

>
> 2) why not optimize software async crypto daemon (crypt/cryptd.c) instead
> of dm-crypt, so that all kernel subsystems can actually take advantage of
> those multi-CPU optimizations, not just dm-crypt?

Normally most subsystems are multi-CPU already, unless they limit
themselves artitifically like dm-crypt.

For dm-crypt would be wasteful to funnel everything through two single CPU threads just
to spread it out again.  That is why I also used per CPU IO threads too.

-Andi


