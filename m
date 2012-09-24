Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab2IXNn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 09:43:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65533 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab2IXNn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 09:43:27 -0400
Date: Mon, 24 Sep 2012 22:43:22 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH RFC 2/2] kvm: Be courteous to other VMs in overcommitted
 scenario in PLE handler
Message-Id: <20120924224322.f40fba7934383f939e92b78c@gmail.com>
In-Reply-To: <505CA7C4.4080307@linux.vnet.ibm.com>
References: <20120921115942.27611.67488.sendpatchset@codeblue>
	<20120921120019.27611.66093.sendpatchset@codeblue>
	<20120921224636.18cccbd6c33b161975f2a8cb@gmail.com>
	<505C712F.4060800@redhat.com>
	<505CA7C4.4080307@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2012 23:15:40 +0530
Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> wrote:

> >> How about doing cond_resched() instead?
> >
> > Actually, an actual call to yield() may be better.
> >
> > That will set scheduler hints to make the scheduler pick
> > another task for one round, while preserving this task's
> > top position in the runqueue.
> 
> I am not a scheduler expert, but I am also inclined towards
> Rik's suggestion here since we set skip buddy here. Takuya?
> 

Yes, I think it's better.
But I hope that experts in Cc will suggest the best way.

Thanks,
	Takuya
