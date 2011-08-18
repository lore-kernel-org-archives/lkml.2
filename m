Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab1HRApF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 20:45:05 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:43118 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754190Ab1HRApC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 20:45:02 -0400
Date: Wed, 17 Aug 2011 17:44:59 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
        mtosatti@redhat.com, kvm@vger.kernel.org
Subject: Re: RCU treating guest mode just like it does user-mode execution
Message-ID: <20110818004459.GQ2419@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110817204327.GA10633@linux.vnet.ibm.com>
 <20110817215015.GA6423@redhat.com>
 <20110817220520.GN2419@linux.vnet.ibm.com>
 <20110817235529.GA8163@redhat.com>
 <20110818002513.GP2419@linux.vnet.ibm.com>
 <4E4C5CBE.5040102@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4C5CBE.5040102@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 05:28:46PM -0700, Avi Kivity wrote:
> On 08/17/2011 05:25 PM, Paul E. McKenney wrote:
> >>  >
> >>  Wouldn't scheduling-clock interrupt kick vcpu out of a guest mode much
> >>  earlier then 30 seconds?
> >
> >The scheduling-clock interrupt would happen, but I do not know whether
> >or not it would kick the vcpu out of guest mode in such a way that
> >would result in RCU thinking that the CPU has passed through a quiescent
> >state.
> >
> 
> The result can only be one of
> 
>   reenter guest (and rcu_virt_note_context_switch)
>   schedule()
>   exit to userspace

Very good, thank you both for bearing with me on this!

							Thanx, Paul
