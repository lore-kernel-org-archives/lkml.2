Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab2K3XAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 18:00:18 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:37282 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703Ab2K3XAQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 18:00:16 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "joe@perches.com" <joe@perches.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kay@vrfy.org" <kay@vrfy.org>,
        "jim.cromie@gmail.com" <jim.cromie@gmail.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "jason.wessel@windriver.com" <jason.wessel@windriver.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [PATCH] Avoid dead lock of console related locks in panic case
Thread-Topic: [PATCH] Avoid dead lock of console related locks in panic case
Thread-Index: Ac3PHT6W8aSr96JsTimOsT6bVlOSHQAVvOuAAAnPGzA=
Date: Fri, 30 Nov 2012 22:59:13 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A0339D@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A02C44@USINDEM103.corp.hds.com>
 <20121130143023.2d67d817.akpm@linux-foundation.org>
In-Reply-To: <20121130143023.2d67d817.akpm@linux-foundation.org>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8185,1.0.431,0.0.0000
 definitions=2012-11-30_15:2012-11-30,2012-11-30,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1211300226
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thank you  for giving me the comment.

> - Makes the logic in this area even more twisty and complex, when
>   what we need to do is to simplify it
> 
> - Reinitialises in-use locks
> 
> - Gives the boolean variable "yes" three states, but didn't rename
>   that variable to something appropriate.

I understand "yes" is odd.
I just wanted to know if an idea reinitializing locks is acceptable.
But now I understand I have to take another approach.

> 
> - Passes yes==2 into s390's unsuspecting bust_spinlocks() implementation.
>

Sorry. I missed the code.
 
> 
> Let's step back a bit.  Please identify with great specificity the code sites which are stopping other CPUs before taking locks which
> those other CPUs might have been holding.
> 
> Then let's see what we can do to fix up the callers, instead of trying to tidy up after they have made this mess.

OK.
I will update my patch without adding complexity.
The logic will be as follows, if I understand your comment correctly.

 - take console related locks (logbuf_lock, console_sem)
 - stop other cpus
 - release those locks

Seiji



