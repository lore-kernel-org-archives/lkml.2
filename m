Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007Ab1EMLDD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 07:03:03 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45781 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758587Ab1EMLC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 07:02:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=ZKF3HI53bDk+nQR59SHTh7f3NTTAohk0SwGmU8ehU4PWv9CT5pMyHN2FR4IaqCFLAB
         keBSbu1TZlLLjwzh8qDAxOJ1GT18SQtOYLFYnGAMQhzSXv9rfZBYq5qI4KouWfGXTbTF
         1OD0Fk9pIZ+Jwev3wr8DbSuCPkRofrNiCKhHQ=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "John Stultz" <john.stultz@linaro.org>, "Jiri Slaby" <jirislaby@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Ted Ts'o" <tytso@mit.edu>,
        "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
        "David Rientjes" <rientjes@google.com>,
        "Dave Hansen" <dave@linux.vnet.ibm.com>,
        "Andrew Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] checkpatch.pl: Add check for current->comm references
References: <1305241371-25276-1-git-send-email-john.stultz@linaro.org>
 <1305241371-25276-4-git-send-email-john.stultz@linaro.org>
 <4DCCD0C3.9090908@gmail.com>
Date: Fri, 13 May 2011 13:02:56 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vve2a6hp3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <4DCCD0C3.9090908@gmail.com>
User-Agent: Opera Mail/11.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 05/13/2011 01:02 AM, John Stultz wrote:
>> @@ -2868,6 +2868,10 @@ sub process {
>>  			WARN("usage of NR_CPUS is often wrong - consider using  
>> cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc\n" .  
>> $herecurr);
>>  		}
>>
>> +# check for current->comm usage
>> +		if ($line =~ /current->comm/) {

On Fri, 13 May 2011 08:33:39 +0200, Jiri Slaby wrote:
> This should be something like \b(current|task|tsk|t)->comm\b to catch
> also non-current comm accesses...

Or \b(?:current|task|tsk|t)\s*->\s*comm\b.

>> +			WARN("comm access needs to be protected. Use get_task_comm, or  
>> printk's \%ptc formatting.\n" . $herecurr);
>> +		}

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
