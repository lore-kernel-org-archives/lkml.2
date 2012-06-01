Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933561Ab2FASC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 14:02:58 -0400
Received: from nm19.bullet.mail.ac4.yahoo.com ([98.139.52.216]:22588 "HELO
	nm19.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932394Ab2FASC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 14:02:56 -0400
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Jun 2012 14:02:56 EDT
X-Yahoo-Newman-Id: 406543.85795.bm@omp1016.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: FG5tS8MVM1mWDf5tOCNks_NdGJ6r2Nq4kAuw8CnQmXmFbBT
 jG3U.6ZpynrLMxTJuVQtcbsHMBLWsV0HueAlduvw5L2vcFJ6nl3YpZPcK4Lj
 _Td5frq5ohwSdj.z_N2iHkWqtrD54LVZaQ7RwR0uC0b7wcOEp3rCFnYVqnuw
 7aArKhbhpP0I5D7uN1gOnffDT.mRwqFB.Wws82Y5z_hJ_AaNpxhQpOhCMqPD
 wxTFSznHq40RB5q3IL3aZKOT6hFQG8nzaxT1Y0nKIaztqn5DV1P46vtmlQqw
 gK0H25tT8fY_kAWAZ8wOkhClCoPTiGqFgmG2fEgcdXm2Wrg9vI0zkTV5FPRu
 n8y3E9_C9O_Ti.UJ84AK4Wpu0A_gc0BPNt3HD7SY31Jgy0.heg8o91BEIp2q
 BUJ0hWg--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <4FC90267.7050102@att.net>
Date: Fri, 01 Jun 2012 12:56:55 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: daniel.santos@pobox.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Kent Overstreet <koverstreet@google.com>, tj@kernel.org,
        Peter Zijlstra <peterz@infradead.org>, axboe@kernel.dk,
        paul.gortmaker@windriver.com, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v2 1/3] [RFC] Generic Red-Black Trees (performance notes)
References: <4FC7FD23.6080800@att.net> <4FC81611.9090801@att.net>
In-Reply-To: <4FC81611.9090801@att.net>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've done a bit more analysis of the generated code of
kernel/sched/fair.c (patched) under three versions of gcc.

gcc-4.5.3
* 48 bytes larger
* one instance of a (const_flag & ENUM_VALUE) fails to compile out
* compare function not inlined

gcc-4.6.2
* same size
* ANDed constants compiled out
* compare function inlined

gcc-4.7.0:
* 64 bytes smaller - __enqueue_entity() reduced by 16 bytes (2 byte
smaller and saved some padding, so essentially the same), I'm not sure
where the other 48 bytes came from, I'm guessing just alignment changes
from using different registers (smaller opcodes).

So in summary, the results on 4.5 are worse, but not "horrible".  The
problems are fixed in 4.6 and later.

There's still lots of other scenarios to test.

Daniel

