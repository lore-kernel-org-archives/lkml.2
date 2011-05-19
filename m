Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab1ESFOB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 01:14:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729Ab1ESFOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 01:14:00 -0400
Message-ID: <4DD4A6F9.4010002@redhat.com>
Date: Thu, 19 May 2011 13:13:29 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: linux-kernel@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
        Jay Vosburgh <fubar@us.ibm.com>, Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Dobriyan <adobriyan@gmail.com>, Ferenc Wagner <wferi@niif.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Ian Campbell <ian.campbell@citrix.com>, netdev@vger.kernel.org
Subject: Re: [Patch net-next-2.6] netpoll: disable netpoll when enslave a
 device
References: <1305712845-11762-1-git-send-email-amwang@redhat.com> <20110518105558.GA3203@hmsreliant.think-freely.org>
In-Reply-To: <20110518105558.GA3203@hmsreliant.think-freely.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年05月18日 18:56, Neil Horman 写道:
> On Wed, May 18, 2011 at 06:00:35PM +0800, Amerigo Wang wrote:
...
>> -			case NETDEV_GOING_DOWN:
>>   			case NETDEV_BONDING_DESLAVE:
>> +			case NETDEV_ENSLAVE:
>>   				nt->enabled = 0;
>>   				stopped = true;
>>   				break;
> This wasn't introduced by this patch, but looking at it made me realize that
> nt->enabled, if it passes through this code path, doesn't properly track weather
> or not netpoll_setup has been called on this interface.  If you look at
> drop_netconsole_target, you'll see we only call netpoll_cleanup_target if
> nt->enabled is set.  We should probably change the nt->enabled check there, and
> in store_enabled to be if (nt->np.dev), like we do in the NETDEV_UNREGISTER case
> in netconsole_netdev_event.

Yeah, also note that we can change ->enabled via configfs too.
I guess we probably need to fix this in another patch...


>> +#define NETDEV_ENSLAVE		0x0014
>>
> Nit:
> Shouldn't this be NETDEV_BONDING_ENSLAVE, to keep it in line with
> NETDEV_BONDING_DESLAVE above?

Actually that is my first thought, but I plan to use this in bridge
case too, because using netconsole on a device underlying a bridge
makes little sense too. Thus, I prefer NETDEV_ENSLAVE to
NETDEV_BONDING_ENSLAVE.

>
>>   #define SYS_DOWN	0x0001	/* Notify of system down */
>>   #define SYS_RESTART	SYS_DOWN
>>
>
>
> Other than those two points, this looks good to me

Thanks for review.
