Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422685Ab2JaKfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 06:35:42 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13164 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035Ab2JaKfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 06:35:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 31 Oct 2012 03:35:37 -0700
Message-ID: <5090FE97.7070303@nvidia.com>
Date: Wed, 31 Oct 2012 16:03:59 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] regulator: core: Move regulator release to avoid deadlock
References: <20121029093333.GA17941@opensource.wolfsonmicro.com> <20121029161416.GE4511@opensource.wolfsonmicro.com>
In-Reply-To: <20121029161416.GE4511@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 October 2012 09:44 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Mon, Oct 29, 2012 at 09:33:33AM +0000, Charles Keepax wrote:
>> regulator_put function was called whilst holding the
>> regulator_list_mutex, which is also locked from regulator_put. This
>> causes deadlock when failing to register a regulator.
> Applied, thanks.

This patch create the crash in following case:
- If there is of rail supply and supply does not found. In this case it 
goes to scrub and rdev->supply at this point shows NULL but when call 
the function device_unregister(&rdev->dev), the rdev->supply becomes 
random pointer.

What happen if we do the device_unregister() outside the mutex lock?
