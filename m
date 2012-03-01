Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985Ab2CABJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 20:09:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26243 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab2CABJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 20:09:21 -0500
X-Authority-Analysis: v=2.0 cv=Z7xu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=zcWVZ8tiDacA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=i3fdAOzBKgsh7GKaZNQA:9 a=XoFFEdr3Y8g-Iw5RssMA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1330564158.25686.230.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] Trace: initialize variable to clear warning
From: Steven Rostedt <rostedt@goodmis.org>
To: Valdis.Kletnieks@vt.edu
Cc: Zhengwang Ruan <ruan.zhengwang@gmail.com>, fweisbec@gmail.com,
        mingo@redhat.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date: Wed, 29 Feb 2012 20:09:18 -0500
In-Reply-To: <48875.1330555230@turing-police.cc.vt.edu>
References: <1330420174-20537-1-git-send-email-ruan.zhengwang@gmail.com>
	 <1330438591.25686.214.camel@gandalf.stny.rr.com>
	 <48875.1330555230@turing-police.cc.vt.edu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-29 at 17:40 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 28 Feb 2012 09:16:31 EST, Steven Rostedt said:
> 
> > This is a bug in gcc that's fixed in 4.6 and beyond. I don't want to
> > remove this warning because it will hide a real bug if page2 really does
> > become uninitialized. If 4.6 gives a warning here, then I'll fix it.
> 
> > > -	void *page2;
> > > +	void *uninitialized_var(page2);
> 
> How would you feel about this?
> 
> -	void *page2;
> +	void *page2; /* gcc 4.5 bug causes incorrect "uninitialized" warning */
> 
> or something similar?

/* if you get a warning here, upgrade your gcc to 4.6 */


-- Steve



