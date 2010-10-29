Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760289Ab0J2IKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 04:10:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54325 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab0J2IKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 04:10:04 -0400
Date: Fri, 29 Oct 2010 10:10:03 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H.Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        LKLM <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] [x86, next] Add mce_sys_info interface for debug.
Message-ID: <20101029081003.GB11149@basil.fritz.box>
References: <4CCA50AF.1030302@np.css.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CCA50AF.1030302@np.css.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 01:42:23PM +0900, Jin Dongming wrote:
> Add mce_sys_info interface for testing mce.
> 
> Following is the reason why the interface is needed:
>   1. Sometimes before testing mce, we want to know the basic
>      information of mce on the test machine. Though there are
>      some provided interfaces, there are some kernel variables
>      which could not be known still.

That doesn't make sense to me. AFAIK everything is either available
in sysfs or printed in the kernel log or can be known by knowing 
the hardware.

>   2. When we inject mce data to test mce, the value of some
>      interfaces may be changed. It is hard for everybody to confirm
>      all the information of mce on the system.
> 
> This interface could help us know what has happened and make mce test
> become easier.


The new interface seems overkill to me.

> 
> The content of mce_sys_info will be like following:
> 
>   MCE status:                      Original/(Current) Value
>       mce_disabled:                N

Well you should know if you set that. It's also visible
in the kernel log.

> 
>       mce_ser:                     0/1

That should be known or can be read directly.

>       tolerant:                    1/1
>       panic_on_oops:               0/0
>       monarch_timeout:             1000000/1000000 us
>       mce_ignore_ce:               0/0
>       mce_cmci_disabled:           N/N

These are all in sysfs or in the command line.



> 
>   MCG Register:
>       CAP_Reg_Val           BANKS    EXT_CNT    FUNCTIONS
>       0x0000000000000806    0x06     0x00       TES

You can just read that from /dev/cpu/*/msr if you really want it.
No need to bloat the kernel.

-Andi
