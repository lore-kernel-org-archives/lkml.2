Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961Ab2ISUuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 16:50:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:11978 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787Ab2ISUux convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 16:50:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,450,1344236400"; 
   d="scan'208";a="208139313"
From: "Luck, Tony" <tony.luck@intel.com>
To: Andy Lutomirski <luto@amacapital.net>,
        John Stultz <john.stultz@linaro.org>
CC: Richard Cochran <richardcochran@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Turner <pjt@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: RE: [PATCH 0/6][RFC] Rework vsyscall to avoid truncation/rounding
 issue in timekeeping core
Thread-Topic: [PATCH 0/6][RFC] Rework vsyscall to avoid truncation/rounding
 issue in timekeeping core
Thread-Index: AQHNlSCi1Gm2yTybzE29LLvKjxM6jZePqUAAgAAItoCAASiHAIAAB8cAgACtdICAAMPXgIAACP+AgAAODoCAAAj4gP//sI5g
Date: Wed, 19 Sep 2012 20:50:51 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19D43167@ORSMSX108.amr.corp.intel.com>
References: <1347919501-64534-1-git-send-email-john.stultz@linaro.org>
 <CALCETrX5vXTZr_CNfCFDss7XG2PioxMqtpMTuYvoq7-ip2NNbA@mail.gmail.com>
 <5057BE59.3050903@linaro.org> <20120918180200.GA2281@netboy.at.omicron.at>
 <5058BD9E.30909@linaro.org> <20120919045038.GA2248@netboy.at.omicron.at>
 <5059F367.5020104@linaro.org> <20120919170347.GA2232@netboy.at.omicron.at>
 <505A06BD.6000406@linaro.org>
 <CALCETrUAiLXvxYMnNDvdUSFkno+v+P_XGirOYch-k8dUG05jpw@mail.gmail.com>
In-Reply-To: <CALCETrUAiLXvxYMnNDvdUSFkno+v+P_XGirOYch-k8dUG05jpw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Does anything except the vDSO actually use the vDSO data page?  It's
> mapped as part of the vDSO image (i.e. at a non-constant address), and
> it's not immediate obvious how userspace would locate that page.

Just for reference - on ia64 the address of the entry point for the magic
fast system call page is passed to each applications via the "auxv" structure
that exec(2) drops at the top of stack after args/env in the AT_SYSINFO
entry. Apps look for it to find out where to jump for fast system call entry
(if it isn't there, they fall back to regular slow syscall path).

Same method could be used to provide the address of a magic read-only
for users page that kernel fills with stuff for simple system calls.

-Tony
