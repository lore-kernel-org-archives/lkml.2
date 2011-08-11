Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab1HKHHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 03:07:08 -0400
Received: from nm2-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.248]:26835 "HELO
	nm2-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751468Ab1HKHHE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 03:07:04 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 420396.79470.bm@omp1006.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=GbARk9YpNkW0zQnJaq3802ObHe3dGwWHmjV1assj1NZdLz5NIH7DItAl+uCRpK8WLX8oxxfK+J+AD5+6NTWXhiOrtk75GAn9t0iQR+ZoLJTsigqIT3CswppiKOH+HUBxoPMY+udC+dbgL37YJWbXe6yVE4ATILcuXu7fITH94Jg=;
X-YMail-OSG: g4kFYyQVM1mGMOm2rT..xQ4oCs6drq.XgnnPXsOFBognyCM
 Al39VLrWNVepkEn_lbd8RyH7idBLvh5k4T_j4mjXog3zTJeEctWPBbcyQDvi
 nfuSdQws3fRLmvv2orh6WburtFz.9zP0b1ZrDOhIHsmyIgwqfTDx2WRUNFf0
 Jt5m6MqxINFpdpYq5_kaWUXykbCplyfXWWjW40GhQWJUO0TzIfB.aR1ihgvl
 kZCrnAwnSuxqOyK50fUmaWb2PdOV8rVQsmDaWzpKFrsteuMWkDldZG2rdLkR
 Bv5.X8qUM7FJQ4IALqMqPrqqi3ZaWzi93_KemZHUoCv8cO.jWOEULh4u5K_h
 svB6sMX.H0.A0axh5_bgHfrVdGm.hlGLTM6PMe4yo4mJ7LzuQ.ZA3Y2teYab
 DH5D0R7HPOuuWFqk.aAC3MQDtOxhfruaralg.DzsBs3AbhMkRvPsDMfD8Yr8
 xQGR5
X-Mailer: YahooMailWebService/0.8.113.313619
References: <1312872786.70934.YahooMailNeo@web111712.mail.gq1.yahoo.com> <1db776d865939be598cdb80054cf5d93.squirrel@xenotime.net> <1312874259.89770.YahooMailNeo@web111704.mail.gq1.yahoo.com> <alpine.DEB.2.00.1108090900170.30199@chino.kir.corp.google.com> <1312964098.7449.YahooMailNeo@web111712.mail.gq1.yahoo.com> <alpine.DEB.2.00.1108102106410.14230@chino.kir.corp.google.com>
Message-ID: <1313046422.18195.YahooMailNeo@web111711.mail.gq1.yahoo.com>
Date: Thu, 11 Aug 2011 00:07:02 -0700 (PDT)
From: Mahmood Naderan <nt_mahmood@yahoo.com>
Reply-To: Mahmood Naderan <nt_mahmood@yahoo.com>
Subject: Re: running of out memory => kernel crash
To: David Rientjes <rientjes@google.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        "\"\"linux-kernel@vger.kernel.org\"\"" <linux-kernel@vger.kernel.org>,
        "\"linux-mm@kvack.org\"" <linux-mm@kvack.org>
In-Reply-To: <alpine.DEB.2.00.1108102106410.14230@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>The default behavior is to kill all eligible and unkillable threads until 
>there are none left to sacrifice (i.e. all kthreads and OOM_DISABLE).
 
In a simple test with virtualbox, I reduced the amount of ram to 300MB. 
Then I ran "swapoff -a" and opened some applications. I noticed that the free
spaces is kept around 2-3MB and "kswapd" is running. Also I saw that disk
activity was very high. 
That mean although "swap" partition is turned off, "kswapd" was trying to do
something. I wonder how that behavior can be explained?

>Ok, so you don't have a /proc/pid/oom_score_adj, so you're using a kernel 
>that predates 2.6.36.
Yes, the srv machine that I posted those results, has kernel before 2.6.36



// Naderan *Mahmood;


----- Original Message -----
From: David Rientjes <rientjes@google.com>
To: Mahmood Naderan <nt_mahmood@yahoo.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>; ""linux-kernel@vger.kernel.org"" <linux-kernel@vger.kernel.org>; "linux-mm@kvack.org" <linux-mm@kvack.org>
Sent: Thursday, August 11, 2011 8:39 AM
Subject: Re: running of out memory => kernel crash

On Wed, 10 Aug 2011, Mahmood Naderan wrote:

> >If you're using cpusets or mempolicies, you must ensure that all tasks 
> >attached to either of them are not set to OOM_DISABLE.  It seems unlikely 
> >that you're using those, so it seems like a system-wide oom condition.
>  
> I didn't do that manually. What is the default behaviour? Does oom
> working or not?
> 

The default behavior is to kill all eligible and unkillable threads until 
there are none left to sacrifice (i.e. all kthreads and OOM_DISABLE).

> For a user process:
> 
> root@srv:~# cat /proc/18564/oom_score
> 9198
> root@srv:~# cat /proc/18564/oom_adj
> 0
> 

Ok, so you don't have a /proc/pid/oom_score_adj, so you're using a kernel 
that predates 2.6.36.

> And for "init" process:
> 
> root@srv:~# cat /proc/1/oom_score
> 17509
> root@srv:~# cat /proc/1/oom_adj
> 0
> 
> Based on my understandings, in an out of memory condition (oom),
> the init process is more eligible to be killed!!!!!!! Is that right?
> 

init is exempt from oom killing, it's oom_score is meaningless.

> Again I didn't get my answer yet:
> What is the default behavior of linux in an oom condition? If the default is,
> crash (kernel panic), then how can I change that in such a way to kill
> the hungry process?
> 

You either have /proc/sys/vm/panic_on_oom set or it's killing a thread 
that is taking down the entire machine.  If it's the latter, then please 
capture the kernel log and post it as Randy suggested.
