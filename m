Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab1G1C7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 22:59:55 -0400
Received: from smtp-out.google.com ([74.125.121.67]:9667 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851Ab1G1C7s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 22:59:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=rISCUKgzHVp1SCG7VAoaEwV6h2IaAhejCKIQufYxj5pvKQT0/wNAEhtStoDYua1Rl
	NS6j3k19LjuVe0vNaujlw==
MIME-Version: 1.0
In-Reply-To: <1311606041.24752.3.camel@twins>
References: <20110721164325.231521704@google.com> <1311605881.24752.2.camel@twins>
 <1311606041.24752.3.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Wed, 27 Jul 2011 19:59:15 -0700
Message-ID: <CAPM31R+XduU0_8Oo5hKV3LS1Qb4cUT1oWnR-Zni1e+a=rsa_Vw@mail.gmail.com>
Subject: Re: [patch 00/18] CFS Bandwidth Control v7.2
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Jason Baron <jbaron@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 8:00 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2011-07-25 at 16:58 +0200, Peter Zijlstra wrote:
>> +               rcu_read_lock();
>> +               ret = walk_tg_tree_from(tg, tg_set_cfs_period_down, NULL, &period);
>> +               rcu_read_unlock();
>
> rcu over a mutex doesn't really work in mainline, bah..
>

Isn't this the other way around though?  We already hold the mutex so
we shouldn't be blocking within the RCU section.

rcu_lock here is only to stop nodes in the tree from disappearing
under us on the walk.

(FWIW this is the same as the rt_schedulable case)
