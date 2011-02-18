Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab1BRP22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 10:28:28 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:27445 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab1BRP2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 10:28:24 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAAofXk2rRN+J/2dsb2JhbACEH6IEc6BMinuQP4Eng0F2BIULhwaDOoIa
X-IronPort-AV: E=Sophos;i="4.62,187,1297036800"; 
   d="scan'208";a="663087940"
Message-ID: <4D5E9016.4070808@cisco.com>
Date: Fri, 18 Feb 2011 08:28:22 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, acme@ghostprotocols.net, paulus@samba.org
Subject: Re: [PATCH 1/3] perf events: fix WARN_ON_ONCE for 64-bit raw data,
 SW events
References: <1298008433-22911-1-git-send-email-daahern@cisco.com>	 <1298008433-22911-2-git-send-email-daahern@cisco.com>	 <1298026821.5226.642.camel@laptop>  <4D5E8338.8010602@cisco.com> <1298040938.5226.771.camel@laptop>
In-Reply-To: <1298040938.5226.771.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/18/11 07:55, Peter Zijlstra wrote:
>> Another gotcha is in perf_output_sample there is:
>>             struct {
>>                 u32 size;
>>                 u32 data;
>>             } raw = {
>>                 .size = sizeof(u32),
>>                 .data = 0,
>>             };
>>
>> While that meets the 8-byte stride I was concerned that changing the
>> size field to u64 breaks ABI.
> 
> It would.
> 
> No, what you need to do is provide data that is sized such that it
> matches the 8b stride adding padding where needed.

I want to push a 64-bit counter to userspace. By definition it meets the
8-byte stride. Now how do I get sizeof(size field) + sizeof(data) to
meet an 8-byte stride? I can't when sizeof(size field) = 4. Ok, I can
pad the data with 4 bytes, but then I an api to tell the user to strip
the 4-byte pad. Seems like an odd way to go.

Why is an 8-byte stride preferred over a 4-bytes?

David

> 
> Anyway, I don't think you need RAW at all.
> 
