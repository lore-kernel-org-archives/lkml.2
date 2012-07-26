Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab2GZLL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 07:11:28 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:36530 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab2GZLL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 07:11:26 -0400
Message-ID: <501125D3.9050705@linux.vnet.ibm.com>
Date: Thu, 26 Jul 2012 16:41:15 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Alan Stern <stern@rowland.harvard.edu>, mingo@kernel.org,
        peterz@infradead.org, rusty@rustcorp.com.au,
        paulmck@linux.vnet.ibm.com, namhyung@kernel.org, tj@kernel.org,
        rjw@sisk.pl, nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC PATCH 0/6] CPU hotplug: Reverse invocation of notifiers
 during CPU hotplug
References: <Pine.LNX.4.44L0.1207251054420.2008-100000@iolanthe.rowland.org> <50101733.4030205@linux.vnet.ibm.com> <alpine.LFD.2.02.1207251758340.32033@ionos> <50102424.5010301@linux.vnet.ibm.com> <alpine.LFD.2.02.1207261256030.32033@ionos>
In-Reply-To: <alpine.LFD.2.02.1207261256030.32033@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12072611-8878-0000-0000-000003647697
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2012 04:32 PM, Thomas Gleixner wrote:
> On Wed, 25 Jul 2012, Srivatsa S. Bhat wrote:
>> On 07/25/2012 10:00 PM, Thomas Gleixner wrote:
>>> While I thought about having a full dependency tracking system, I'm
>>> quite convinced by now, that hotplug is a rather linear sequence which
>>> does not provide much room for paralell setup/teardown.
>>>
>>
>> Pretty much, when considering hotplug of a single CPU.
>>
>> (But when considering booting, Arjan had proposed (while discussing
>> about his asynchronous booting patch) that it would be good to split
>> up physical vs logical parts of the booting/hotplug, so that the
>> physical part can happen in parallel with other CPUs, while the
>> logical online can be done serially, much later. Anyway, this is
>> slightly off-topic here, since we are mainly talking about hotplug
>> of a single cpu here. I just thought of putting a word about that
>> here, since we are discussing hotplug redesign anyways..)
> 
> Well, the nice thing about having a proper state machine is that you
> can tell the code to advance the BP only to the "kick the other cpu"
> step, which is before the first sync point, so you can leave the state
> there and continue with "bring it fully online" later. 
> 
> So that feature comes basically for free. :)
> 

Ah! Nice :-)

Regards,
Srivatsa S. Bhat

