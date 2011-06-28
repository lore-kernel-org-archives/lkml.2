Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab1F1AZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 20:25:24 -0400
Received: from mail.candelatech.com ([208.74.158.172]:47029 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524Ab1F1AYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 20:24:14 -0400
Message-ID: <4E091F2B.4060607@candelatech.com>
Date: Mon, 27 Jun 2011 17:24:11 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 2/2] slub:  Add method to verify memory is not deleted.
References: <1309216631-31493-1-git-send-email-greearb@candelatech.com> <1309216631-31493-3-git-send-email-greearb@candelatech.com> <alpine.DEB.2.00.1106271622510.24211@chino.kir.corp.google.com> <4E091670.9040405@candelatech.com> <alpine.DEB.2.00.1106271718340.29910@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1106271718340.29910@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2011 05:19 PM, David Rientjes wrote:
> On Mon, 27 Jun 2011, Ben Greear wrote:
>
>> I saw a case where xprt was 0x6b6b6b6b.  I'm trying to figure out
>> what freed it.
>
> And echo 1>  /sys/kernel/slab/<cache>/store_user doesn't help?

That gives one method, right?  The rpc stuff is freed at the bottom of a
complicated callback chain, and the interesting stuff is what caused the memory
to be freed, not the actually free method.

In previous network (ath9k) hacking I had the same trouble..I think for most
cases you need a full or mostly full stack to make use of the slub
debug logic.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

