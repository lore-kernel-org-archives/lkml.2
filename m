Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205Ab1ETDKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 23:10:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793Ab1ETDKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 23:10:41 -0400
Message-ID: <4DD5DBA2.9060302@redhat.com>
Date: Fri, 20 May 2011 11:10:26 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Neil Horman <nhorman@redhat.com>
CC: Andy Gospodarek <andy@greyhouse.net>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Jay Vosburgh <fubar@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>, netdev@vger.kernel.org
Subject: Re: [V2 Patch net-next-2.6] netpoll: disable netpoll when enslave
 a device
References: <20110518105558.GA3203@hmsreliant.think-freely.org> <1305794393-20775-1-git-send-email-amwang@redhat.com> <20110519113127.GE21309@gospo.rdu.redhat.com> <20110519132533.GA6729@shamino.rdu.redhat.com>
In-Reply-To: <20110519132533.GA6729@shamino.rdu.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年05月19日 21:25, Neil Horman 写道:
> On Thu, May 19, 2011 at 07:31:27AM -0400, Andy Gospodarek wrote:
>> On Thu, May 19, 2011 at 04:39:53PM +0800, Amerigo Wang wrote:
>> [...]
>>> diff --git a/include/linux/notifier.h b/include/linux/notifier.h
>>> index 621dfa1..3d82867 100644
>>> --- a/include/linux/notifier.h
>>> +++ b/include/linux/notifier.h
>>> @@ -211,6 +211,7 @@ static inline int notifier_to_errno(int ret)
>>>   #define NETDEV_UNREGISTER_BATCH 0x0011
>>>   #define NETDEV_BONDING_DESLAVE  0x0012
>>>   #define NETDEV_NOTIFY_PEERS	0x0013
>>> +#define NETDEV_ENSLAVE		0x0014
>>>
>>>   #define SYS_DOWN	0x0001	/* Notify of system down */
>>>   #define SYS_RESTART	SYS_DOWN
>>
>> Neil just noted the same concern I had -- the asymmetry between
>> NETDEV_ENSLAVE and NETDEV_BONDING_DESLAVE bothers me a bit.  I also
>> don't really like the followup patch that uses 'ENSLAVE' in the bridging
>> code when we typically use that language for bonding only.
>>
>> What about changing NETDEV_BONDING_DESLAVE to NETDEV_RELEASE and create
>> NETDEV_JOIN instead of NETDEV_ENSLAVE?  I would prefer that or something
>> else that might use more generic language that could be applied to all
>> for stacked interfaces.
> JOIN and RELEASE (or perhaps LEAVE) sounds good to me.

Thanks, Andy and Neil! I will rename them to JOIN and RELEASE.
