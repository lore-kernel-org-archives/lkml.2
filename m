Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab1D3TnY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 15:43:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039Ab1D3TnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 15:43:23 -0400
Message-ID: <4DBC6654.5030003@redhat.com>
Date: Sat, 30 Apr 2011 22:43:16 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
        mtosatti@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] rcu: export rcu_note_context_switch() function
References: <1303984323-3203-1-git-send-email-gleb@redhat.com> <1303984323-3203-2-git-send-email-gleb@redhat.com> <20110429083618.GL2191@linux.vnet.ibm.com> <20110429083904.GA12987@linux.vnet.ibm.com> <20110429180239.GA32566@redhat.com> <20110430125928.GJ2297@linux.vnet.ibm.com>
In-Reply-To: <20110430125928.GJ2297@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2011 03:59 PM, Paul E. McKenney wrote:
> >  That will work, but does making rcu_note_context_switch() out of line
> >  actually increase kernel size? The function is called in two places
> >  currently, so by making it out of line we make two calling site smaller.
> >  Will measure it next week.
>
> One thing to keep in mind...  Calling an out-of-line function from
> KVM requires an export, each of which significantly increases TINY_RCU's
> memory footprint.

I would expect that most kvm configs will actually be smp (perhaps with 
an exception for embedded ppc).

A completely random idea - how about trimming exports that aren't 
actually used?  so if you have a minimal setup you only get the hit if 
you actually use kvm.

(The trimming would need to be optional so external modules can continue 
to work for those who want them)


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

