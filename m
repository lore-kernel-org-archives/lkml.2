Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab2L1Nnd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 08:43:33 -0500
Received: from mxout2.iskon.hr ([213.191.128.81]:47985 "EHLO mxout2.iskon.hr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393Ab2L1Nnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 08:43:32 -0500
X-Remote-IP: 213.191.128.133
Date: Fri, 28 Dec 2012 14:43:24 +0100
From: Zlatko Calusic <zlatko.calusic@iskon.hr>
Organization: Iskon Internet d.d.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Icedove/17.0
MIME-Version: 1.0
To: Zhouping Liu <zliu@redhat.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Johannes Weiner <jweiner@redhat.com>,
        mgorman@suse.de, hughd@google.com,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hillf Danton <dhillf@gmail.com>, sedat.dilek@gmail.com
References: <1828895463.36547216.1356662710202.JavaMail.root@redhat.com> <50DD5FD9.2080303@redhat.com>
In-Reply-To: <50DD5FD9.2080303@redhat.com>
X-Spam-Score: ##
Message-ID: <50DDA1FC.8030608@iskon.hr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at 0000000000000500
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45/RELEASE,
	 bases: 20121228 #8908331, check: 20121228 clean
X-SpamTest-Envelope-From: zlatko.calusic@iskon.hr
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 40824 [Dec 28 2012]
X-SpamTest-Method: none
X-SpamTest-Rate: 0
X-SpamTest-SPF: none
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.12.2012 10:01, Zhouping Liu wrote:
> On 12/28/2012 10:45 AM, Zhouping Liu wrote:
>>> Thank you for the report Zhouping!
>>>
>>> Would you be so kind to test the following patch and report results?
>>> Apply the patch to the latest mainline.
>> Hello Zlatko,
>>
>> I have tested the below patch(applied it on mainline directly),
>> but IMO, I'd like to say it maybe don't fix the issue completely.
>
> Hi Zlatko,
>
> I re-tested it on another machine, which has 60+ Gb RAM and 4 numa nodes,
> without your patch, it's easy to reproduce the 'NULL pointer' error,
> after applying your patch, I couldn't reproduce the issue any more.
>
> depending on the above, it implied that your patch fixed the issue.
>

Yes, that's exactly what I expected. Just wanted to doublecheck this 
time. Live and learn. ;)

> but in my last mail, I tested it on two machines, which caused hung task
> with your patch,
> so I'm confusing is it your patch block some oom-killer performance? if
> it's not, your patch is good for me.
>

 From what I know, the patch shouldn't have much influence on the oom 
killer, if any. But, as all those subsystems are closely interconnected, 
both oom & vmscan code is mm after all, there could be some 
interference. Is the hung-task issue repeatable?
-- 
Zlatko
