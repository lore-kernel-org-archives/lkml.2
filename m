Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab2AXQIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 11:08:40 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49744 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab2AXQIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 11:08:39 -0500
Message-ID: <4F1ED780.3010305@gmail.com>
Date: Tue, 24 Jan 2012 09:08:32 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, acme@infradead.org, robert.richter@amd.com,
        ming.m.lin@intel.com, andi@firstfloor.org, asharma@fb.com,
        ravitillo@lbl.gov, vweaver1@eecs.utk.edu
Subject: Re: [PATCH 00/13] perf_events: add support for sampling taken branches
 (v3)
References: <1326127761-2723-1-git-send-email-eranian@google.com> <CABPqkBTYrEeSefnXr4-ezmXHjNv1XkfVZGULzY5-=FE3tr3pfg@mail.gmail.com> <1327321532.2446.6.camel@twins> <CABPqkBSqA071Yt4KcCH25P6HZ1C8OOGFfcjOQ_aLmBRc3ir=9A@mail.gmail.com> <CABPqkBSALpYBTpaJo4Wor6weM-XM3PRxj23u8N+Kihvm36Hj8w@mail.gmail.com>
In-Reply-To: <CABPqkBSALpYBTpaJo4Wor6weM-XM3PRxj23u8N+Kihvm36Hj8w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/24/2012 08:39 AM, Stephane Eranian wrote:
> Hi,
> 
> The branch stack sampling patch exposes a flaw in the sampling
> buffer format as currently exported by the kernel.
> 
> In the current format, sample records (RECORD_SAMPLE) are NOT
> self-describing. That means that by looking at the fixed size header, it
> is not possible to determine which event caused the sample to be recorded
> and what's in the body of the variable length sample.
> 
> Such introspection is only possible once we know the event unique id
> (PERF_SAMPLE_ID). But to get the event ID, we need to parse the
> sample. But, given that a sample has a variable length, there is no
> predefined position for that ID in the sample. You have a chicken
> and egg problem here. There is no room left in the fixed size header
> to fit this in.

I brought this up last Fall as well. As I recall the response is to move
each sample_type based stream into its own data file and then merge the
data files while processing.

David
