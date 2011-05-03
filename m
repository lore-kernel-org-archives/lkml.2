Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab1ECWrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 18:47:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52472 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab1ECWrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 18:47:35 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=QGQEIaqMFKAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=FKnz9BAEepEDnbipugQA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC PATCH] tracing: Don't call wakeup() when committing the
 event
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110503220948.GE2678@nowhere>
References: <1304456616-30281-1-git-send-email-vnagarnaik@google.com>
	 <20110503214142.GC2678@nowhere>
	 <BANLkTinA8M8Ok2jghtCoeBiTfw6n3NSziA@mail.gmail.com>
	 <20110503220948.GE2678@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 03 May 2011 18:47:32 -0400
Message-ID: <1304462852.25414.2417.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-04 at 00:09 +0200, Frederic Weisbecker wrote:

> I wonder if we should have a lite version of wake_up() that checks
> if the list of waiters is empty before locking the queue.
> After all we don't care much about tight races for tracing.

Since tracing is a special case here, we probably could get away to just
do it ourselves. That is, have our own flag that determines if we should
wakeup or not.

-- Steve


