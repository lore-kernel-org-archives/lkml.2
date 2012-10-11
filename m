Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758968Ab2JKREy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 13:04:54 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:35326 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758941Ab2JKREw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 13:04:52 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>
CC: "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "x86@kernel.org" <x86@kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [PATCH v4] trace,x86: add x86 irq vector tracepoints
Thread-Topic: [PATCH v4] trace,x86: add x86 irq vector tracepoints
Thread-Index: Ac2YWrA+n8Wn2uRQSgKoDvfneAuZiQClgnuAAIOLIPAAEMXIAADi3wmQAJXsDgAAFQlugAAFpDiAAExo5wAAWdCkMA==
Date: Thu, 11 Oct 2012 17:04:03 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D413872974@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41385F33C@USINDEM103.corp.hds.com>
   <50612729.2080307@zytor.com>
   <A5ED84D3BB3A384992CBB9C77DEDA4D41386426D@USINDEM103.corp.hds.com>
   <50650A7E.90807@zytor.com>
   <A5ED84D3BB3A384992CBB9C77DEDA4D413869FD7@USINDEM103.corp.hds.com>
  <1349446428.6755.56.camel@gandalf.local.home> <506F7849.2080805@zytor.com>
 <1349492261.6755.87.camel@gandalf.local.home> <50719EEC.7090302@zytor.com>
In-Reply-To: <50719EEC.7090302@zytor.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-11_05:2012-10-11,2012-10-11,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1210110163
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > I didn't say anything magic, but a table of pointers that are very
> > critical for the system running. Should we implement it with a single
> > switch, like we discussed in San Diego to do with the system call table?
> >
> > That is, have a "normal" table, and a "trace" table. The trace table
> > points to functions that have tracepoints. The first enabler of
> > tracing switches the table to use the tracepoints, and the last
> > disabler switches it back?
> >
> 
> That is certainly a reasonable implementation option.  It is slightly less usable than it is for system calls, though, because the vectors in
> the IDTs are somewhat scrambled and so you can't just do an indirect jump to the original vector content.  This does get messy
> because you also want to preserve registers...
> 

Peter, Steven, 

Thank you for explaining the reason why you think a time penalty should be zero
and discussing its implementation.

I will update my patch so that a time penalty makes zero and submit it shortly.

Seiji
