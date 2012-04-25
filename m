Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab2DYOml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 10:42:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487Ab2DYOme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 10:42:34 -0400
Message-ID: <4F980D32.8020309@redhat.com>
Date: Wed, 25 Apr 2012 10:41:54 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Richard Davies <richard@arachsys.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan.kim@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Chris Webb <chris@arachsys.com>
Subject: Re: Over-eager swapping
References: <20120423092730.GB20543@alpha.arachsys.com>
In-Reply-To: <20120423092730.GB20543@alpha.arachsys.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 05:27 AM, Richard Davies wrote:

> The rrd graphs at http://imgur.com/a/Fklxr show a typical incident.
>
> We estimate memory used from /proc/meminfo as:
>
>    = MemTotal - MemFree - Buffers + SwapTotal - SwapFree
>
> The first rrd shows memory used increasing as a VM starts, but not getting
> near the 64GB of physical RAM.
>
> The second rrd shows the heavy swapping this VM start caused.
>
> The third rrd shows a multi-gigabyte jump in swap used = SwapTotal - SwapFree
>
> The fourth rrd shows the large load spike (from 1 to 15) caused by this swap
> storm.

These are exactly the kind of swap storms that led me
make the VM tweaks that got merged into 3.4-rc :)

See these commits:

fe2c2a106663130a5ab45cb0e3414b52df2fff0c
7be62de99adcab4449d416977b4274985c5fe023
aff622495c9a0b56148192e53bdec539f5e147f2
1480de0340a8d5f094b74d7c4b902456c9a06903
496b919b3bdd957d4b1727df79bfa3751bced1c1
