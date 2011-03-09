Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343Ab1CIMfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 07:35:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932209Ab1CIMfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 07:35:42 -0500
Message-ID: <4D7773E3.5050708@redhat.com>
Date: Wed, 09 Mar 2011 20:34:43 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andy Gospodarek <andy@greyhouse.net>
CC: linux-kernel@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        Jay Vosburgh <fubar@us.ibm.com>, netdev@vger.kernel.org
Subject: Re: [Patch V2] bonding: fix netpoll in active-backup mode
References: <1299578336-5888-1-git-send-email-amwang@redhat.com> <20110308212405.GX11864@gospo.rdu.redhat.com>
In-Reply-To: <20110308212405.GX11864@gospo.rdu.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年03月09日 05:24, Andy Gospodarek 写道:
> On Tue, Mar 08, 2011 at 05:58:56PM +0800, Amerigo Wang wrote:
>> V2: avoid calling slave_diable_netpoll() with write_lock_bh() held.
>>
>> netconsole doesn't work in active-backup mode, because we don't do anything
>> for nic failover in active-backup mode. We should disable netpoll on the
>> failing slave when it is detected down and enable netpoll when it becomes
>> the active slave.
>>
>> Tested by ifdown the current active slave and ifup it again for several times,
>> netconsole works well.
>>
>> Signed-off-by: WANG Cong<amwang@redhat.com>
>> Cc: Neil Horman<nhorman@tuxdriver.com>
>>
>
> It seems like you are going to a lot of trouble to fix a bug where
> netpoll will not be setup on any interface that is down when enslaved.
> That seems to be the only path that would not have slave->np setup
> properly at enslavement.
>
> Did you ever try just this?

That was my first thought, but I was over-worried about the failing slave.
This way should work too. Mind to send it as a normal patch? :)

Thanks!

