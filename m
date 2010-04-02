Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab0DBA0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 20:26:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60835
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753108Ab0DBA0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 20:26:35 -0400
Date: Thu, 01 Apr 2010 17:26:35 -0700 (PDT)
Message-Id: <20100401.172635.38081142.davem@davemloft.net>
To: amwang@redhat.com
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org, jpirko@redhat.com,
       shemminger@vyatta.com, netdev@vger.kernel.org,
       bonding-devel@lists.sourceforge.net, fubar@us.ibm.com
Subject: Re: [Patch V3] bonding: fix potential deadlock in bond_uninit()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BB44BAC.2070304@redhat.com>
References: <20100401061014.4815.7341.sendpatchset@localhost.localdomain>
	<m1r5mzsnuh.fsf@fess.ebiederm.org>
	<4BB44BAC.2070304@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cong Wang <amwang@redhat.com>
Date: Thu, 01 Apr 2010 15:30:52 +0800

> Eric W. Biederman wrote:
>> Amerigo Wang <amwang@redhat.com> writes:
>> 
>>> bond_uninit() is invoked with rtnl_lock held, when it does
>>> destroy_workqueue()
>>> which will potentially flush all works in this workqueue, if we hold
>>> rtnl_lock
>>> again in the work function, it will deadlock.
>>>
>>> So move destroy_workqueue() to destructor where rtnl_lock is not held
>>> any more,
>>> suggested by Eric.
>> The error handling on creating a bond device needs to be updated as
>> well.
>> 
> 
> Done.

Applied, thanks.
