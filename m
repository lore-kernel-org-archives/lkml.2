Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab1EMGdq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 02:33:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65329 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab1EMGdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 02:33:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=MT4bBETRXSOgRPuMykEsDXrL4aSADmHhjCYADDdcZk7azsce7kAbNZJnJi682k/DQP
         OLt+rM1FnqWQxIYGMc9AMp4784TwuGlv51ST1Z4rhO/yNYFrnPs+DqVt10ozeh5T4mDK
         EQOhpED67VdWoOqL/JshM+UkkaCzYztRxcESY=
Message-ID: <4DCCD0C3.9090908@gmail.com>
Date: Fri, 13 May 2011 08:33:39 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: LKML <linux-kernel@vger.kernel.org>, "Ted Ts'o" <tytso@mit.edu>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] checkpatch.pl: Add check for current->comm references
References: <1305241371-25276-1-git-send-email-john.stultz@linaro.org> <1305241371-25276-4-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1305241371-25276-4-git-send-email-john.stultz@linaro.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2011 01:02 AM, John Stultz wrote:
> Now that accessing current->comm needs to be protected,
> avoid new current->comm usage by adding a warning to
> checkpatch.pl.
> 
> Fair warning: I know zero perl, so this was written in the
> style of "monkey see, monkey do". It does appear to work
> in my testing though.
> 
> Close review and feedback would be appreciated.
> 
> CC: Ted Ts'o <tytso@mit.edu>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: David Rientjes <rientjes@google.com>
> CC: Dave Hansen <dave@linux.vnet.ibm.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: linux-mm@kvack.org
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  scripts/checkpatch.pl |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index d867081..9d2eab5 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2868,6 +2868,10 @@ sub process {
>  			WARN("usage of NR_CPUS is often wrong - consider using cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc\n" . $herecurr);
>  		}
>  
> +# check for current->comm usage
> +		if ($line =~ /current->comm/) {

This should be something like \b(current|task|tsk|t)->comm\b to catch
also non-current comm accesses...

> +			WARN("comm access needs to be protected. Use get_task_comm, or printk's \%ptc formatting.\n" . $herecurr);
> +		}
>  # check for %L{u,d,i} in strings
>  		my $string;
>  		while ($line =~ /(?:^|")([X\t]*)(?:"|$)/g) {


-- 
js
