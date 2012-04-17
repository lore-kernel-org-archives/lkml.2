Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab2DQROb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 13:14:31 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:33658 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753704Ab2DQRO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 13:14:29 -0400
Message-ID: <4F8DCF27.4060106@xenotime.net>
Date: Tue, 17 Apr 2012 13:14:31 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, paul.gortmaker@windriver.com
Subject: Re: linux-next: Tree for Apr 17 (rcu)
References: <20120417144241.0d7dc5fde56b2a37ff0dcaba@canb.auug.org.au> <4F8DBD14.5000100@xenotime.net> <20120417163232.GG2404@linux.vnet.ibm.com>
In-Reply-To: <20120417163232.GG2404@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2012 09:32 AM, Paul E. McKenney wrote:

> On Tue, Apr 17, 2012 at 11:57:24AM -0700, Randy Dunlap wrote:
>> On 04/16/2012 09:42 PM, Stephen Rothwell wrote:
>>
>>> Hi all,
>>>
>>> Changes since 20120416:
>>>
>>> The rcu tree lost its build failure.
>>
>>
>> ERROR: "rcu_read_lock_nesting" [net/sctp/sctp.ko] undefined!
>> ERROR: "rcu_read_lock_nesting" [net/rds/rds.ko] undefined!
>> ERROR: "rcu_read_lock_nesting" [net/phonet/phonet.ko] undefined!
>> ERROR: "rcu_read_lock_nesting" [net/openvswitch/openvswitch.ko] undefined!
>> ERROR: "rcu_read_lock_nesting" [net/netfilter/xt_TCPMSS.ko] undefined!
>> ERROR: "rcu_read_lock_nesting" [net/netfilter/nfnetlink.ko] undefined!
>> ERROR: "rcu_read_lock_nesting" [net/netfilter/nf_conntrack.ko] undefined!
>> ERROR: "rcu_read_lock_nesting" [net/netfilter/ipset/ip_set.ko] undefined!
>> ERROR: "rcu_read_lock_nesting" [net/llc/llc2.ko] undefined!
>> ERROR: "rcu_read_lock_nesting" [net/l2tp/l2tp_ip.ko] undefined!
>> ERROR: "rcu_read_lock_nesting" [net/l2tp/l2tp_core.ko] undefined!
>> ERROR: "rcu_read_lock_nesting" [net/key/af_key.ko] undefined!
>> ERROR: "rcu_read_lock_nesting" [net/ipv4/ipip.ko] undefined!
>> ERROR: "rcu_read_lock_nesting" [net/decnet/decnet.ko] undefined!
>> ERROR: "rcu_read_lock_nesting" [net/core/netprio_cgroup.ko] undefined!
>> ERROR: "rcu_read_lock_nesting" [net/can/can.ko] undefined!
>> ERROR: "rcu_read_lock_nesting" [net/can/can-bcm.ko] undefined!
>> ERROR: "rcu_read_lock_nesting" [net/bridge/bridge.ko] undefined!
>> ERROR: "rcu_read_lock_nesting" [net/bluetooth/bluetooth.ko] undefined!
>> ERROR: "rcu_read_lock_nesting" [net/batman-adv/batman-adv.ko] undefined!
>> ERROR: "rcu_read_lock_nesting" [net/atm/atm.ko] undefined!
>> ERROR: "rcu_read_lock_nesting" [fs/gfs2/gfs2.ko] undefined!
>> ERROR: "rcu_read_lock_nesting" [drivers/net/vmxnet3/vmxnet3.ko] undefined!
>> ERROR: "rcu_read_lock_nesting" [drivers/input/joydev.ko] undefined!
>> ERROR: "rcu_read_lock_nesting" [drivers/char/tpm/tpm.ko] undefined!
>> ERROR: "rcu_read_lock_nesting" [drivers/char/ipmi/ipmi_msghandler.ko] undefined!
>> ERROR: "rcu_read_lock_nesting" [block/cfq-iosched.ko] undefined!
>> ERROR: "rcu_read_lock_nesting" [block/blk-cgroup.ko] undefined!
>>
>> on i386.
>>
>> Full randconfig file is attached.
> 
> Sigh!  I failed to add the exports.  Please see the following
> not-yet-tested patch.
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> rcu: Add exports for per-CPU variables used for inlining
> 
> The new rcu_read_lock_nesting and rcu_read_unlock_special per-CPU
> variables need to be accessible from modules to allow rcu_read_lock()
> and rcu_read_unlock() to continue to be used from modules.  This
> commit therefore adds the needed EXPORT_PER_CPU_SYMBOL_GPL()s.
> 
> Reported-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>


Works for me.  Thanks.

Acked-by: Randy Dunlap <rdunlap@xenotime.net>


> 
> diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
> index d52c68e..ef83774 100644
> --- a/kernel/rcupdate.c
> +++ b/kernel/rcupdate.c
> @@ -53,7 +53,9 @@
>  
>  #ifdef CONFIG_PREEMPT_RCU
>  DEFINE_PER_CPU(int, rcu_read_lock_nesting);
> +EXPORT_PER_CPU_SYMBOL_GPL(rcu_read_lock_nesting);
>  DEFINE_PER_CPU(int, rcu_read_unlock_special);
> +EXPORT_PER_CPU_SYMBOL_GPL(rcu_read_unlock_special);
>  #ifdef CONFIG_PROVE_RCU
>  DEFINE_PER_CPU(struct task_struct *, rcu_current_task);
>  #endif /* #ifdef CONFIG_PROVE_RCU */
> 



-- 
~Randy
