Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab1BJDGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 22:06:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:14538 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754582Ab1BJDGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 22:06:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,449,1291622400"; 
   d="scan'208";a="601178341"
Message-ID: <4D535627.9090606@linux.intel.com>
Date: Wed, 09 Feb 2011 19:06:15 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Matt Helsley <matthltc@us.ibm.com>
CC: jacob.jun.pan@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        container cgroup <containers@lists.linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
        akpm@linux-foundation.org, rdunlap@xenotime.net,
        Cedric Le Goater <clg@vnet.ibm.com>,
        Wysocki Rafael Wysocki <rjw@sisk.pl>
Subject: Re: [PATCH 1/1, v6] cgroup/freezer: add per freezer duty ratio control
References: <1297213541-18156-1-git-send-email-jacob.jun.pan@linux.intel.com> <20110210030442.GG16432@count0.beaverton.ibm.com>
In-Reply-To: <20110210030442.GG16432@count0.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/9/2011 7:04 PM, Matt Helsley wrote:
> On Tue, Feb 08, 2011 at 05:05:41PM -0800, jacob.jun.pan@linux.intel.com wrote:
>> From: Jacob Pan<jacob.jun.pan@linux.intel.com>
>>
>> Freezer subsystem is used to manage batch jobs which can start
>> stop at the same time. However, sometime it is desirable to let
>> the kernel manage the freezer state automatically with a given
>> duty ratio.
>> For example, if we want to reduce the time that backgroup apps
>> are allowed to run we can put them into a freezer subsystem and
>> set the kernel to turn them THAWED/FROZEN at given duty ratio.
>>
>> This patch introduces two file nodes under cgroup
>> freezer.duty_ratio_pct and freezer.period_sec
>>
>> Usage example: set period to be 5 seconds and frozen duty ratio 90%
>> [root@localhost aoa]# echo 90>  freezer.duty_ratio_pct
>> [root@localhost aoa]# echo 5000>  freezer.period_ms
> I kept wondering how this was useful when we've got the "cpu" subsystem
> because for some reason "duty cycle" made me think this was a scheduling
> policy knob. In fact, I'm pretty sure it is -- it just happens to
> sometimes reduce power consumption.
>
> Have you tried using the cpu cgroup subsystem's share to see if it can
> have a similar effect?

does the cpu cgroup system work on a 20 to 30 second time window?
the objective is to have the CPU idle, without wakeups, for that long...
(to save power)


