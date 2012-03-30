Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760170Ab2C3BSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 21:18:51 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27291 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443Ab2C3BSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 21:18:45 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6664"; a="174882501"
Message-ID: <4F7509F4.6010303@codeaurora.org>
Date: Thu, 29 Mar 2012 18:18:44 -0700
From: Michael Bohan <mbohan@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: rnayak@ti.com, lrg@ti.com, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: Regulator supplies when using Device Tree
References: <4F6BCF47.4090200@codeaurora.org> <20120326130005.GQ3098@opensource.wolfsonmicro.com> <4F726B96.8070508@codeaurora.org> <20120328100957.GD3232@opensource.wolfsonmicro.com> <4F736451.8020900@codeaurora.org> <20120328193341.GD3232@opensource.wolfsonmicro.com> <4F73A798.6030607@codeaurora.org> <20120329111159.GJ3668@opensource.wolfsonmicro.com>
In-Reply-To: <20120329111159.GJ3668@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/29/2012 4:11 AM, Mark Brown wrote:
> On Wed, Mar 28, 2012 at 05:06:48PM -0700, Michael Bohan wrote:
>
>> Are you aware of any other examples of submitted drivers with Device
>> Tree support that implement regulator devices that optionally have
>> an upstream supply? I looked at your tree recently and couldn't see
>> any such cases.
>
> No, pretty much any drivers which optionally have an upstream supply
> would be buggy and should therefore run into trouble during review.

Can you please elaborate on why this is a bad design? We have always 
used this model in the past, and the regulator framework is happy to 
support it.

We have identical hardware blocks that can be positioned to take a 
supply or not. So are you proposing we copy / paste our driver so that 
in one case rdesc->supply_name is NULL and the other case a valid supply 
name? I'm guessing you aren't implying this, but what alternatives do 
you suggest to support such a model?

In the thread mentioned by Rajendra, part of the motivation for putting 
the supply_name in the driver struct was 'no code changes in the 
individual drivers'. But that's exactly what we have here.

http://www.spinics.net/lists/linux-omap/msg58673.html

I was hoping that we could continue to treat regulator supplies as 
normal supplies, but somehow allow the framework to determine whether a 
regulator supply exists or not in the Device Tree configuration so the 
driver doesn't have to.

Thanks,
Mike

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
