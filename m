Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab2DWMlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 08:41:12 -0400
Received: from smtp04.bis7.eu.blackberry.com ([178.239.85.9]:12752 "EHLO
	smtp04.bis7.eu.blackberry.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752257Ab2DWMlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 08:41:11 -0400
X-Greylist: delayed 574 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Apr 2012 08:41:10 EDT
X-rim-org-msg-ref-id: 1584530163
Message-ID: <1584530163-1335184291-cardhu_decombobulator_blackberry.rim.net-1176781515-@b4.c16.bise7.blackberry>
Reply-To: cucinotta@sssup.it
X-Priority: Normal
Sensitivity: Normal
Importance: Normal
Subject: Re: [PATCH 05/16] sched: SCHED_DEADLINE policy implementation.
To: "Peter Zijlstra" <peterz@infradead.org>,
        "Juri Lelli" <juri.lelli@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org,
        cfriesen@nortel.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, "Fabio Checconi" <fchecconi@gmail.com>,
        "Tommaso Cucinotta" <tommaso.cucinotta@sssup.it>,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        "Dario Faggioli" <raistlin@linux.it>, insop.song@ericsson.com,
        liming.wang@windriver.com
From: cucinotta@sssup.it
Date: Mon, 23 Apr 2012 12:31:30 +0000
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3NCfcLQ020971

How would it be to add an unlikely() to the check of the while () condition ?
Guess the point of subtractions vs division and multiplications was that the former was supposed to be faster than the latter, especially in view of the fact that the while () loop body is likely to be executed just once, if at all.
However, removing a while () loop from the scheduler path doesn't seem a bad idea either.

  T.
------Original Message------
From: Peter Zijlstra
To: Juri Lelli
Cc: tglx@linutronix.de
Cc: mingo@redhat.com
Cc: rostedt@goodmis.org
Cc: cfriesen@nortel.com
Cc: oleg@redhat.com
Cc: fweisbec@gmail.com
Cc: darren@dvhart.com
Cc: johan.eker@ericsson.com
Cc: p.faure@akatech.ch
Cc: linux-kernel@vger.kernel.org
Cc: claudio@evidence.eu.com
Cc: michael@amarulasolutions.com
Cc: Fabio Checconi
Cc: Tommaso Cucinotta
Cc: nicola.manica@disi.unitn.it
Cc: luca.abeni@unitn.it
Cc: dhaval.giani@gmail.com
Cc: hgu1972@gmail.com
Cc: paulmck@linux.vnet.ibm.com
Cc: Dario Faggioli
Cc: insop.song@ericsson.com
Cc: liming.wang@windriver.com
Subject: Re: [PATCH 05/16] sched: SCHED_DEADLINE policy implementation.
Sent: 23 Apr 2012 13:22

On Mon, 2012-04-23 at 14:13 +0200, Juri Lelli wrote:
> On 04/23/2012 01:32 PM, Peter Zijlstra wrote:
> > On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
> >> +       /*
> >> +        * We Keep moving the deadline away until we get some
> >> +        * available runtime for the entity. This ensures correct
> >> +        * handling of situations where the runtime overrun is
> >> +        * arbitrary large.
> >> +        */
> >> +       while (dl_se->runtime<= 0) {
> >> +               dl_se->deadline += dl_se->dl_deadline;
> >> +               dl_se->runtime += dl_se->dl_runtime;
> >> +       }
> >
> > Does gcc 'optimize' that into a division? If so, it might need special
> > glue to make it not do that.
> 
> I got two adds and a jle, no div here..

Gcc is known to change such loops to something like:

 if (runtime <= 0) {
   tmp = 1 - runtime / dl_runtime;
   deadline += tmp * dl_deadline;
   runtime += tmp * dl_runtime;
 }



Sent from my BlackBerry® smartphone from eMobileÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
