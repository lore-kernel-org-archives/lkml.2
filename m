Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab1LLUpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 15:45:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63885 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab1LLUpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 15:45:01 -0500
X-Authority-Analysis: v=2.0 cv=HeWWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=KjFivuMxOpgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=SYQUmQGG0F-Fj21cm1sA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1323722699.1377.9.camel@gandalf.stny.rr.com>
Subject: Re: trace_printk is doing weird things with my arguments
From: Steven Rostedt <rostedt@goodmis.org>
To: Josef Bacik <josef@redhat.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 12 Dec 2011 15:44:59 -0500
In-Reply-To: <20111212203214.GB3603@localhost.localdomain>
References: <20111212185947.GA3603@localhost.localdomain>
	 <1323719838.1377.5.camel@gandalf.stny.rr.com>
	 <20111212203214.GB3603@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-12 at 15:32 -0500, Josef Bacik wrote:
> 
> That worked perfectly.  So will I have this problem when I got to turn these
> things into tracepoints or will those work out right?  Thanks,

The TP_fast_assign() is exactly how things are copied into the ring
buffer. If you have all the necessary data copied then, and don't
dereference it in TP_printk(), then you are fine.

IOW,

	TP_fast_assign( entry->id = ptr->id),
	TP_printk ("id: %lx", entry->id)

will work, but

	TP_fast_assign(entry->ptr = ptr),
	TP_printk("id: %lx", entry->ptr->id)

will not.


-- Steve


