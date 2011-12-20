Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab1LTHiC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 02:38:02 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:56005 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab1LTHhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 02:37:55 -0500
Message-ID: <4EF03B48.6000006@linux.vnet.ibm.com>
Date: Tue, 20 Dec 2011 13:07:44 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: mc@linux.vnet.ibm.com
CC: Al Viro <viro@ZenIV.linux.org.uk>, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, david@fromorbit.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] VFS: br_write_lock locks on possible CPUs other than
 online CPUs
References: <1324265775.25089.20.camel@mengcong> <4EEEE866.2000203@linux.vnet.ibm.com> <4EEF0003.3010800@codeaurora.org> <4EEF1A13.4000801@linux.vnet.ibm.com> <20111219121100.GI2203@ZenIV.linux.org.uk> <4EEF9D4E.1000008@linux.vnet.ibm.com> <20111219205251.GK2203@ZenIV.linux.org.uk> <4EF01565.2000700@linux.vnet.ibm.com> <20111220062710.GC23916@ZenIV.linux.org.uk> <1324366218.21588.5.camel@mengcong>
In-Reply-To: <1324366218.21588.5.camel@mengcong>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11121921-5140-0000-0000-000000722591
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2011 01:00 PM, mengcong wrote:

> On Tue, 2011-12-20 at 06:27 +0000, Al Viro wrote:
>> On Tue, Dec 20, 2011 at 10:26:05AM +0530, Srivatsa S. Bhat wrote:
>>> Oh, right, that has to be handled as well...
>>>
>>> Hmmm... How about registering a CPU hotplug notifier callback during lock init
>>> time, and then for every cpu that gets onlined (after we took a copy of the
>>> cpu_online_mask to work with), we see if that cpu is different from the ones
>>> we have already locked, and if it is, we lock it in the callback handler and
>>> update the locked_cpu_mask appropriately (so that we release the locks properly
>>> during the unlock operation).
>>>
>>> Handling the newly introduced race between the callback handler and lock-unlock
>>> code must not be difficult, I believe..
>>>
>>> Any loopholes in this approach? Or is the additional complexity just not worth
>>> it here?
>>
>> To summarize the modified variant of that approach hashed out on IRC:
>>
> On which IRC do you discuss?


#kernel on tinc.sekrit.org :-)

Regards,
Srivatsa S. Bhat

