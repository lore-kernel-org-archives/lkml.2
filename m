Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243Ab0EUPJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 11:09:47 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40378 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756251Ab0EUPJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 11:09:45 -0400
Message-ID: <4BF6A21A.60405@us.ibm.com>
Date: Fri, 21 May 2010 08:09:14 -0700
From: Sridhar Samudrala <sri@us.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Sridhar Samudrala <samudrala.sridhar@gmail.com>,
       "Michael S. Tsirkin" <mst@redhat.com>, netdev <netdev@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] cgroups: Add an API to attach a task to current task's
 cgroup
References: <1274227488.2370.107.camel@w-sridhar.beaverton.ibm.com> <AANLkTinsrFoLVKDFM5pcKcL_6MvAzhR6IzbNmWKh3BDh@mail.gmail.com>
In-Reply-To: <AANLkTinsrFoLVKDFM5pcKcL_6MvAzhR6IzbNmWKh3BDh@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/20/2010 3:22 PM, Paul Menage wrote:
> On Tue, May 18, 2010 at 5:04 PM, Sridhar Samudrala
> <samudrala.sridhar@gmail.com>  wrote:
>    
>> Add a new kernel API to attach a task to current task's cgroup
>> in all the active hierarchies.
>>
>> Signed-off-by: Sridhar Samudrala<sri@us.ibm.com>
>>      
> Reviewed-by: Paul Menage<menage@google.com>
>
> It would be more efficient to just attach directly to current->cgroups
> rather than potentially creating/destroying one css_set for each
> hierarchy until we've completely converged on current->cgroups - but
> that would require a bunch of refactoring of the guts of
> cgroup_attach_task() to ensure that the right can_attach()/attach()
> callbacks are made. That doesn't really seem worthwhile right now for
> the initial use, that I imagine isn't going to be
> performance-sensitive.
>    
Yes. In our use-case, this will be called only once per guest interface 
when the guest comes up.
Hope you or someone more familiar with cgroups subsystem can optimize 
this function later.

Thanks
Sridhar

