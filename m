Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab1BNDXV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 22:23:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:9692 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917Ab1BNDXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 22:23:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,466,1291622400"; 
   d="scan'208";a="657358357"
Message-ID: <4D58A01E.9000203@linux.intel.com>
Date: Sun, 13 Feb 2011 19:23:10 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Matt Helsley <matthltc@us.ibm.com>, jacob.jun.pan@linux.intel.com,
        LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        container cgroup <containers@lists.linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
        akpm@linux-foundation.org, rdunlap@xenotime.net,
        Cedric Le Goater <clg@vnet.ibm.com>
Subject: Re: [PATCH 1/1, v7] cgroup/freezer: add per freezer duty ratio control
References: <1297451444-15277-1-git-send-email-jacob.jun.pan@linux.intel.com>	<20110212232907.GN16432@count0.beaverton.ibm.com> <20110214094402.4eefe70d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110214094402.4eefe70d.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/13/2011 4:44 PM, KAMEZAWA Hiroyuki wrote:
> On Sat, 12 Feb 2011 15:29:07 -0800
> Matt Helsley<matthltc@us.ibm.com>  wrote:
>
>> On Fri, Feb 11, 2011 at 11:10:44AM -0800, jacob.jun.pan@linux.intel.com wrote:
>>> From: Jacob Pan<jacob.jun.pan@linux.intel.com>
>>>
>>> Freezer subsystem is used to manage batch jobs which can start
>>> stop at the same time. However, sometime it is desirable to let
>>> the kernel manage the freezer state automatically with a given
>>> duty ratio.
>>> For example, if we want to reduce the time that backgroup apps
>>> are allowed to run we can put them into a freezer subsystem and
>>> set the kernel to turn them THAWED/FROZEN at given duty ratio.
>>>
>>> This patch introduces two file nodes under cgroup
>>> freezer.duty_ratio_pct and freezer.period_sec
>> Again: I don't think this is the right approach in the long term.
>> It would be better not to add this interface and instead enable the
>> cpu cgroup subsystem for non-rt tasks using a similar duty ratio
>> concept..
>>
>> Nevertheless, I've added some feedback on the code for you here :).
>>
> AFAIK, there was a work for bandwidth control in CFS.
>
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2010-10/msg04335.html
>
> I tested this and worked fine. This schduler approach seems better for
> my purpose to limit bandwidth of apprications rather than freezer.

for our purpose, it's not about bandwidth.
it's about making sure the class of apps don't run for a long period 
(30-second range) of time.

