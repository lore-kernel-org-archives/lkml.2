Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078Ab2BWVdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 16:33:47 -0500
Received: from mga03.intel.com ([143.182.124.21]:53021 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207Ab2BWVdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 16:33:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="110093454"
Message-ID: <4F46B169.1030307@intel.com>
Date: Thu, 23 Feb 2012 19:36:41 -0200
From: Eugeni Dodonov <eugeni.dodonov@intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111224 Thunderbird/9.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Chris Wilson <chris@chris-wilson.co.uk>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Dave Airlie <airlied@redhat.com>,
        Alex Deucher <alexdeucher@gmail.com>
Subject: Re: [PATCH] drm: Reduce the number of retries whilst reading EDIDs
References: <CA+55aFxO27oa+WAtDLuWtr-NFNmKb2T0V6pccn=AE+g5PePPUg@mail.gmail.com> <1330026771-19937-1-git-send-email-chris@chris-wilson.co.uk> <CA+55aFyAUgY5BBLA+eVF4bFTFkooxQneKE-0BWy1nrjUni=vxg@mail.gmail.com>
In-Reply-To: <CA+55aFyAUgY5BBLA+eVF4bFTFkooxQneKE-0BWy1nrjUni=vxg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2012 06:15 PM, Linus Torvalds wrote:
> On Thu, Feb 23, 2012 at 11:52 AM, Chris Wilson<chris@chris-wilson.co.uk>  wrote:
>>
>> i2c retries if sees an EGAIN, drm_do_probe_ddc_edid retries until it
>> gets a result and *then* drm_do_get_edid retries until it gets a result
>> it is happy with. All in all, that is a lot of processor intensive
>> looping in cases where we do not expect and cannot get valid data - for
>> example on Intel with disconnected hardware we will busy-spin until we
>> hit the i2c timeout. This is then repeated for every connector when
>> querying the current status of outputs.
>
> Sadly, this doesn't seem to make any difference to my case. My xrandr
> stays at 0.555s even with this patch.

Perhaps a stupid question, but does you tree has 
http://cgit.freedesktop.org/~airlied/linux/commit/?h=drm-next&id=9292f37e1f5c79400254dca46f83313488093825 
from Dave's drm-next?

If it has, it would be the 1st time that I see xrandr take longer than 
.5s with that patch on an Intel GPU. We even added a check for this into 
intel-gpu-tools to warn us if any machine takes that long, and none had 
hit it so far. So if this is the case here, there is something Mac 
Mini-specific indeed to investigate.

-Eugeni
