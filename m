Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab1C2Lgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 07:36:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46394 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679Ab1C2Lgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 07:36:46 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=P8oO77IduGQA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=AoRdh0ZVurO7yYq50GIA:9 a=Egl89VJKw_Lbd8RE0EUA:7 a=HZswD6VWAsI7VSSq0uCDKZ1Q2QoA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [tip:core/urgent] WARN_ON_SMP(): Add comment to explain ({0;})
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        torvalds@linux-foundation.org, srostedt@redhat.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <20110328181855.GA6146@p183.telecom.by>
References: <tip-ccd0d44fad38dc1bb4b26dcc7a30e9f2c3b36870@git.kernel.org>
	 <4D90A08D.707@zytor.com>
	 <AANLkTinh6nraZND1mQJ4ofPbABOtJNEnGYYEkqs92RQM@mail.gmail.com>
	 <4D90A1FE.4000405@zytor.com>
	 <1301324940.14261.232.camel@gandalf.stny.rr.com>
	 <20110328181855.GA6146@p183.telecom.by>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 29 Mar 2011 07:36:43 -0400
Message-ID: <1301398603.14261.262.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-28 at 21:18 +0300, Alexey Dobriyan wrote:
> On Mon, Mar 28, 2011 at 11:09:00AM -0400, Steven Rostedt wrote:
> > Geeze, I never expected such a fuss over a simple change ;)
> 
> And it's still broken ;-)
> 
> 	[spoiler space]

I didn't understand this "space" and never went down to look more.
Should have said "see below".

> WARN_ON_SMP(x) should expand to x, not 0.

No it should expand to zero, please READ THE COMMENT!

OK, it was not part of this patch, but it was in the patch that this
patch was added for.

+/*
+ * WARN_ON_SMP() is for cases that the warning is either
+ * meaningless for !SMP or may even cause failures.
+ * This is usually used for cases that we have
+ * WARN_ON(!spin_is_locked(&lock)) checks, as spin_is_locked()
+ * returns 0 for uniprocessor settings.
+ * It can also be used with values that are only defined
+ * on SMP:
+ *
+ * struct foo {
+ *  [...]
+ * #ifdef CONFIG_SMP
+ *     int bar;
+ * #endif
+ * };
+ *
+ * void func(struct foo *zoot)
+ * {
+ *     WARN_ON_SMP(!zoot->bar);
+ *
+ * For CONFIG_SMP, WARN_ON_SMP() should act the same as WARN_ON(),
+ * and should be a nop and return false for uniprocessor.
+ *
+ * if (WARN_ON_SMP(x)) returns true only when CONFIG_SMP is set
+ * and x is true.
+ */

-- Steve


