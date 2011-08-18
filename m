Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab1HRA2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 20:28:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513Ab1HRA2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 20:28:50 -0400
Message-ID: <4E4C5CBE.5040102@redhat.com>
Date: Wed, 17 Aug 2011 17:28:46 -0700
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
        mtosatti@redhat.com, kvm@vger.kernel.org
Subject: Re: RCU treating guest mode just like it does user-mode execution
References: <20110817204327.GA10633@linux.vnet.ibm.com> <20110817215015.GA6423@redhat.com> <20110817220520.GN2419@linux.vnet.ibm.com> <20110817235529.GA8163@redhat.com> <20110818002513.GP2419@linux.vnet.ibm.com>
In-Reply-To: <20110818002513.GP2419@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2011 05:25 PM, Paul E. McKenney wrote:
> >  >
> >  Wouldn't scheduling-clock interrupt kick vcpu out of a guest mode much
> >  earlier then 30 seconds?
>
> The scheduling-clock interrupt would happen, but I do not know whether
> or not it would kick the vcpu out of guest mode in such a way that
> would result in RCU thinking that the CPU has passed through a quiescent
> state.
>

The result can only be one of

   reenter guest (and rcu_virt_note_context_switch)
   schedule()
   exit to userspace

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

