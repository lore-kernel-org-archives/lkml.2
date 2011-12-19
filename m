Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab1LSICP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 03:02:15 -0500
Received: from out2.rolmail.net ([195.254.252.213]:41014 "EHLO
	out2.rolmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab1LSICM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 03:02:12 -0500
Message-ID: <4EEEEF7F.8070506@enas.net>
Date: Mon, 19 Dec 2011 09:02:07 +0100
From: Urban Loesch <bind@enas.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Shawn Bohrer <shawn.bohrer@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: divide by zero error: find busiest group on kernel 2.6.38.4
References: <4EDB7CE0.9010105@enas.net> <20111216231414.GA7941@BohrerMBP.rgmadvisors.com>
In-Reply-To: <20111216231414.GA7941@BohrerMBP.rgmadvisors.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 17.12.2011 00:14, Shawn Bohrer wrote:
> On Sun, Dec 04, 2011 at 03:00:00PM +0100, Urban Loesch wrote:
>> I'm running a DELL PE R610 with kernel
>> 2.6.38.4 patched with linux vserver version vs2.3.0.37-rc15 from
>> http://linux-vserver.org.
>>
>> The server runs fine about 220 days without any problems.
>> But last night there was a kernel panic and the server totally hangs.
>>
>> Thanks to netconsole I got the following error in my syslogserver:
>>
>>
>> 2011-12-04 00:32:16 divide error: 0000 [#1]
>> 2011-12-04 00:32:16 SMP
> <snip>
>> 2011-12-04 00:32:16 Pid: 0, comm: kworker/0:1 Not tainted
>> 2.6.38.4-vs2.3.0.37-rc15-rol-em64t #1
>> 2011-12-04 00:32:16
>> 2011-12-04 00:32:16 Dell Inc. PowerEdge R610
>> 2011-12-04 00:32:16 /
>> 2011-12-04 00:32:16 0F0XJ6
>> 2011-12-04 00:32:16
>> 2011-12-04 00:32:16 RIP: 0010:[<ffffffff8103abb8>]
>> 2011-12-04 00:32:16 [<ffffffff8103abb8>]
>> find_busiest_group+0x428/0xdd0
>
> This looks like the same issue as:
>
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=636797
> and
> https://bugs.launchpad.net/linux/+bug/614853
>
> In theory there is also a bugzilla.kernel.org ticket on this issue as
> well though bugzilla.kernel.org is still down.
>
> https://bugzilla.kernel.org/show_bug.cgi?id=16991
>
> Debian and Ubuntu have papered over this bug by skipping the divide if
> cpu_power is 0.
>
>> I searched the archives but I didn't find any related information.
>> Have you any idea what this error could be and is it fixed in kernel 3.1?
>
> To my knowledge the cause of this bug is still unknown.  It is
> possible it is fixed in newer kernels, but it is hard to tell since it
> doesn't seem to occur until you have reached 200+ days of uptime.
>

Not sure if that describes exactly the same problem:

http://comments.gmane.org/gmane.linux.kernel/1132515

Patch:
http://git.kernel.org/?p=linux/kernel/git/tip/tip.git;a=commitdiff;h=4cecf6d401a01d054afc1e5f605bcbfe553cb9b9

This issue was fixed in 3.1.5.
http://www.kernel.org/pub/linux/kernel/v3.0/ChangeLog-3.1.5

> --
> Shawn
>

Thanks
Urban
