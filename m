Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab1KFRKY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 12:10:24 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:44137 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab1KFRKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 12:10:22 -0500
Message-ID: <4EB6BF72.3070509@linux.vnet.ibm.com>
Date: Sun, 06 Nov 2011 22:40:10 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: rjw@sisk.pl, paul@paulmenage.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, arnd@arndb.de, oleg@redhat.com,
        matthltc@us.ibm.com, Paul Menage <menage@google.com>
Subject: Re: [PATCH 05/17] freezer: rename thaw_process() to __thaw_task()
 and simplify the implementation
References: <1320087928-32307-1-git-send-email-tj@kernel.org> <1320087928-32307-6-git-send-email-tj@kernel.org> <4EB677CB.20608@linux.vnet.ibm.com> <20111106165112.GB13699@google.com>
In-Reply-To: <20111106165112.GB13699@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11110617-2000-0000-0000-000000FE0896
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2011 10:21 PM, Tejun Heo wrote:
> Hello,
> 
> On Sun, Nov 06, 2011 at 05:34:27PM +0530, Srivatsa S. Bhat wrote:
>> On 11/01/2011 12:35 AM, Tejun Heo wrote:
>>>   * task_lock() is needed to prevent the race with refrigerator() which may
>>                                                      ^^^^^^
>>                                                 __refrigerator()?
> 
> I don't think this really matters.  Maybe just drop () from the
> comment?

Sure, that would do. It was rather trivial anyway...

> 
>> Rebasing to latest kernel, we need to do the conversion in mm/oom_kill.c as well,
>> (and consequently add __thaw_task() empty function under !CONFIG_FREEZER, in
>> include/linux/freezer.h)
> 
> Yes, for merging, we should do that, but for longer term, as we can
> modify freezing condition with relative ease now, I think we should
> make tasks being killed ignore freezer instead of relying on
> explicitly calling __thaw_task() which is inherently racy.
> 

OK.. And yes, many thanks for your efforts to stabilize the freezer
subsystem :)

Thanks,
Srivatsa S. Bhat

