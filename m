Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab2EAVEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 17:04:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab2EAVEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 17:04:35 -0400
Message-ID: <4FA04FD5.6010900@redhat.com>
Date: Tue, 01 May 2012 17:04:21 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: Pekka Enberg <penberg@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH v4] vmevent: Implement greater-than attribute state and
 one-shot mode
References: <20120418083208.GA24904@lizard> <20120418083523.GB31556@lizard> <alpine.LFD.2.02.1204182259580.11868@tux.localdomain> <20120418224629.GA22150@lizard> <alpine.LFD.2.02.1204190841290.1704@tux.localdomain> <20120419162923.GA26630@lizard> <20120501131806.GA22249@lizard>
In-Reply-To: <20120501131806.GA22249@lizard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2012 09:18 AM, Anton Vorontsov wrote:
> This patch implements a new event type, it will trigger whenever a
> value becomes greater than user-specified threshold, it complements
> the 'less-then' trigger type.
>
> Also, let's implement the one-shot mode for the events, when set,
> userspace will only receive one notification per crossing the
> boundaries.
>
> Now when both LT and GT are set on the same level, the event type
> works as a cross event type: it triggers whenever a value crosses
> the threshold from a lesser values side to a greater values side,
> and vice versa.
>
> We use the event types in an userspace low-memory killer: we get a
> notification when memory becomes low, so we start freeing memory by
> killing unneeded processes, and we get notification when memory hits
> the threshold from another side, so we know that we freed enough of
> memory.

How are these vmevents supposed to work with cgroups?

What do we do when a cgroup nears its limit, and there
is no more swap space available?

What do we do when a cgroup nears its limit, and there
is swap space available?

It would be nice to be able to share the same code for
embedded, desktop and server workloads...

-- 
All rights reversed
