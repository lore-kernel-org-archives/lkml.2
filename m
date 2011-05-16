Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab1EPV3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 17:29:08 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:65415 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756413Ab1EPV3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 17:29:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=BqFTH9269bUOaFqm4i/UwesxJXA5scuJr/BgoP7yM3o6odc4N3ZB53M8X59gVrflv4
         8Y+slqpE95F46Tiv6RzjRrMgnbArxOZ3HdhIy7hILz6iNCIM+Yt6G+JJ9U4ZNGfnscyC
         82B5iJp1dTpimPBZai+O0zWKzGuzXJOy/MQH0=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: LKML <linux-kernel@vger.kernel.org>,
        "John Stultz" <john.stultz@linaro.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, "Jiri Slaby" <jirislaby@gmail.com>,
        "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
        "David Rientjes" <rientjes@google.com>,
        "Dave Hansen" <dave@linux.vnet.ibm.com>,
        "Andrew Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] checkpatch.pl: Add check for task comm references
References: <1305580757-13175-1-git-send-email-john.stultz@linaro.org>
 <1305580757-13175-4-git-send-email-john.stultz@linaro.org>
Date: Mon, 16 May 2011 23:29:02 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vvlfaobx3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <1305580757-13175-4-git-send-email-john.stultz@linaro.org>
User-Agent: Opera Mail/11.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 May 2011 23:19:17 +0200, John Stultz wrote:
> Now that accessing current->comm needs to be protected,
> @@ -2868,6 +2868,10 @@ sub process {
>  			WARN("usage of NR_CPUS is often wrong - consider using  
> cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc\n" .  
> $herecurr);
>  		}
> +# check for current->comm usage
> +		if ($line =~ /\b(?:current|task|tsk|t)\s*->\s*comm\b/) {

Not a checkpatch.pl expert but as far as I'm concerned, that looks  
reasonable.

I was sort of worried that t->comm could produce quite a few false  
positives
but all its appearances in the kernel (seem to) refer to task.

> +			WARN("comm access needs to be protected. Use get_task_comm, or  
> printk's \%ptc formatting.\n" . $herecurr);
> +		}
>  # check for %L{u,d,i} in strings
>  		my $string;
>  		while ($line =~ /(?:^|")([X\t]*)(?:"|$)/g) {


-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
