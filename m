Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab0KVKlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 05:41:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754336Ab0KVKln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 05:41:43 -0500
Message-ID: <4CEA48DF.2080605@redhat.com>
Date: Mon, 22 Nov 2010 12:41:35 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Gregory Haskins <ghaskins@novell.com>,
        Chris Lalancette <clalance@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: fast-path msi injection with irqfd
References: <20101118170907.GA14039@redhat.com>
In-Reply-To: <20101118170907.GA14039@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2010 07:09 PM, Michael S. Tsirkin wrote:
> Store irq routing table pointer in the irqfd object,
> and use that to inject MSI directly without bouncing out to
> a kernel thread.
>
> While we touch this structure, rearrange irqfd fields to make fastpath
> better packed for better cache utilization.
>
> This also adds some comments about locking rules and rcu usage in code.
>
> Some notes on the design:
> - Use pointer into the rt instead of copying an entry,
>    to make it possible to use rcu, thus side-stepping
>    locking complexities.  We also save some memory this way.
> - Old workqueue code is still used for level irqs.
>    I don't think we DTRT with level anyway, however,
>    it seems easier to keep the code around as
>    it has been thought through and debugged, and fix level later than
>    rip out and re-instate it later.
>

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

