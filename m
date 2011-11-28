Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab1K1Teq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 14:34:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41428 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200Ab1K1Teo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 14:34:44 -0500
X-Authority-Analysis: v=2.0 cv=bdLpoZzB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=ajV93-eAzdgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=M0pRtOSvXS8Yh0gP8w4A:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 1/9] trace: Fix uninitialized variable compiler warning
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
In-Reply-To: <20111128162501.GE2201@m.brq.redhat.com>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
	 <1322417074-5834-2-git-send-email-jolsa@redhat.com>
	 <1322497158.17003.2.camel@frodo>  <20111128162501.GE2201@m.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Nov 2011 14:34:42 -0500
Message-ID: <1322508882.17003.10.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-28 at 17:25 +0100, Jiri Olsa wrote:
> 
> On Mon, Nov 28, 2011 at 11:19:18AM -0500, Steven Rostedt wrote:
> > On Sun, 2011-11-27 at 19:04 +0100, Jiri Olsa wrote:
> > > Initialize page2 variable to make compiler happy.
> > 
> > What compiler is this? Because this is a compiler bug. In fact, there's
> > no check for page2 being NULL, so if it is used uninitialized it will
> > crash the kernel. I don't like these "make the compiler shut up" fixes,
> > because honestly, changes like this hide bugs.
> 
> [jolsa@krava1 ~]$ gcc --version
> gcc (GCC) 4.4.5 20110214 (Red Hat 4.4.5-6)

Yep, that's an old compiler. The newer ones don't show this as an error.

-- Steve


