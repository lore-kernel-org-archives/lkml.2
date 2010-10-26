Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645Ab0JZJaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 05:30:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:36235 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754939Ab0JZJap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 05:30:45 -0400
Message-ID: <4CC69FBA.1010001@kernel.org>
Date: Tue, 26 Oct 2010 11:30:34 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.11) Gecko/20101013 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>, bphilips@suse.de
CC: Kernel development list <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@kernel.crashing.org>
Subject: Re: Adding more stuff to devres.
References: <AANLkTikx2TYO_NN91FzOq_0wxOJ_ggQVsxgOHNOpRom5@mail.gmail.com>
In-Reply-To: <AANLkTikx2TYO_NN91FzOq_0wxOJ_ggQVsxgOHNOpRom5@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 26 Oct 2010 09:30:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Brandon, Hi.

On 10/25/2010 05:52 PM, Alexey Zaytsev wrote:
> Would it be a good idea to get things other than resources managed by
> the devres?
> 
> In my probe() method, I still have to handle alloc_netdev() and
> mdiobus_alloc(). Adding corresponding devm_ functions should be
> trivial. So, should I prepare the patches, or is there something wrong
> with the approach?

Hmmm... Unless alloc_netdev() and mdiobus_alloc() are allocating
something special, I think it probably would be better to make them
use devres.  Please take a look at how ata_host_alloc() and
ata_host_start() are doing it.

IIRC, Brandon spent some time thinking about how use devres on network
drivers.  Brandon, any ideas?

Thanks.

-- 
tejun
