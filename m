Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab0JYBOr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 21:14:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59254 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab0JYBOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 21:14:46 -0400
Message-ID: <4CC4DA38.6000907@cn.fujitsu.com>
Date: Mon, 25 Oct 2010 09:15:36 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Matt Helsley <matthltc@us.ibm.com>
CC: "akpm >> Andrew Morton" <akpm@linux-foundation.org>,
        Paul Menage <menage@google.com>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH 5/7] cgroups: Make freezer subsystem bindable
References: <4CC146A4.9090505@cn.fujitsu.com> <4CC1473D.9070201@cn.fujitsu.com> <20101022205755.GJ10119@count0.beaverton.ibm.com>
In-Reply-To: <20101022205755.GJ10119@count0.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Helsley wrote:
> On Fri, Oct 22, 2010 at 04:11:41PM +0800, Li Zefan wrote:
>> To make it bindable, we need to thaw all processes when unbinding
>> the freezer subsystem from a cgroup hierarchy.
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> Based on experience using cgroups and questions we've fielded in the
> past on IRC I'd say users will really appreciate this.
> 
> We're planning to use the freezer in checkpoint/restart. Since
> checkpoint requires the tasks to remain frozen for the duration of
> the syscall we add a kernel-internal freezer subsystem interface
> which prevents the cgroup from thawing. So we'll need some way to
> "block" unbinding for that as well.
> 

How about, we allow unbinding only when all the cgroups' state is
THAWED ?

> Perhaps the bind op should be able to return an error when
> unbind == true? Although that raises the question of what to do if
> only one of multiple unbinds fails..
> 
> Alternately you could split the bind/unbind op function pointers
> and get rid of the boolean argument. Then just don't fill in the
> freezer's unbind op and refuse to unbind subsystems that lack
> the unbind op. That seems a bit cleaner for now at least.
> 

We can use bindable:1 along with a callback can_bind().

For some subsystems, we just set bindable to true. For freezer subsystem,
we set it to true and provide freezer_can_bind(), and return true only
if no cgroup's state is FROZEN.
