Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab1ECTIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 15:08:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48111 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317Ab1ECTIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 15:08:40 -0400
Date: Tue, 3 May 2011 21:08:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: werner <w.landgraf@ru.ru>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.39-rc5-git2 boot crashs
Message-ID: <20110503190822.GA20520@elte.hu>
References: <web-516671337@zbackend1.aha.ru>
 <BANLkTikFqF1vzMq3L9zDB=MDnCOFYp+XEQ@mail.gmail.com>
 <web-516990066@zbackend1.aha.ru>
 <BANLkTinCKC23WfG7jnd-ihW9kXz-6SEgFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinCKC23WfG7jnd-ihW9kXz-6SEgFQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > No problem with unzip / zip / moving big files etc, , so that this problem 
> > cames from X86_EXTENDED_PLATTFORM.
> 
> Ok, that is very interesting.

I have no smart ideas straight away - just an observation: i keep testing 
CONFIG_X86_ELAN=y on real hardware, and it's enabled in about 4% of my configs:

 sirius:~/linux/linux2/configs> grep -h MELAN * | sort | uniq -c
     358 # CONFIG_MELAN is not set
      15 CONFIG_MELAN=y

and i booted a few recently:

 sirius:~/linux/linux2/configs> grep -l MELAN=y *
 config-Mon_May__2_13_30_09_CEST_2011.good
 config-Mon_May__2_15_02_43_CEST_2011.good
 config-Mon_May__2_15_59_10_CEST_2011.good
 config-Mon_May__2_16_19_49_CEST_2011.good
 config-Mon_May__2_16_41_15_CEST_2011.good
 config-Mon_May__2_18_10_56_CEST_2011.good
 config-Mon_May__2_19_07_32_CEST_2011.good
 config-Mon_May__2_19_28_56_CEST_2011.good
 config-Mon_May__2_19_52_30_CEST_2011.good
 config-Mon_May__2_21_40_44_CEST_2011.good
 config-Mon_May__2_21_52_04_CEST_2011.good
 config-Mon_May__2_23_43_29_CEST_2011.good
 config-Sun_May__1_21_21_06_CEST_2011.good
 config-Sun_May__1_22_15_02_CEST_2011.good
 config-Tue_May__3_14_45_15_CEST_2011.good

(Note: CONFIG_X86_ELAN got renamed to CONFIG_MELAN recently.)

So whatever the breakage is, it's not just some 'nobody tests CONFIG_MELAN=y' 
easy breakage, but possibly something more configuration (or test) specific.

Thanks,

	Ingo
