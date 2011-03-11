Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab1CKOgJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 09:36:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735Ab1CKOgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 09:36:06 -0500
Date: Fri, 11 Mar 2011 09:35:57 -0500
From: Andy Gospodarek <andy@greyhouse.net>
To: Cong Wang <amwang@redhat.com>
Cc: Andy Gospodarek <andy@greyhouse.net>, linux-kernel@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>, Jay Vosburgh <fubar@us.ibm.com>,
        netdev@vger.kernel.org
Subject: Re: [Patch V2] bonding: fix netpoll in active-backup mode
Message-ID: <20110311143557.GY11864@gospo.rdu.redhat.com>
References: <1299578336-5888-1-git-send-email-amwang@redhat.com> <20110308212405.GX11864@gospo.rdu.redhat.com> <4D7773E3.5050708@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D7773E3.5050708@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 08:34:43PM +0800, Cong Wang wrote:
> 于 2011年03月09日 05:24, Andy Gospodarek 写道:
>> On Tue, Mar 08, 2011 at 05:58:56PM +0800, Amerigo Wang wrote:
>>> V2: avoid calling slave_diable_netpoll() with write_lock_bh() held.
>>>
>>> netconsole doesn't work in active-backup mode, because we don't do anything
>>> for nic failover in active-backup mode. We should disable netpoll on the
>>> failing slave when it is detected down and enable netpoll when it becomes
>>> the active slave.
>>>
>>> Tested by ifdown the current active slave and ifup it again for several times,
>>> netconsole works well.
>>>
>>> Signed-off-by: WANG Cong<amwang@redhat.com>
>>> Cc: Neil Horman<nhorman@tuxdriver.com>
>>>
>>
>> It seems like you are going to a lot of trouble to fix a bug where
>> netpoll will not be setup on any interface that is down when enslaved.
>> That seems to be the only path that would not have slave->np setup
>> properly at enslavement.
>>
>> Did you ever try just this?
>
> That was my first thought, but I was over-worried about the failing slave.
> This way should work too. Mind to send it as a normal patch? :)
>

I'm happy to submit the patch if it works in your environment.

I do not think anyone likes un-tested patches.

