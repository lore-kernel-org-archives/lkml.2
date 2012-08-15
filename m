Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab2HODN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 23:13:27 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46299 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab2HODNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 23:13:25 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Sasha Levin <levinsasha928@gmail.com>
Cc: torvalds@linux-foundation.org, tj@kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@elte.hu, aarcange@redhat.com, ericvh@gmail.com,
        netdev@vger.kernel.org, josh@joshtriplett.org, eric.dumazet@gmail.com,
        mathieu.desnoyers@efficios.com, axboe@kernel.dk, agk@redhat.com,
        dm-devel@redhat.com, neilb@suse.de, ccaulfie@redhat.com,
        teigland@redhat.com, Trond.Myklebust@netapp.com, bfields@fieldses.org,
        fweisbec@gmail.com, jesse@nicira.com, venkat.x.venkatsubra@oracle.com,
        ejt@redhat.com, snitzer@redhat.com, edumazet@google.com,
        linux-nfs@vger.kernel.org, dev@openvswitch.org,
        rds-devel@oss.oracle.com, lw@cn.fujitsu.com
References: <1344961490-4068-1-git-send-email-levinsasha928@gmail.com>
	<1344961490-4068-3-git-send-email-levinsasha928@gmail.com>
	<87txw5hw0s.fsf@xmission.com> <502AF184.4010907@gmail.com>
	<87393phshy.fsf@xmission.com> <502AFCD5.6070104@gmail.com>
Date: Tue, 14 Aug 2012 20:13:01 -0700
In-Reply-To: <502AFCD5.6070104@gmail.com> (Sasha Levin's message of "Wed, 15
	Aug 2012 03:35:17 +0200")
Message-ID: <87obmchmpu.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+Ckg0PDEd41XS1+XSlu63leXKVjMlog1g=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Sasha Levin <levinsasha928@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 02/16] user_ns: use new hashtable implementation
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <levinsasha928@gmail.com> writes:

> On 08/15/2012 03:08 AM, Eric W. Biederman wrote:
>>> I can offer the following: I'll write a small module that will hash 1...10000
>>> > into a hashtable which uses 7 bits (just like user_ns) and post the distribution
>>> > we'll get.
>> That won't hurt.  I think 1-100 then 1000-1100 may actually be more
>> representative.  Not that I would mind seeing the larger range.
>> Especially since I am in the process of encouraging the use of more
>> uids.
>> 
>
> Alrighty, the results are in (numbers are objects in bucket):
>
> For the 0...10000 range:
>
> Average: 78.125
> Std dev: 1.4197704151
> Min: 75
> Max: 80
>
>
> For the 1...100 range:
>
> Average: 0.78125
> Std dev: 0.5164613088
> Min: 0
> Max: 2
>
>
> For the 1000...1100 range:
>
> Average: 0.7890625
> Std dev: 0.4964812206
> Min: 0
> Max: 2
>
>
> Looks like hash_32 is pretty good with small numbers.

Yes hash_32 seems reasonable for the uid hash.   With those long hash
chains I wouldn't like to be on a machine with 10,000 processes with
each with a different uid, and a processes calling setuid in the fast
path.

The uid hash that we are playing with is one that I sort of wish that
the hash table could grow in size, so that we could scale up better.

Aw well.  Most of the time we only have a very small number of uids
in play, so it doesn't matter at this point.

Eric

