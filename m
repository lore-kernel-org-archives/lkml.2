Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab0IMUfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 16:35:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52400 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab0IMUfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 16:35:31 -0400
Message-ID: <4C8E8ABF.605@zytor.com>
Date: Mon, 13 Sep 2010 13:34:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: eranian@google.com, linux-kernel@vger.kernel.org, peterz@infradead.org,
        mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        robert.richter@amd.com, markus.t.metzger@intel.com
Subject: Re: [PATCH] perf_events: improve DS/BTS/PEBS buffer allocation
References: <4c8e3c0c.12d1d80a.73d9.ffffcf21@mx.google.com> <877hip4et0.fsf@basil.nowhere.org>
In-Reply-To: <877hip4et0.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2010 12:35 PM, Andi Kleen wrote:
> 
> DS supports page tables, but I have some doubts it really 
> supports page faults. vmalloc today does page faults. 
> 

It specifically does not (SDM III 16.4.9.2).  In fact, it requires that
the pages be mapped Accessed and Dirty so the hardware doesn't have to
stop and set those bits.

The options thus are vmalloc_sync_all(), which will make Linus unhappy
(since he seems to want to get rid of the thing), or doing fixmap-style
reserved address space which is always consistent because the PDEs are
preallocated and frozen.

	-hpa
