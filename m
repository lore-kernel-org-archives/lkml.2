Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614Ab0FBHwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 03:52:09 -0400
Received: from mga06.intel.com ([134.134.136.21]:51074 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753380Ab0FBHwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 03:52:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,346,1272870000"; 
   d="scan'208";a="523208739"
Message-ID: <4C060D9F.3050600@linux.intel.com>
Date: Wed, 02 Jun 2010 09:51:59 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>
CC: Herbert Xu <herbert@gondor.hengli.com.au>,
       device-mapper development <dm-devel@redhat.com>,
       linux-kernel@vger.kernel.org, agk@redhat.com
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs
References: <20100531160425.GA20344@basil.fritz.box> <Pine.LNX.4.64.1005312239520.6372@hs20-bc2-1.build.redhat.com> <20100601043901.GA25693@gondor.apana.org.au> <Pine.LNX.4.64.1006020051540.22695@hs20-bc2-1.build.redhat.com> <20100602051403.GA5784@gondor.apana.org.au> <Pine.LNX.4.64.1006020119540.22695@hs20-bc2-1.build.redhat.com>
In-Reply-To: <Pine.LNX.4.64.1006020119540.22695@hs20-bc2-1.build.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>
>>> It is pointless to track the submitting CPU.
>>
>> No you are wrong.
>
> For what? For avoiding cache bounces? But the encrypting is
> order-of-magnitude slower than memory speed.

On a system with reasonably fast CPUs it's fastest to just stay
on your current CPU, don't try to talk to other CPUs, avoid
communication, just get the work done ASAP. But make
sure you can do this on multiple CPUs at the same time.

With AES-NI this becomes even more pronounced because it effectively
makes the CPU faster for encryption.

-andi
