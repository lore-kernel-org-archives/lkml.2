Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080Ab2DTOp7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 10:45:59 -0400
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:23877 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757020Ab2DTOpz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 10:45:55 -0400
Message-ID: <4F91769B.7000709@wanadoo.fr>
Date: Fri, 20 Apr 2012 16:45:47 +0200
From: Pascal Chapperon <pascal.chapperon@wanadoo.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org
Subject: Re: RCU related performance regression in 3.3
References: <1838583439.163624.1333635333132.JavaMail.www@wwinf1m19> <20120405143918.GE27672@linux.vnet.ibm.com> <588810225.17969.1333703883646.JavaMail.www@wwinf1g24> <20120410160706.GF2428@linux.vnet.ibm.com> <4F859E0E.8050408@wanadoo.fr> <20120412180432.GE2394@linux.vnet.ibm.com> <20120416210234.GA3490@linux.vnet.ibm.com> <4F8E8B58.1040203@wanadoo.fr> <20120418140108.GA6034@linux.vnet.ibm.com> <4F8ED6FE.1000104@wanadoo.fr> <20120418152301.GF6034@linux.vnet.ibm.com>
In-Reply-To: <20120418152301.GF6034@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 18/04/2012 17:23, Paul E. McKenney a écrit :
>> systemd is controlling the whole boot process including mount
>> operation (apart root filesystem) and as I can see, uses heavily
>> sockets to do it (not to mention cpu-affinity). It controls also the
>> major part of umount operations. Is it possible that your patch hits
>> a systemd bug ?
>
> Is it possible that systemd is using network operations that include
> synchronize_rcu()?  Then if you did the same operation from the
> command line at runtime, you might not see the slowdown.
>
> Is it possible for you to convince systemd to collect RCU event tracing
> during the slow operation?  RCU event tracing is available under
> /sys/kernel/debug/tracing/rcu.
>
-
Paul, thank you for these suggestions : I'll manage to enable RCU event
tracing immediately after mounting debugfs (systemd permits custom
units). As debugfs is mounted early in the boot sequence, maybe I'll
catch something.

Pascal

