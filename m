Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab1IVVTe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 17:19:34 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:16498 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab1IVVTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 17:19:32 -0400
Message-ID: <4E7BA661.7070903@cavium.com>
Date: Thu, 22 Sep 2011 14:19:29 -0700
From: David Daney <david.daney@cavium.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <greg@kroah.com>, Dilan Lee <dilee@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC PATCH v3] drivercore: Add driver probe deferral mechanism
References: <20110922184614.25419.84606.stgit@ponder> <20110922212909.49966cf4@lxorguk.ukuu.org.uk>
In-Reply-To: <20110922212909.49966cf4@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 22 Sep 2011 21:19:31.0214 (UTC) FILETIME=[51785AE0:01CC796D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2011 01:29 PM, Alan Cox wrote:
> Definitely what is needed for some of the x86 SoC stuff and would let us
> rip out some of the special case magic for the SCU discovery.
>
> First thing that strikes me is driver_bound kicks the processing queue
> again. That seems odd - surely this isn't needed because any driver that
> does initialise this time and may allow something else to get going will
> queue the kick itself. Thus this seems to just add overhead.
>

Do you mean explicitly kick the queue?

How would a given driver know that something else is waiting for it?  Or 
would we add the explicit kick to each and every driver in the tree?


> It all looks a bit O(N²) if we don't expect the drivers that might
> trigger something else binding to just say 'hey I'm one of the
> troublemakers'

I think it probably is O(N²), but N is small...



> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

