Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab1EWNIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 09:08:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40469 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab1EWNIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 09:08:37 -0400
X-Authority-Analysis: v=1.1 cv=NmbQexcdgr4rtO3OwYGrP5Q3rTMpacrTPhuaXkv4uP8= c=1 sm=0 a=w9pjrkYtaRMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=wdDCT_fDmp0RbLGSvRMA:9 a=RlQRSwIEUtCXj1f74OEA:7 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] kernel: Fix ftrace.c compiler warning when calling
 ftrace_nop_replace()
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Eduardo Silva <edsiper@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4DD9BA2F.9000303@zytor.com>
References: <1306113548.29789.2.camel@monotop>  <4DD9BA2F.9000303@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 23 May 2011 09:08:34 -0400
Message-ID: <1306156114.1465.37.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-05-22 at 18:36 -0700, H. Peter Anvin wrote:
> On 05/22/2011 06:19 PM, Eduardo Silva wrote:
> > the function ftrace_nop_replace() returns a 'static const unsigned char *'
> > value, so when the caller perform a direct assignment to a
> > 'static unsigned char *', the compiler raise the following warning message:
> > 
> >  ftrace.c:308:6: warning: assignment discards qualifiers from pointer target type
> >  ftrace.c:318:6: warning: assignment discards qualifiers from pointer target type
> > 
> > Adding the proper casts the message goes away.
> > 
> > Signed-off-by: Eduardo Silva <edsiper@gmail.com>
> 
> This quiets a warning of something that potentially looks like a real
> bug.  Perhaps "new" should be const?

Although there is no real bug here, I hate these "hide the warning"
patches.

The real solution is to change all the users into const *. This should
be doable as the new and old pointers are not modified.

And remember:

	char *changes;
	const char *no_changes;

	no_changes = changes;  /* is OK! (no compiler warnings) */

	changes = no_changes; /* is not OK. (compiler will warn). */

-- Steve


