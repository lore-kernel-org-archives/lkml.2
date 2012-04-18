Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab2DRPAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 11:00:21 -0400
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:24066 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab2DRPAT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 11:00:19 -0400
Message-ID: <4F8ED6FE.1000104@wanadoo.fr>
Date: Wed, 18 Apr 2012 17:00:14 +0200
From: Pascal Chapperon <pascal.chapperon@wanadoo.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org
Subject: Re: RCU related performance regression in 3.3
References: <20120405123759.GE1963@zod.bos.redhat.com> <20120405140006.GB27672@linux.vnet.ibm.com> <1838583439.163624.1333635333132.JavaMail.www@wwinf1m19> <20120405143918.GE27672@linux.vnet.ibm.com> <588810225.17969.1333703883646.JavaMail.www@wwinf1g24> <20120410160706.GF2428@linux.vnet.ibm.com> <4F859E0E.8050408@wanadoo.fr> <20120412180432.GE2394@linux.vnet.ibm.com> <20120416210234.GA3490@linux.vnet.ibm.com> <4F8E8B58.1040203@wanadoo.fr> <20120418140108.GA6034@linux.vnet.ibm.com>
In-Reply-To: <20120418140108.GA6034@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 18/04/2012 16:01, Paul E. McKenney a écrit :
> On Wed, Apr 18, 2012 at 11:37:28AM +0200, Pascal Chapperon wrote:
>> Mount and umount operations are not slower with RCU_FAST_NO_HZ during
>> runtime; systemctl start and stop operations are also not slower. In
>> fact, i couldn't find a single operation slower during runtime with
>> RCU_FAST_NO_HZ.
>
> Your boot-time setup is such that all CPUs are online before the
> boot-time mount operations take place, right?
Yes :
[    0.242697] Brought up 8 CPUs
[    0.242699] Total of 8 processors activated (35118.33 BogoMIPS).

>  Struggling to understand
> how RCU can tell the difference between post-CPU-bringup boot time
> and run time...
>
systemd is controlling the whole boot process including mount
operation (apart root filesystem) and as I can see, uses heavily
sockets to do it (not to mention cpu-affinity). It controls also the
major part of umount operations. Is it possible that your patch hits
a systemd bug ?
What I don't understand is that systemd coexists well with
RCU_FAST_NO_HZ on a smaller laptop with older and much less powerful
cpu.
I'll do further tests on another machine.

Pascal

