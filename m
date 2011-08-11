Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab1HKMwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 08:52:47 -0400
Received: from gateway.hbm.com ([213.157.30.2]:54387 "EHLO hbmntx5.hbm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755153Ab1HKMwp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 08:52:45 -0400
Thread-Index: AcxYJZA8cDlIC54lRYyMkyVeXIxg6A==
Thread-Topic: [ANNOUNCE] 3.0.1-rt8 - Regression to 3.0-rt7
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4862
Content-class: urn:content-classes:message
Importance: normal
From: "Tim Sander" <tim.sander@hbm.com>
Organization: Hottinger Baldwin Messtechnik
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [ANNOUNCE] 3.0.1-rt8 - Regression to 3.0-rt7
Date: Thu, 11 Aug 2011 14:52:28 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39; KDE/4.4.5; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        "linux-rt-users" <linux-rt-users@vger.kernel.org>
References: <1312580681.28695.44.camel@twins> <201108111330.28168.tim.sander@hbm.com> <1313064142.7144.1.camel@twins>
In-Reply-To: <1313064142.7144.1.camel@twins>
MIME-Version: 1.0
Content-Type: text/Plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <201108111452.29075.tim.sander@hbm.com>
X-OriginalArrivalTime: 11 Aug 2011 12:52:44.0256 (UTC) FILETIME=[90294600:01CC5825]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter

Am Donnerstag, 11. August 2011, 14:02:22 schrieb Peter Zijlstra:
> On Thu, 2011-08-11 at 13:30 +0200, Tim Sander wrote:
> > The error does not occur  when configured with
> > CONFIG_PREEMPT_RT_FULL=y
> > but with
> > CONFIG_PREEMPT_RTB=y.
> > The same error also happens with
> > CONFIG_PREEMPT_LL=y. (A log is appended after the other log just
> > search for CONFIG_PREEMPT_LL
> > for starting point).
> 
> Does the below (on top of -rt8) cure things for you? Shouldn't make a
> difference for PREEMPT_LL though, so maybe there's something else busted
> as well. But from what I can tell PREEMPT_BASE should be fine with such
> things disabling preemption..
I havent tested but i tested appling rt8 to 3.0 and then git diffstat.
Kind of a manual bisecting. Since you still seem to be currently looking at 
this: 
The current remaining offenders on the list from 3.0-rt7 are:
 git diff --stat rt8-test
 kernel/ksysfs.c       |   12 ------
 kernel/lockdep.c      |    5 ++-
 kernel/sched_cpupri.c |   28 ++-------------
 localversion-rt       |    2 +-
 mm/memory.c           |    2 -
 mm/slab.c             |   92 +++++++++++-------------------------------------
 6 files changed, 29 insertions(+), 112 deletions(-)

Will test the patch later on.

Best regards
Tim

Hottinger Baldwin Messtechnik GmbH, Im Tiefen See 45, 64293 Darmstadt, Germany | www.hbm.com 

Registered as GmbH (German limited liability corporation) in the commercial register at the local court of Darmstadt, HRB 1147  
Company domiciled in Darmstadt | CEO: Andreas Huellhorst | Chairman of the board: James Charles Webster

Als Gesellschaft mit beschraenkter Haftung eingetragen im Handelsregister des Amtsgerichts Darmstadt unter HRB 1147 
Sitz der Gesellschaft: Darmstadt | Geschaeftsfuehrung: Andreas Huellhorst | Aufsichtsratsvorsitzender: James Charles Webster

The information in this email is confidential. It is intended solely for the addressee. If you are not the intended recipient, please let me know and delete this email.

Die in dieser E-Mail enthaltene Information ist vertraulich und lediglich für den Empfaenger bestimmt. Sollten Sie nicht der eigentliche Empfaenger sein, informieren Sie mich bitte kurz und loeschen diese E-Mail.

