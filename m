Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339Ab1EQVEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 17:04:48 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61879 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233Ab1EQVEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 17:04:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=O/YrOfW1C41agH0uDIuA68UBAh8gBFzU5dn1h/WkNEBpBWCx32b/KjKcsoSM8JwO71
         ii0YgTcbZYnZetQfD/6/16vYCM68sNcDgrb/K9Psfmchbn6+WJziYcaGitvhou9uEIeF
         UMTJuipvZKA5SJBdAASeTlDu6S8Cirwj70uU8=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: LKML <linux-kernel@vger.kernel.org>,
        "John Stultz" <john.stultz@linaro.org>
Cc: "Joe Perches" <joe@perches.com>, "Andy Whitcroft" <apw@canonical.com>,
        "Jiri Slaby" <jirislaby@gmail.com>,
        "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
        "David Rientjes" <rientjes@google.com>,
        "Dave Hansen" <dave@linux.vnet.ibm.com>,
        "Andrew Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] checkpatch.pl: Add check for task comm references
References: <1305665263-20933-1-git-send-email-john.stultz@linaro.org>
 <1305665263-20933-4-git-send-email-john.stultz@linaro.org>
Date: Tue, 17 May 2011 23:04:42 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vvm8t4xg3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <1305665263-20933-4-git-send-email-john.stultz@linaro.org>
User-Agent: Opera Mail/11.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 May 2011 22:47:43 +0200, John Stultz wrote:
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index d867081..a67ea69 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2868,6 +2868,13 @@ sub process {
>  			WARN("usage of NR_CPUS is often wrong - consider using  
> cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc\n" .  
> $herecurr);
>  		}
> +# check for current->comm usage
> +		our $common_comm_vars = qr{(?x:

It should by "my" not "our".

> +		        current|tsk|p|task|curr|chip|t|object|me
> +		)};

Also, I would stick it on a single line, ie.:

		my $comm_vars = qr/current|tsk|p|task|curr|chip|t|object|me/;

> +		if ($line =~ /\b($common_comm_vars)\s*->\s*comm\b/) {

The parens are not needed.

> +			WARN("comm access needs to be protected. Use get_task_comm, or  
> printk's \%ptc formatting.\n" . $herecurr);
> +		}

Empty line should be here.

>  # check for %L{u,d,i} in strings
>  		my $string;
>  		while ($line =~ /(?:^|")([X\t]*)(?:"|$)/g) {

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
