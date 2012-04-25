Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab2DYWms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 18:42:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:42753 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932274Ab2DYWmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 18:42:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="146000573"
Message-ID: <4F987DE5.5030000@linux.intel.com>
Date: Wed, 25 Apr 2012 15:42:45 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: tj@kernel.org, htmldeveloper@gmail.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@elte.hu, linux-mm@kvack.org
Subject: Re: [BUG]memblock: fix overflow of array index
References: <CAHnt0GXW-pyOUuBLB1n6qBP4WNGpET9er_HbJ29s5j5DE1xAdA@mail.gmail.com> <20120425222819.GF8989@google.com> <4F987ACB.8050604@linux.intel.com> <20120425.183121.1283820821646106475.davem@davemloft.net>
In-Reply-To: <20120425.183121.1283820821646106475.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2012 03:31 PM, David Miller wrote:
> From: "H. Peter Anvin" <hpa@linux.intel.com>
> Date: Wed, 25 Apr 2012 15:29:31 -0700
> 
>> On 04/25/2012 03:28 PM, Tejun Heo wrote:
>>>
>>> All indexes in memblock are integers.  Changing that particular one to
>>> unsigned int doesn't fix anything.  I think it just makes things more
>>> confusing.  If there ever are cases w/ more then 2G memblocks, we're
>>> going for 64bit not unsigned.
>>>
>>
>> I would expect there to be plenty of memblocks larger than 2G?
> 
> Yes, but not the array indexes into those memblock entries, which is
> what this patch is about.

OIC... more than 2^31 memblocks.

	-hpa

