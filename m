Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935498Ab2JaMBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 08:01:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56949 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932738Ab2JaMBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 08:01:19 -0400
Date: Wed, 31 Oct 2012 12:01:17 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] regulator: core: Move regulator release to avoid
	deadlock
Message-ID: <20121031120117.GB27099@opensource.wolfsonmicro.com>
References: <20121029093333.GA17941@opensource.wolfsonmicro.com> <20121029161416.GE4511@opensource.wolfsonmicro.com> <5090FE97.7070303@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5090FE97.7070303@nvidia.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 04:03:59PM +0530, Laxman Dewangan wrote:
> On Monday 29 October 2012 09:44 PM, Mark Brown wrote:
>> * PGP Signed by an unknown key
>>
>> On Mon, Oct 29, 2012 at 09:33:33AM +0000, Charles Keepax wrote:
>>> regulator_put function was called whilst holding the
>>> regulator_list_mutex, which is also locked from regulator_put. This
>>> causes deadlock when failing to register a regulator.
>> Applied, thanks.
>
> This patch create the crash in following case:
> - If there is of rail supply and supply does not found. In this case it  
> goes to scrub and rdev->supply at this point shows NULL but when call  
> the function device_unregister(&rdev->dev), the rdev->supply becomes  
> random pointer.

Yeah that is a problem, sorry for missing this.

>
> What happen if we do the device_unregister() outside the mutex lock?

It would look reasonable to me, but I think it is going to make
more sense for someone with more experience than myself to have a
closer look at what can be done.
