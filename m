Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab1BJBYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 20:24:55 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55632 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751286Ab1BJBYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 20:24:54 -0500
Message-ID: <4D533EB0.6060405@cn.fujitsu.com>
Date: Thu, 10 Feb 2011 09:26:08 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: jacob pan <jacob.jun.pan@linux.intel.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Matt Helsley <matthltc@us.ibm.com>,
        container cgroup <containers@lists.linux-foundation.org>,
        Paul Menage <menage@google.com>, akpm@linux-foundation.org,
        rdunlap@xenotime.net, Cedric Le Goater <clg@fr.ibm.com>
Subject: Re: [PATCH 1/1, v6] cgroup/freezer: add per freezer duty ratio control
References: <1297213541-18156-1-git-send-email-jacob.jun.pan@linux.intel.com>	<4D52050F.3060907@cn.fujitsu.com> <20110209101631.5f265687@jacob-laptop>
In-Reply-To: <20110209101631.5f265687@jacob-laptop>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-10 09:23:59,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-10 09:24:01,
	Serialize complete at 2011-02-10 09:24:01
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jacob pan wrote:
> On Wed, 09 Feb 2011 11:07:59 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> jacob.jun.pan@linux.intel.com wrote:
>>> From: Jacob Pan <jacob.jun.pan@linux.intel.com>
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
>>>
>>> Usage example: set period to be 5 seconds and frozen duty ratio 90%
>>> [root@localhost aoa]# echo 90 > freezer.duty_ratio_pct
>>> [root@localhost aoa]# echo 5000 > freezer.period_ms
>>>
>>
>> So after:
>>
>> # echo FROZEN > freezer.state
>> # echo 90 > freezer.duty_ratio_pct
>> # echo 5000 > freezer.period_ms
>> ...
>> # echo 0 > freezer.duty_ratio_pct
>>
>> All the tasks in this cgroup are in THAWED state, but the cgroup is
>> in FROZEN state. This should be fixed.
> I don't know how could this ever happen. Is it based on your testing?
> Whenever tasks in a cgroup are thawed/frozen, its freezer state would
> change accordingly.
> After your example, freezer.state should have THAWED. It matches
> user's intention, i.e. if a user do
> echo 0 > freezer.duty_ratio_pct
> It must want 0% to be frozen, which is THAWED.
> 
> Am I missing anything?
> 

You're right. I made a mistake when looking into the patch.

btw, I made a few other comments in your code, that you may have
overlooked.
