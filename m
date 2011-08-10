Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616Ab1HJIPD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 04:15:03 -0400
Received: from nm2-vm3.bullet.mail.ne1.yahoo.com ([98.138.91.132]:26889 "HELO
	nm2-vm3.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750963Ab1HJIPA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 04:15:00 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 197761.13682.bm@omp1054.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=jgst65FySlFWvj8H+Hy/TJgjIAvAHrw/infyD/IiIS45w2LzIvuE0gA/agYec0HnFs/8CS4vgkQ85QE0zUNL6FsX/3zqktQNIGqEJYGX48F9Dc7iCPwc5OvM9/pnwj+oiNE9uvq3lhRc6xEMTREjKPYlNpwtYe1U0q9TTLcarvw=;
X-YMail-OSG: iOe3k9IVM1mx9.7WMO37tcnuhgK1kpGyV2T.3rqOfeLf_U.
 ZxOVCWjiHYy.nXQHE0bCEnqSlFe5JcdSi0yV3p8EqWt4eZv6f5Yh.XmguLYd
 k7oPGEZPWbb_UTkcIRZCWhEjrNdlhmQxTFF2JNlWgXRnZ_Q7FRrQ4fnogcPo
 oVM3ZDQFEPULbWbocXsSp2F5P0tDWfUu__WwnephbKjBSbT5tDO6lZA4Lile
 bYU_GPI88x4FHgtCo5BZsy1zDMHrDyPj2xjc2RVLLJJPe_udQr6ag0vj7xvi
 jdMCaQW65C8ytwtmI1sIJrRTEheKB2bhAOob56HiyV6Oq5cxjKuG9CrB0FLr
 hDEbZi1qB.m9IwMb2NCf1MiiGX31yz6amosgbjkMVAjnyz0TG0zir92gZw1D
 HINS60LDzGRYm.EgHKBCxE.a4Ym0ofpY3fxa05AERZZAaCBpOlO_6duTLZ_4
 W9PZ2
X-Mailer: YahooMailWebService/0.8.113.313619
References: <1312872786.70934.YahooMailNeo@web111712.mail.gq1.yahoo.com> <1db776d865939be598cdb80054cf5d93.squirrel@xenotime.net> <1312874259.89770.YahooMailNeo@web111704.mail.gq1.yahoo.com> <alpine.DEB.2.00.1108090900170.30199@chino.kir.corp.google.com>
Message-ID: <1312964098.7449.YahooMailNeo@web111712.mail.gq1.yahoo.com>
Date: Wed, 10 Aug 2011 01:14:58 -0700 (PDT)
From: Mahmood Naderan <nt_mahmood@yahoo.com>
Reply-To: Mahmood Naderan <nt_mahmood@yahoo.com>
Subject: Re: running of out memory => kernel crash
To: David Rientjes <rientjes@google.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        "\"linux-kernel@vger.kernel.org\"" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <alpine.DEB.2.00.1108090900170.30199@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>If you're using cpusets or mempolicies, you must ensure that all tasks 
>attached to either of them are not set to OOM_DISABLE.  It seems unlikely 
>that you're using those, so it seems like a system-wide oom condition.
 
I didn't do that manually. What is the default behaviour? Does oom
working or not?

>If you're using cpusets or mempolicies, you must ensure that all tasks 
>attached to either of them are not set to OOM_DISABLE.  It seems unlikely 
>that you're using those, so it seems like a system-wide oom condition.

For a user process:

root@srv:~# cat /proc/18564/oom_score
9198
root@srv:~# cat /proc/18564/oom_adj
0

And for "init" process:

root@srv:~# cat /proc/1/oom_score
17509
root@srv:~# cat /proc/1/oom_adj
0

Based on my understandings, in an out of memory condition (oom),
the init process is more eligible to be killed!!!!!!! Is that right?

Again I didn't get my answer yet:
What is the default behavior of linux in an oom condition? If the default is,
crash (kernel panic), then how can I change that in such a way to kill
the hungry process?

Thanks a lot.

// Naderan *Mahmood;


----- Original Message -----
From: David Rientjes <rientjes@google.com>
To: Mahmood Naderan <nt_mahmood@yahoo.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>; "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>; linux-mm@kvack.org
Sent: Tuesday, August 9, 2011 8:33 PM
Subject: Re: running of out memory => kernel crash

On Tue, 9 Aug 2011, Mahmood Naderan wrote:

> >Do you have any kernel log panic/oops/Bug messages?
>  
> Actually, that happened for one my diskless nodes 10 days ago.
> What I saw on the screen (not the logs), was 
> "running out of memory.... kernel panic....."
> 

The only similar message in the kernel is "Out of memory and no killable 
processes..." and that panics the machine when there are no eligible 
tasks to kill.

If you're using cpusets or mempolicies, you must ensure that all tasks 
attached to either of them are not set to OOM_DISABLE.  It seems unlikely 
that you're using those, so it seems like a system-wide oom condition.  Do 
cat /proc/*/oom_score and make sure at least some threads have a non-zero 
badness score.  Otherwise, you'll need to adjust their 
/proc/pid/oom_score_adj settings to not be -1000.

Randy also added linux-mm@kvack.org to the cc, but you removed it; please 
don't do that.
