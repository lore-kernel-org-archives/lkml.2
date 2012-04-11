Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab2DKJ6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 05:58:35 -0400
Received: from mail.secomea.com ([130.226.208.142]:1117 "EHLO mail.secomea.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846Ab2DKJ6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 05:58:34 -0400
X-Greylist: delayed 507 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Apr 2012 05:58:34 EDT
Message-ID: <4F8553BF.6030303@secomea.com>
Date: Wed, 11 Apr 2012 11:49:51 +0200
From: =?ISO-8859-1?Q?Svenning_S=F8rensen?= <sss@secomea.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: Bjarke Istrup Pedersen <gurligebis@gentoo.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andreas Mohr <andi@lisas.de>
Subject: Re: via-rhine: Problem with lost link after a while
References: <CACPM=kWa=UWuCMaYAtVMGJ7pzCy-PfyNRWBSuJnTZGtssU0W6g@mail.gmail.com> <20120410204249.GA26627@electric-eye.fr.zoreil.com> <CACPM=kWsU8QZOHqwEThTQCuSSvaTDoxO1d17EyoW=+kx8QG3vw@mail.gmail.com> <20120410225534.GA28480@electric-eye.fr.zoreil.com>
In-Reply-To: <20120410225534.GA28480@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11-04-2012 00:55, Francois Romieu wrote:
> Bjarke Istrup Pedersen<gurligebis@gentoo.org>  :
>
> [...]
>> Great, I'll try a 3.4-rc2 kernel, and see how it runs.
>>
>> The thread I was talking about earlier is here:
>> http://lists.soekris.com/pipermail/soekris-tech/2012-April/018318.html
>> Is there any of the changes he has there, that makes sense in the new
>> driver you wrote ?
> (I did not write a new driver)
>
> Regarding Svenning's patch:
> - the wmb in alloc_rbufs may help rhine_reset_task().
> - one should probably add one in rhine_rx() as well.
> - rhine_start_tx() is supposed to stop queueing when there is no room left.
>    I'm curious to know if the "Tx descriptor busy" test triggered.
> - the rmb() in rhine_tx() will not make a difference for a single core but
>    it's a good reminder that I should not have forgotten to propagate the
>    xmit / Tx completion fix back from the r8169 driver to the via-rhine one
>    (sigh)
>
> mmiowb is probably missing. I doubt it hits hard right now.
>
> I have not checked if MMIO flushes are missing. Actually I need some sleep.
>

Regarding the "Tx descriptor busy" test: no, I didn't see it trigger, I 
just put it there just in case because I suspected there could be a race 
due to the lock-free tx path.
But I'm glad if you're confident that it can't happen :)

Svenning
