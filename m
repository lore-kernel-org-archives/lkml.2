Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab1I1RM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 13:12:59 -0400
Received: from claw.goop.org ([74.207.240.146]:38429 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129Ab1I1RM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 13:12:58 -0400
Message-ID: <4E835095.5020706@goop.org>
Date: Wed, 28 Sep 2011 09:51:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Robert Richter <robert.richter@amd.com>, "x86@kernel.org" <x86@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "avi@redhat.com" <avi@redhat.com>
Subject: Re: [V6][PATCH 4/6] x86, nmi:  add in logic to handle multiple events
 and unknown NMIs
References: <1316805435-14832-1-git-send-email-dzickus@redhat.com> <1316805435-14832-5-git-send-email-dzickus@redhat.com> <20110928103140.GD6063@erda.amd.com> <20110928123720.GL5795@redhat.com>
In-Reply-To: <20110928123720.GL5795@redhat.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2011 05:37 AM, Don Zickus wrote:
> On Wed, Sep 28, 2011 at 12:31:40PM +0200, Robert Richter wrote:
>> On 23.09.11 15:17:13, Don Zickus wrote:
>>> @@ -89,6 +89,15 @@ static int notrace __kprobes nmi_handle(unsigned int type, struct pt_regs *regs)
>>>  
>>>  		handled += a->handler(type, regs);
>>>  
>>> +		/*
>>> + 		 * Optimization: only loop once if this is not a 
>>> + 		 * back-to-back NMI.  The idea is nothing is dropped
>>> + 		 * on the first NMI, only on the second of a back-to-back
>>> + 		 * NMI.  No need to waste cycles going through all the
>>> + 		 * handlers.
>>> + 		 */
>>> +		if (!b2b && handled)
>>> +			break;
>> I don't think we can leave this in. As said, there are cases that 2
>> nmis trigger but the handler is called only once. Only the first would
>> be handled then, and the second get lost cause there is no 2nd nmi
>> call.
> Right.  Avi, Jeremy what was your objection that needed this optimization
> in the first place?

My only interest in the NMI code is its use of spinlocks, which seem
inappropriate.

    J
