Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab1LETTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:19:14 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:34818 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586Ab1LETTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:19:12 -0500
Message-ID: <4EDD191D.2030409@linux.vnet.ibm.com>
Date: Tue, 06 Dec 2011 00:48:53 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Tejun Heo <tj@kernel.org>, rjw@sisk.pl, pavel@ucw.cz, len.brown@intel.com,
        ebiederm@xmission.com, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 1/3] PM / Sleep: Make [un]lock_system_sleep() generic
References: <20111204200208.25620.515.stgit@srivatsabhat.in.ibm.com> <20111205171443.GB627@google.com> <4EDCFE9F.9050605@linux.vnet.ibm.com> <20111205173057.GE627@google.com> <4EDD0254.10408@linux.vnet.ibm.com> <4EDD0D35.1020907@linux.vnet.ibm.com> <20111205183502.GA30482@redhat.com>
In-Reply-To: <20111205183502.GA30482@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11120509-6102-0000-0000-000000565960
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

On 12/06/2011 12:05 AM, Oleg Nesterov wrote:

> On 12/05, Srivatsa S. Bhat wrote:
>>
>> I looked up in git and found that commit ba96a0c by Rafael introduced the
>> count functions, to handle the vfork case. But now, we seem to have more
>> uses than that. So I think we can remove that userspace restriction in the
>> count functions,
> 
> Agreed.
> 
>> and in kernel/fork.c, do something like:
>>
>> if (current->mm)
>> 	freezer_do_not_count();
>> ...
>> if (current->mm)
>> 	freezer_count();
> 
> see http://marc.info/?l=linux-kernel&m=132033335507261
> 
> I think this is not needed, we can just remove the ->mm check.
> CLONE_VFORK is not used by a freezable kthread.
> 


Great! Thanks for the pointer. I'll send a patch to remove that check.

Regards,
Srivatsa S. Bhat

