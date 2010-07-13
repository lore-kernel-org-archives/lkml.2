Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab0GMWc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 18:32:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35356 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab0GMWc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 18:32:56 -0400
X-Authority-Analysis: v=1.1 cv=o8sBXTxWt3Y8I13SYZ0pmcTcOViZ+nX/QX6HkgGmvUU= c=1 sm=0 a=MzoIMbBfYF4A:10 a=hO-oPbc3tlwA:10 a=kj9zAlcOel0A:10 a=Nqdp4+S2FArj7gZzHVn+tA==:17 a=Dl0CFYAjAAAA:8 a=W2dsR15lED0eKjLB0wAA:9 a=I_9Gh8hpR2SQzO9zMqYIxMO9cx8A:4 a=CjuIK1q_8ugA:10 a=HfSKAa7qCvcA:10 a=suZm_t7RJsjZ8FWZ:21 a=KEcPHwYxAfIcpQ6j:21 a=Nqdp4+S2FArj7gZzHVn+tA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.120.198.24
Date: Tue, 13 Jul 2010 17:34:50 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@openvz.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.osdl.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: [PATCH] pidns: Fix wait for zombies to be reaped in
 zap_pid_ns_processes
Message-ID: <20100713223450.GA16889@hallyn.com>
References: <20100625220713.GA31123@us.ibm.com>
 <m1r5jd5l0v.fsf_-_@fess.ebiederm.org>
 <m1mxu15kv4.fsf_-_@fess.ebiederm.org>
 <20100709121425.GB18586@hawkmoon.kerlabs.com>
 <m1lj9k4xfx.fsf@fess.ebiederm.org>
 <20100709141324.GC18586@hawkmoon.kerlabs.com>
 <m1aaq04ph2.fsf_-_@fess.ebiederm.org>
 <20100711141406.GD18586@hawkmoon.kerlabs.com>
 <m1tyo4shas.fsf_-_@fess.ebiederm.org>
 <20100713214234.GA21042@hawkmoon.kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100713214234.GA21042@hawkmoon.kerlabs.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Louis Rilling (Louis.Rilling@kerlabs.com):
> Hi Eric,
> 
> On 12/07/10 11:09 -0700, Eric W. Biederman wrote:
> This patch looks like it is working (only a small RCU issue shown below). I
> couldn't try it yet though.
> 
> I must admit that I am using a similar back-off solution in Kerrighed (not to
> solve the issue of proc_flush_task(), but for one of the reasons that you stated
> above: we want to be sure that all tasks of the namespace have been reaped), but
> I considered it too ugly to propose it for Linux ;)
> 
> That said, this is probably the least intrusive solution we have seen yet.

Yeah I haven't had a chance to look at it in detail, but this looks
right.  Thanks, Eric.

-serge
