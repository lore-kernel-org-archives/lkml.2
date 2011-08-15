Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab1HOOFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 10:05:20 -0400
Received: from gateway.hbm.com ([213.157.30.2]:45711 "EHLO hbmntx5.hbm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819Ab1HOOFO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 10:05:14 -0400
Thread-Index: AcxbVFnMBoPpsJLhSHKxpjGszAJjsA==
Thread-Topic: CONFIG_PEEMPT_RT_FULL vs. CONFIG_PREEMPT_RTB
Content-Class: urn:content-classes:message
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4862
From: "Tim Sander" <tim.sander@hbm.com>
Organization: Hottinger Baldwin Messtechnik
To: "linux-rt-users" <linux-rt-users@vger.kernel.org>
Subject: CONFIG_PEEMPT_RT_FULL vs. CONFIG_PREEMPT_RTB
Date: Mon, 15 Aug 2011 16:04:53 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39; KDE/4.4.5; x86_64; ; )
Cc: "Peter Zijlstra" <peterz@infradead.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Remy Bohmer" <linux@bohmer.net>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-ID: <201108151604.54251.tim.sander@hbm.com>
X-OriginalArrivalTime: 15 Aug 2011 14:05:12.0680 (UTC) FILETIME=[59AD1E80:01CC5B54]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I have more than twice as much cpu load when running the  
CONFIG_PREEMPT_RT_FULL=y kernel compared to CONFIG_PREEMPT_RTB=y. First i 
thought that might be the difference that one config had softirqs enabled and 
the other not. Now i realized that softirqs are already enabled with 
CONFIG_PREEMPT_RTB so i don't see a good reason why the CONFIG_PREEMPT_RT_FULL 
option should have two times more cpu load than CONFIG_PREEMPT_RTB.

The arm1136 cpu (533Mhz pcm043) has 9.6khz interrupt rate so i surely expect 
some load. But i wouldn't expect so much difference between 
CONFIG_PREEMPT_RT_FULL and CONFIG_PREEMPT_RTB. So does anybody has an idea 
what might a reason to so much more cpu load when going to full preemption?

Besides of the cpu load i also found out that with rt11 i can again wake up 
usermode from a IRQF_NO_THREAD waiting on a waitqueue. So the steps outlined 
in this mail http://www.spinics.net/lists/linux-rt-users/msg06834.html do not 
seem to be neccessary anymore? Or does this create an error and than some high 
load?

Best regards
Tim

Hottinger Baldwin Messtechnik GmbH, Im Tiefen See 45, 64293 Darmstadt, Germany | www.hbm.com 

Registered as GmbH (German limited liability corporation) in the commercial register at the local court of Darmstadt, HRB 1147  
Company domiciled in Darmstadt | CEO: Andreas Huellhorst | Chairman of the board: James Charles Webster

Als Gesellschaft mit beschraenkter Haftung eingetragen im Handelsregister des Amtsgerichts Darmstadt unter HRB 1147 
Sitz der Gesellschaft: Darmstadt | Geschaeftsfuehrung: Andreas Huellhorst | Aufsichtsratsvorsitzender: James Charles Webster

The information in this email is confidential. It is intended solely for the addressee. If you are not the intended recipient, please let me know and delete this email.

Die in dieser E-Mail enthaltene Information ist vertraulich und lediglich fur den Empfaenger bestimmt. Sollten Sie nicht der eigentliche Empfaenger sein, informieren Sie mich bitte kurz und loeschen diese E-Mail.

