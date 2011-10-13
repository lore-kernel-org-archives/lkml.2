Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab1JMIRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 04:17:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:39628 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753690Ab1JMIRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 04:17:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="62799172"
Message-ID: <4E969EA6.9060400@linux.intel.com>
Date: Thu, 13 Oct 2011 16:17:42 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>, seiji.aguchi@hds.com,
        vgoyal@redhat.com, mjg@redhat.com, tony.luck@intel.com,
        gong.chen@intel.com, satoru.moriya@hds.com, avi@redhat.com
Subject: Re: [PATCH 1/3] x86, reboot:  Use NMI instead of REBOOT_VECTOR to
 stop cpus
References: <1318346686-12349-1-git-send-email-dzickus@redhat.com> <1318346686-12349-2-git-send-email-dzickus@redhat.com> <4E94FCFE.4090300@linux.intel.com> <20111012125132.GI5795@redhat.com>
In-Reply-To: <20111012125132.GI5795@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011/10/12 20:51, Don Zickus 写道:
> On Wed, Oct 12, 2011 at 10:35:42AM +0800, Chen Gong wrote:
>> 于 2011/10/11 23:24, Don Zickus 写道:
>>> +
>>> +		/* sync above data before sending NMI */
>>> +		wmb();
>>> +
>>> +		apic->send_IPI_allbutself(NMI_VECTOR);
>>> +
>>> +		/*
>>> +		 * Don't wait longer than a second if the caller
>>> +		 * didn't ask us to wait.
>>> +		 */
>>> +		timeout = USEC_PER_SEC;
>>> +		while (num_online_cpus()>   1&&   (wait || timeout--))
>>> +			udelay(1);
>>
>> In this patch and next patch, how about using the same logic in commit 74d91e3c6
>
> I guess I don't understand why I would do that.  That commit doesn't seem
> to have a way to break out of the while loop and it does not take into account
> the 'wait' variable the virt folks needed.  The only thing that could be
> usable seems to be the 'touch_nmi_watchdog', but in that case if the other
> cpus haven't hit the NMI yet, I would be happy for other NMI sources to
> trigger to, to help move things along. :-)

Maybe two birds with on stone :-)

>
> The above code snippet is what is currently there and that seems to work
> well, so I didn't want to change to much when moving from the IRQ path to
> the NMI path.

Fine, if so, I have no objection.

