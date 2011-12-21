Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab1LUQzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 11:55:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51570 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab1LUQzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 11:55:52 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=gi03_xuaV2EA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=xk4mzlzLacdTFFDBCXgA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1324486549.5916.105.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 3/8] ftrace: Add enable/disable ftrace_ops control
 interface
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Date: Wed, 21 Dec 2011 11:55:49 -0500
In-Reply-To: <20111221164304.GB1659@m.brq.redhat.com>
References: <1323105776-26961-1-git-send-email-jolsa@redhat.com>
	 <1324468136-3997-1-git-send-email-jolsa@redhat.com>
	 <1324468136-3997-4-git-send-email-jolsa@redhat.com>
	 <1324483293.5916.89.camel@gandalf.stny.rr.com>
	 <20111221164304.GB1659@m.brq.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-21 at 17:43 +0100, Jiri Olsa wrote:

> > more readable. With what you have, I looked at that condition three
> > times to figure out what was different between what was '&'d with the
> > flags and what was being equal too. Usually the ((flags & X) == Y) is
> > done to check if a subset of bits are set within a mask of bits.
> 
> Well, thats what I need to do here. Bail out if both bits are set,
> since we dont support both global and control flags set at the same
> time.. I'll add some comment to it.
> 

Ah that's right, that's not a single bit. OK, you need to rename
FL_GLOBAL_CONTROL to FL_GLOBAL_CONTROL_BITS or _MASK. _MASK may be
better, as I think it's used more often for this case.

Otherwise it looks like a single bit. Then you wont even need the
comment. But I wont stop you from adding one.

-- Steve


