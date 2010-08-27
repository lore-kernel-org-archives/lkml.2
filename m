Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab0H0SdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 14:33:07 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31433 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245Ab0H0SdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 14:33:02 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6087"; a="52354724"
Message-ID: <4C7804DE.9020008@codeaurora.org>
Date: Fri, 27 Aug 2010 11:33:02 -0700
From: Bryan Huntsman <bryanh@codeaurora.org>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Kevin Hilman <khilman@deeprootsystems.com>
CC: Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@suse.de>,
        mark gross <markgross@thegnar.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] pm_qos: Add system bus performance parameter
References: <1282882403-29824-1-git-send-email-skannan@codeaurora.org>	<1282882403-29824-2-git-send-email-skannan@codeaurora.org> <87hbigqg8d.fsf@deeprootsystems.com>
In-Reply-To: <87hbigqg8d.fsf@deeprootsystems.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Hilman wrote:
> Saravana Kannan <skannan@codeaurora.org> writes:
> 
>> Some drivers/devices might need some minimum system bus performance to
>> provide acceptable service. Provide a PM QoS parameter to send these requests
>> to.
>>
>> The new parameter is named "system bus performance" since it is generic enough
>> for the unit of the request to be frequency, bandwidth or something else that
>> might be appropriate. It's up to each implementation of the QoS provider to
>> define what the unit of the request would be.
>>
>> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
> 
> With this current design, only one system-wide bus would be managed.
> What if a platform has more than one independently scalable bus?
> 
> I think the only scalable way to handle this kind of thing is to have
> per-device QoS constraints that can then be combined/aggregated by parent
> devices/busses.
> 
> At LPC this year, I've proposed per-device QoS constraints[1] as a topic
> for the PM mini-conf.  I hope some folks from the MSM camp can be there
> for these discussions.
> 
> Kevin
> 
> [1] http://www.linuxplumbersconf.org/2010/ocw/proposals/819

Yeah, I'm planning on rounding up some MSM folks for LPC this year. 
Power is a big concern for us so it would be good to join the 
discussion.  Initially, I was very keen on the per-device QoS contraints 
but I've since cooled on it.  For our HW, there's not a generic unit 
that can convey enough data for us to act on.  At least not w/o lookup 
tables, etc., at which point the unit loses it's value and becomes a 
generic handle.  I'm looking forward to a good group discussion on this 
topic.  Thanks.

- Bryan


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
