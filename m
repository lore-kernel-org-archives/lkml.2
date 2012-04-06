Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab2DFJSI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 05:18:08 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:28952 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab2DFJSG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 05:18:06 -0400
Date: Fri, 6 Apr 2012 11:18:03 +0200 (CEST)
From: Pascal Chapperon <pascal.chapperon@wanadoo.fr>
Reply-To: Pascal Chapperon <pascal.chapperon@wanadoo.fr>
To: paulmck@linux.vnet.ibm.com
Cc: Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org
Message-ID: <588810225.17969.1333703883646.JavaMail.www@wwinf1g24>
In-Reply-To: <20120405143918.GE27672@linux.vnet.ibm.com>
References: <20120404152726.GB16299@zod.bos.redhat.com>
 <20120404213633.GI2302@linux.vnet.ibm.com>
 <20120405123759.GE1963@zod.bos.redhat.com>
 <20120405140006.GB27672@linux.vnet.ibm.com>
 <1838583439.163624.1333635333132.JavaMail.www@wwinf1m19>
 <20120405143918.GE27672@linux.vnet.ibm.com>
Subject: Re: RCU related performance regression in 3.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [80.12.110.201]
X-WUM-FROM: |~|
X-WUM-TO: |~|
X-WUM-CC: |~||~||~|
X-WUM-REPLYTO: |~|
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Message du 05/04/12 16:40
> De : "Paul E. McKenney" 
> A : "Pascal CHAPPERON" 
> Copie à : "Josh Boyer" , linux-kernel@vger.kernel.org, kernel-team@fedoraproject.org
> Objet : Re: RCU related performance regression in 3.3
> 
> On Thu, Apr 05, 2012 at 04:15:33PM +0200, Pascal CHAPPERON wrote:
> > Hello,
> > 
> > I didn't notice any significant slowdown while the system is up and running. 
A full kernel compilation (make -j 16) takes 14mn with both 3.2.10 and 3.3.0.
> 
> OK, so the natural approach is to disable CONFIG_RCU_FAST_NO_HZ at
> boot time. Unfortunately, you appear to need it to remain disabled
> through at least filesystem mounting, which if I understand correctly
> happens long after system_state gets set to SYSTEM_RUNNING.
> 
In fact, I need it to remain disable until all the systemd units are completed. 
Some units, such as NetworkManager can take longer time to complete with
RCU_FAST_NO_HZ enabled.
And i need it to be disabled at shutdown, as umounting cgroups, sysfs, etc.
plus old-root mounting can take one plain second for each umounting.

> If RCU has some way to find out when init is complete, I can easily
> make it so that CONFIG_RCU_FAST_NO_HZ optimizes for speed during boot
> and energy efficiency during runtime.
> 
I said that I didn't noticed significant slowdown during runtime, but my
laptop usage is basic. Some specific tasks similar to systemd may 
perhaps be impacted by this feature.
I can test a task/program that could stress RCU_FAST_NO_HZ if any ?

> One thing I could easily do would be to provide a sysfs parameter or
> some such that allows the boot process to enable energy-efficiency
> mode at runtime. I would much prefer to make this automatic, though.
> 
So the feature is disabled until you trigger a sysfs parameter, and can be
disabled before shutdown ? It would be fair, at least for hardware like my
own.

> Other thoughts?
> 
Do you think that the culprit is a buggy hardware in my laptop, or the 
number of cpu/threads ?

> Thanx, Paul
> 

Resent in plain text because rejected. Sorry, i forgot the rules.

Pascal
