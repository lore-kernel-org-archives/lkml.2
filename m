Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318Ab1CIMdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 07:33:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932198Ab1CIMdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 07:33:38 -0500
Message-ID: <4D77735F.30908@redhat.com>
Date: Wed, 09 Mar 2011 20:32:31 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: linux-kernel@vger.kernel.org, Jay Vosburgh <fubar@us.ibm.com>,
        netdev@vger.kernel.org
Subject: Re: [Patch V2] bonding: fix netpoll in active-backup mode
References: <1299578336-5888-1-git-send-email-amwang@redhat.com> <20110308134348.GB19072@hmsreliant.think-freely.org>
In-Reply-To: <20110308134348.GB19072@hmsreliant.think-freely.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年03月08日 21:43, Neil Horman 写道:
> On Tue, Mar 08, 2011 at 05:58:56PM +0800, Amerigo Wang wrote:
>> V2: avoid calling slave_diable_netpoll() with write_lock_bh() held.
>>
>> netconsole doesn't work in active-backup mode, because we don't do anything
>> for nic failover in active-backup mode. We should disable netpoll on the
>> failing slave when it is detected down and enable netpoll when it becomes
>> the active slave.
>>
> You still haven't explained why it needs to be this way.  what exactly is the
> shortcomming with leaving netpoll enabled on all slaves, regardless of state?
> It should be sufficient if, during a failover in a mode where the inactive slave
> should not tx data, that you simply clear the slave __LINK_STATE_START bit.  That will
> prevent higher layers from sending any queued data without you needing to muck
> about with netpoll state.
>

Oh, actually I thought the struct net_device of the failing interface will be freed,
but that is not true...

So, yeah, I think just setup netpoll in bond_netpoll_setup() should be sufficient.

Thanks.
