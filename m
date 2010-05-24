Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab0EXB46 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 21:56:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64436 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754793Ab0EXB44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 21:56:56 -0400
Message-ID: <4BF9DCB7.8040308@cn.fujitsu.com>
Date: Mon, 24 May 2010 09:56:07 +0800
From: Shan Wei <shanwei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Julien BLACHE <jb@jblache.org>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [regression] fib6_del() bug from 2.6.34-rc1 still present in
 2.6.34
References: <87632g53tx.fsf@sonic.technologeek.org>
In-Reply-To: <87632g53tx.fsf@sonic.technologeek.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julien BLACHE wrote, at 05/22/2010 11:55 PM:
> Hi,
> 
> [subscribed to lkml but not netdev, Cc me on replies]
> 
> I'm seeing a warning in fib6_del() that is very close to what was
> reported by Emil S Tantilov back in march/april for 2.6.34-rc1:
> 
> <http://kerneltrap.org/mailarchive/linux-netdev/2010/4/9/6274401/thread>
> 
> It looks like there hasn't been a fix, other than what was mentioned in
> this thread for net-next and Emil reported that it did not fix it for
> him. So it looks like it's still there, alive and kicking.
> 
> This is the warning I'm getting:

I saw the warning on 2.6.34-rc3. But on net-next tree the warning disappeared.
So I think the bug is fixed in net-next tree. My NIC driver is r8169.

The net-next tree is newer than 2.6.34, maybe the fix is not queued to 2.6.34.
So the warning also be present in 2.6.34.
Can you try net-next tree firstly?

-- 
Best Regards
-----
Shan Wei


> 
> ------------[ cut here ]------------
> WARNING: at net/ipv6/ip6_fib.c:1160 fib6_del+0x506/0x5b0()
> Hardware name: MacBookPro2,2
> Modules linked in: sco bnep rfcomm l2cap crc16 cpufreq_userspace cpufreq_powersave cpufreq_conservative nfsd nfs lockd auth_rpcgss sunrpc uinput btusb ath9k ath9k_common mac80211 ath9k_hw ath isight_firmware joydev cfg80211 i2c_i801 ohci1394 ieee1394 [last unloaded: scsi_wait_scan]
> Pid: 4020, comm: ifconfig Not tainted 2.6.34 #1
> Call Trace:
>  [<ffffffff810389d3>] ? warn_slowpath_common+0x73/0xb0
>  [<ffffffff8142f956>] ? fib6_del+0x506/0x5b0
>  [<ffffffff8102ceb3>] ? __wake_up+0x43/0x70
>  [<ffffffff813c68ef>] ? netlink_broadcast+0x21f/0x410
>  [<ffffffff8142c2ab>] ? __ip6_del_rt+0x4b/0x80
>  [<ffffffff8142c436>] ? ip6_del_rt+0x26/0x30
>  [<ffffffff81426dff>] ? __ipv6_ifa_notify+0x15f/0x200
>  [<ffffffff81428d99>] ? addrconf_ifdown+0x159/0x350
>  [<ffffffff8142915d>] ? addrconf_notify+0xed/0x920
>  [<ffffffff81043d33>] ? lock_timer_base+0x33/0x70
>  [<ffffffff810445ab>] ? mod_timer+0x11b/0x1a0
>  [<ffffffff81054826>] ? notifier_call_chain+0x46/0x70
>  [<ffffffff813b1ae5>] ? __dev_notify_flags+0x65/0x90
>  [<ffffffff813b1b4b>] ? dev_change_flags+0x3b/0x70
>  [<ffffffff813fd2a2>] ? devinet_ioctl+0x602/0x750
>  [<ffffffff813a12ea>] ? T.945+0x1a/0x50
>  [<ffffffff813a1589>] ? sock_ioctl+0x59/0x2a0
>  [<ffffffff810bee55>] ? vfs_ioctl+0x35/0xd0
>  [<ffffffff810bf018>] ? do_vfs_ioctl+0x88/0x570
>  [<ffffffff810bf549>] ? sys_ioctl+0x49/0x80
>  [<ffffffff810023eb>] ? system_call_fastpath+0x16/0x1b
> ---[ end trace b5a833c8e5539431 ]---
> 
> I can reliably reproduce it on both ath9k and sky2 with the
> following sequence:
> 
>  # ifconfig eth0 up
>  # ifconfig eth0 add 2001:7a8:5dd7:123::12/64
>  # ifconfig eth0 down
>  # ifconfig eth0 up
>  # ifconfig eth0 add 2001:7a8:5dd7:123::12/64 <=== fails
>  # ifconfig eth0 down <=== triggers the warning
> 
> Note that this sequence is equivalent to:
>  # ifup eth0
>  # ifdown eth0
>  # ifup eth0 (will fail because it cannot add the v6 address)
>  # ifconfig eth0 down
> 
> This regression breaks ifupdown as it always tries to add the v6 address
> when configuring the interface. It's a behaviour change compared to
> previous kernel versions.
> 
> It looks like triggering this warning a couple times (3-4) in a row ends
> up locking up the machine, too.
> 
> I can test patches etc.
> 
> JB.
> 


