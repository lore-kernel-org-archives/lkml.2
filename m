Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab2L1M5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 07:57:41 -0500
Received: from mxout2.iskon.hr ([213.191.128.81]:58195 "EHLO mxout2.iskon.hr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979Ab2L1M5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 07:57:38 -0500
X-Remote-IP: 213.191.128.133
Date: Fri, 28 Dec 2012 13:57:31 +0100
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
References: <1828895463.36547216.1356662710202.JavaMail.root@redhat.com>
In-Reply-To: <1828895463.36547216.1356662710202.JavaMail.root@redhat.com>
X-Spam-Score: ##
Message-ID: <50DD973B.8000101@iskon.hr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at 0000000000000500
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45/RELEASE,
	 bases: 20121228 #8908331, check: 20121228 clean
X-SpamTest-Envelope-From: zlatko.calusic@iskon.hr
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 40823 [Dec 28 2012]
X-SpamTest-Method: none
X-SpamTest-Rate: 0
X-SpamTest-SPF: none
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.12.2012 03:45, Zhouping Liu wrote:
>>
>> Thank you for the report Zhouping!
>>
>> Would you be so kind to test the following patch and report results?
>> Apply the patch to the latest mainline.
>
> Hello Zlatko,
>
> I have tested the below patch(applied it on mainline directly),
> but IMO, I'd like to say it maybe don't fix the issue completely.
>
> run the reproducer[1] on two machine, one machine has 2 numa nodes(8Gb RAM),
> another one has 4 numa nodes(8Gb RAM), then the system hung all the time, such as the dmesg log:
>
> [  713.066937] Killed process 6085 (oom01) total-vm:18880768kB, anon-rss:7915612kB, file-rss:4kB
> [  959.555269] INFO: task kworker/13:2:147 blocked for more than 120 seconds.
> [  959.562144] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1079.382018] INFO: task kworker/13:2:147 blocked for more than 120 seconds.
> [ 1079.388872] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1199.209709] INFO: task kworker/13:2:147 blocked for more than 120 seconds.
> [ 1199.216562] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1319.036939] INFO: task kworker/13:2:147 blocked for more than 120 seconds.
> [ 1319.043794] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1438.864797] INFO: task kworker/13:2:147 blocked for more than 120 seconds.
> [ 1438.871649] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1558.691611] INFO: task kworker/13:2:147 blocked for more than 120 seconds.
> [ 1558.698466] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> ......
>
> I'm not sure whether it's your patch triggering the hung task or not, but reverted cda73a10eb3,
> the reproducer(oom01) can PASS without both 'NULL pointer dereference at 0000000000000500' and hung task issues.
>
> but some time, it's possible that the reproducer(oom01) cause hung task on a box with large RAM(100Gb+), so I can't judge it...
>

Thanks for the test.

Yes, close to OOM things get quite unstable and it's hard to get 
reliable test results. Maybe you could run it a few times, and see if 
you can get any meaningful statistics out of a few runs. I need to check 
oom.c myself and see what it's doing. Thanks for the link.

Regards,
-- 
Zlatko
