Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab1EIVJY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:09:24 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38743 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab1EIVJW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:09:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=URFtVm0okHlTKlzk470qieXR9TewicyGivRzIe/GySJtX2O/N6KPZFjUvWwRd8yudy
         aMSHlaiiTfYvsRR/u4GknzWhNn4D88PsbrldAGZKUcDiIp8bESl6q0aZ2gEYobXBmlqO
         iYqkeSFgnLokT8MkSIKHU46yHPfXpMh16NLAg=
MIME-Version: 1.0
In-Reply-To: <20110509073636.GA18247@elte.hu>
References: <20110508151848.GA21906@linux.vnet.ibm.com>
	<20110509073636.GA18247@elte.hu>
Date: Mon, 9 May 2011 14:09:21 -0700
X-Google-Sender-Auth: WoQwzxkk1d3x6RV8ArutwU_NI2U
Message-ID: <BANLkTin82W0yZ5Nvv3Dp62X1eou_GxZ6EA@mail.gmail.com>
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 9, 2011 at 12:36 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
>
>> Hello, Ingo,
>>
>> This pull request covers RCU chnages for 2.6.40.  The major new features
>> are RCU priority boosting and the addition of kfree_rcu(), the latter
>> courtesy of Lai Jiangshan.  These two features cover well over half
>> of the commits.  There are a number of smaller features and bug fixes.
>> All have been sent to LKML in the following batches:
>>
>> 0.    https://lkml.org/lkml/2011/2/22/660: RCU priority boosting preview
>> 1.    https://lkml.org/lkml/2011/5/1/19: RCU priority boosting, kfree_rcu()
>> 2.    https://lkml.org/lkml/2011/5/2/40: More uses of kfree_rcu()
>> 3.    https://lkml.org/lkml/2011/5/8/60: miscellaneous
>>
>> The kfree_rcu() uses in the pull request have Acked-by:s from the
>> maintainers.  I have some additional kfree_rcu() requests that lack
>> Acked-by:s, and I will deal with these later.
>>
>> These channges are available in the -rcu git repository at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/next
>
> Pulled, thanks a lot Paul!
>

it seems with this one in tip, my 8 sockets test setup will report cpu stall.

after hard code to enable rcu_cpu_stall_suppress

Index: linux-2.6/kernel/rcutree.c
===================================================================
--- linux-2.6.orig/kernel/rcutree.c
+++ linux-2.6/kernel/rcutree.c
@@ -174,7 +174,7 @@ module_param(blimit, int, 0);
 module_param(qhimark, int, 0);
 module_param(qlowmark, int, 0);

-int rcu_cpu_stall_suppress __read_mostly;
+int rcu_cpu_stall_suppress __read_mostly = 1;
 module_param(rcu_cpu_stall_suppress, int, 0644);

 static void force_quiescent_state(struct rcu_state *rsp, int relaxed);

will get system hang after pnp ACPI init.

Thanks

Yinghai
