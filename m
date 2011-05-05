Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab1EEMFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 08:05:14 -0400
Received: from filoni2.nine.ch ([94.230.212.32]:53777 "EHLO mail.lenux.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635Ab1EEMFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 08:05:13 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 05 May 2011 14:05:11 +0200
From: jdossantos@docs.homelinux.org
To: Hank Janssen <hjanssen@microsoft.com>
Cc: KY Srinivasan <kys@microsoft.com>, <linux-kernel@vger.kernel.org>
Subject: RE: Error in Hyper-V modules =?UTF-8?Q?hv=5Fvmbus?=
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C562498A3FF3@TK5EX14MBXC114.redmond.corp.microsoft.com>
References: <0e67fbb5ce27bd8d1210f0b7b8d5069c@docs.homelinux.org>
 <8AFC7968D54FB448A30D8F38F259C562498A3FF3@TK5EX14MBXC114.redmond.corp.microsoft.com>
Message-ID: <42a623fd771f05f5bcabec8d632673e3@docs.homelinux.org>
User-Agent: Roundcube Webmail/0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On Wed, 4 May 2011 16:00:52 +0000, Hank Janssen wrote:
>> -----Original Message-----
>> From: jdossantos@docs.homelinux.org
>> [mailto:jdossantos@docs.homelinux.org]
>> Sent: Wednesday, May 04, 2011 2:48 AM
>> To: Hank Janssen
>> Cc: KY Srinivasan; linux-kernel@vger.kernel.org
>> Subject: Re: Error in Hyper-V modules hv_vmbus
>> > Hank.
>>
>>  Here is my step by step protocol:
>
> Thanks for the detailed setup. I will be trying it with this.
>
>>  lsmod | grep hv_
>>  hv_timesource           1055  0 [permanent]
>>  hv_vmbus               48554  1
>>
>>  In the logs and with lsmod i see the timesource module running, but
>> the
>>  time is not in sync with the windows host.
>>  Shutdown function also dosn't work, seems that nothing of the
>>  integrated components are working..hv_netvsc,hv_blkvsc,hv_storvsc 
>> are
>>  not
>>  loaded?! But modinfo provides information:
>
> Timesource makes sure that the clock does not drift and uses Hyper-V 
> for
> Its stable time source.
>
> The setting of the clock equal to the host is provided by the 
> hv_utils.ko
> Module. This module also provides heartbeat, shutdown and KVP 
> functionality.
>
>
>>  After that I enabled the synthetic network card, but also here..it
>>  doesn't work and I don't see any hv_netvsc
>>  module loaded, so I tried to load it "by hand" with modprobe
>>  hv_netvsc..but I get a modprobe timeout and nothing happens..
>
> I should know more in the next day or so when I get a VM up and 
> running.
>
> It works fine on Ubuntu, I submitted a few patches to them a few 
> weeks ago
> To fix some other problems (these patches are already in mainline)
>
> Hank.
 Hi Hank

 Yes in ubuntu server (i tested the newest version 11.04) there is no 
 problem, the hyper-v modules are compiled and activated
 as default in the released kernel (2.6.38-8), network, timesync and all 
 others integrated components are working fine. This is the lsmod
 output:
 lsmod | grep hv_
 hv_utils               12850  0
 hv_netvsc              36467  0
 hv_timesource          12423  0 [permanent]
 hv_vmbus               50431  2 hv_utils,hv_netvsc

 Now I have downloaded the newest rc kernel and done the same steps like 
 in the debian installation, after a reboot I get same errors and 
 integrated components failed to works...Now I check the hyper-v modules 
 source from 2.6.38-8 ubuntu kernel and the new one

 Regards
 Juan Dos Santos

