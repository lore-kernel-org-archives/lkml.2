Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798Ab1EOLME (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 07:12:04 -0400
Received: from toro.web-alm.net ([62.245.132.31]:55071 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792Ab1EOLMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 07:12:03 -0400
Message-ID: <4DCFB4AE.2070800@osadl.org>
Date: Sun, 15 May 2011 13:10:38 +0200
From: Carsten Emde <C.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL)
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Kacur <jkacur@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Subject: Re: merge of real-time 2.6.33.9-rt31 with stable 2.6.33.13
References: <alpine.LFD.2.00.1105141749180.29326@localhost6.localdomain6>	<alpine.LFD.2.02.1105141827270.3078@ionos> <BANLkTim68rrUkRi0r-5xo4T10r5ALgcQhg@mail.gmail.com>
In-Reply-To: <BANLkTim68rrUkRi0r-5xo4T10r5ALgcQhg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John,

> On Sat, May 14, 2011 at 6:28 PM, Thomas Gleixner<tglx@linutronix.de>  wrote:
>> On Sat, 14 May 2011, John Kacur wrote:
>>> I did some light testing merging 2.6.33.13 into real-time 2.6.33.9-rt31.
>>> In addition I cherry-picked 3c955b407a084810f57260d61548cc92c14bc627
>>> in order to compile on newer distros.
>>
>> Thanks.
>>
>>> Here is the result of cyclic test on one machine
>>> sudo ./cyclictest -t32 -p 80 -n -i 10000 -l 10000
>>> policy: fifo: loadavg: 0.00 0.00 0.00 1/541 3759
>>>
>>> T: 0 ( 3728) P:80 I:10000 C:  10000 Min:      7 Act:  104 Avg:  114 Max:     470
>>
>> The numbers are weird. How does that compare to older kernels on that
>> machine with the same test?
>
> Note this was on a machine with a straight Fedora install, and no -rt
> packages or tuning. That being the case, the numbers are no better or
> worse than recent -rt kernels. I can get you numbers with the last
> kernel if you wish, on Monday. Perhaps Carsten would be interested in
> running his tests?
I created my own 2.6.33.13-rt31 kernel some days ago. It is running on a 
pretest machine in our farm (rack #1, slot #4) since then -> 
https://www.osadl.org/?id=994. For an overview about the kernels in the 
farm (ordered by kernel version and release) see -> 
https://www.osadl.org/?id=1001. Real-time and all other data before and 
after the kernel upgrade to 2.6.33.13-rt31 are indistinguishable between 
each other.

Nevertheless, it would be interesting to investigate the origin of the 
numbers Thomas (correctly IMHO) classified as weird. The average and the 
maximum latency could be from a Pentium 90, the minimum latency looks ok 
for a state-of-the-art processor. What machine is this and how did you 
manage to create such numbers? It doesn't look like SMIs were 
responsible for that since they normally increase the maximum, not the 
average. Was another task with prio 80 or higher running?

Thanks,
Carsten.
