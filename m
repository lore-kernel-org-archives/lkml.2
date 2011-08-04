Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab1HDRFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 13:05:16 -0400
Received: from gateway.hbm.com ([213.157.30.2]:10901 "EHLO hbmntx5.hbm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766Ab1HDRFH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 13:05:07 -0400
Thread-Index: AcxSyKjjV1Wo8y89TIS3stsQwEm8SA==
Thread-Topic: [ANNOUNCE] 3.0-rt6 : BUG at kernel/trmutex.c:724!
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4862
Content-class: urn:content-classes:message
Importance: normal
From: "Tim Sander" <tim.sander@hbm.com>
Organization: Hottinger Baldwin Messtechnik
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [ANNOUNCE] 3.0-rt6 : BUG at kernel/trmutex.c:724!
Date: Thu, 4 Aug 2011 19:04:53 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39; KDE/4.4.5; x86_64; ; )
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "linux-rt-users" <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
References: <alpine.LFD.2.02.1107282213000.31246@ionos> <201108041834.20575.tim.sander@hbm.com> <1312475829.16729.45.camel@twins>
In-Reply-To: <1312475829.16729.45.camel@twins>
MIME-Version: 1.0
Content-Type: text/Plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <201108041904.53780.tim.sander@hbm.com>
X-OriginalArrivalTime: 04 Aug 2011 17:05:06.0576 (UTC) FILETIME=[A8CBB100:01CC52C8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 4. August 2011, 18:37:09 schrieb Peter Zijlstra:
> looks like it tries to use waitqueues from hardirq context, that's a
> no-no for -rt. That interrupt should be a threaded interrupt.
Ah, right: i enabled hardirq in tring to fight latency without preempt-rt and 
then forgot.

Its working now with 3.0-rt7.

Thanks 
Tim

Hottinger Baldwin Messtechnik GmbH, Im Tiefen See 45, 64293 Darmstadt, Germany | www.hbm.com 

Registered as GmbH (German limited liability corporation) in the commercial register at the local court of Darmstadt, HRB 1147  
Company domiciled in Darmstadt | CEO: Andreas Huellhorst | Chairman of the board: James Charles Webster

Als Gesellschaft mit beschraenkter Haftung eingetragen im Handelsregister des Amtsgerichts Darmstadt unter HRB 1147 
Sitz der Gesellschaft: Darmstadt | Geschaeftsfuehrung: Andreas Huellhorst | Aufsichtsratsvorsitzender: James Charles Webster

The information in this email is confidential. It is intended solely for the addressee. If you are not the intended recipient, please let me know and delete this email.

Die in dieser E-Mail enthaltene Information ist vertraulich und lediglich für den Empfaenger bestimmt. Sollten Sie nicht der eigentliche Empfaenger sein, informieren Sie mich bitte kurz und loeschen diese E-Mail.

