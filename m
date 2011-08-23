Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab1HWOKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 10:10:05 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:47023 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab1HWOKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 10:10:00 -0400
Subject: Re: [PATCH 0/2] Send a SIGCHLD to the init's pid namespace parent
 when reboot
From: Greg Kurz <gkurz@fr.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Bruno =?ISO-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        containers@lists.linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110823133302.GA19582@redhat.com>
References: <20110814161707.GB30846@redhat.com>
	 <20110814213642.GB13799@hallyn.com>	<20110815144744.GA9660@redhat.com>
	 <4E4DA461.8030006@free.fr>	<20110819152416.GA17034@redhat.com>
	 <4E524B73.3050704@free.fr>	<20110822154448.GA8527@redhat.com>
	 <20110822183134.10390b46@neptune.home>	<20110822173949.GA13242@redhat.com>
	 <20110822211716.7c141d5c@neptune.home>  <20110823133302.GA19582@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Aug 2011 16:09:26 +0200
Message-ID: <1314108566.3465.29.camel@bahia.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-23 at 15:33 +0200, Oleg Nesterov wrote:
> [...]
> At least now I understand why did you mention si_code/CLD before. You
> meant waitid(). I thought you were talking about the death-notifications
> which can't report CLD_ you need.
> 
> I strongly object. We shouldn't uglify wait_task_zombie() to solve the
> very specific problem.
> 
> And once again. sub_init->parent does wiat(&status) and sees
> WIFSIGNALED() && WTERMSIG(status) == SIGHUP. This can only mean that
> sys_reboot(LINUX_REBOOT_CMD_RESTART) was called. It _can not_ be really
> killed by SIGHUP, it must be CMD_RESTART.
> 
> Why this can't work? Why do you want the additional complications?
> 

I don't see either what could go wrong with you approach. It doesn't
mess with critical wait() or signal paths. It's definitely the way to
go.

Thanks.

-- 
Gregory Kurz                                     gkurz@fr.ibm.com
Software Engineer @ IBM/Meiosys                  http://www.ibm.com
Tel +33 (0)534 638 479                           Fax +33 (0)561 400 420

"Anarchy is about taking complete responsibility for yourself."
        Alan Moore.

