Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415Ab2D3Qyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 12:54:51 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:12169 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517Ab2D3Qyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 12:54:50 -0400
Message-ID: <4F9EC3D7.1090906@hp.com>
Date: Mon, 30 Apr 2012 09:54:47 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Lightning/1.0b2 Thunderbird/3.1.20
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Shirley Ma <mashirle@us.ibm.com>, David Miller <davem@davemloft.net>,
        eric.dumazet@gmail.com, avi@redhat.com, arnd@arndb.de,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: getting host CPU utilization (was Re: [PATCH V7 2/4 net-next]
 skbuff: Add userspace zero-copy buffers in skb)
References: <1306610588.5180.87.camel@localhost.localdomain> <1309189510.21764.1.camel@localhost.localdomain> <20110627.155426.51839633424542723.davem@davemloft.net> <1309279892.3559.6.camel@localhost.localdomain> <4E0A0D34.2070507@hp.com> <20120430091246.GB5414@redhat.com>
In-Reply-To: <20120430091246.GB5414@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2012 02:12 AM, Michael S. Tsirkin wrote:
> On Tue, Jun 28, 2011 at 10:19:48AM -0700, Rick Jones wrote:
>> one of these days I'll have to find a good way to get accurate
>> overall CPU utilization from within a guest and teach netperf about
>> it.
>
> I think the cleanest way would be to run another netperf server on the
> host.  netperf would get a flag with host address and get cpu
> utilization info.
>
> This is what we currently do manually: run mpstat on the host.
>
> Thoughts?

I might be able to enhance the LOC_CPU/REM_CPU calibration tests to be 
bona fide CPU utilization tests.

> By the way, could you point me to code used by netperf
> to measure CPU utilization on Linux? I'd like to figure
> out why isn't the result always consistent with e.g. mpstat.

That would be src/netcpu_procstat.c .  That code is automagically 
selected by the configure script when it determines the compilation is 
happening under Linux.  You can, if you wish, manually set it though I 
suspect the only other mechanism known to netperf that would function 
under Linux is the "looper" (aka CPU soaker) method.

rick
