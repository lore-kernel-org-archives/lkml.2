Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760052Ab1JGNiz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 09:38:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38472 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758880Ab1JGNix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 09:38:53 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=kOlisWoVGWkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=lrYSMIGZtDv_OQk4bHUA:9 a=zALdFC3vm61zU4OHcRsA:7 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [patch] trace: cleanup: make some types unsigned
From: Steven Rostedt <rostedt@goodmis.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Fri, 07 Oct 2011 09:38:51 -0400
In-Reply-To: <20111007132744.GC31424@elgon.mountain>
References: <20111007132744.GC31424@elgon.mountain>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317994732.4729.39.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-07 at 16:27 +0300, Dan Carpenter wrote:
> The problem here is that I'm trying to silence a static checker
> warning.  In replace_preds() we cap n_preds at MAX_FILTER_PRED but
> we don't check for negative values.  It can't actually be negative
> values, but the static checkers get confused.

I really hate to uglify code for the sake of static checkers.

This code may change in the near future, and the possibility that
n_preds may become a possibility. Perhaps we should add a:

WARN_ON(n_preds < 0);

If in the future the count_preds() changes and incorrectly produces a
negative number, or perhaps even overflows int, we wont catch it with
unsigned.

-- Steve


