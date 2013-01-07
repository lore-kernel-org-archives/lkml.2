Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab3AGWXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 17:23:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14510 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab3AGWXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 17:23:35 -0500
X-Authority-Analysis: v=2.0 cv=Jaw+XD2V c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=LA3gWDSkY1gA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=kQGk9uj_t6UA:10 a=m3NtziW9UwOOy6OZuoMA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1357597414.5190.6.camel@gandalf.local.home>
Subject: Re: [PATCH] jump_label: constify jump_label_text_reserved and
 friends
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        jamie.iles@oracle.com
Date: Mon, 07 Jan 2013 17:23:34 -0500
In-Reply-To: <20130107163955.GB2948@redhat.com>
References: <1357567093-31136-1-git-send-email-sasha.levin@oracle.com>
	 <20130107163955.GB2948@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-07 at 11:40 -0500, Jason Baron wrote:
> On Mon, Jan 07, 2013 at 08:58:09AM -0500, Sasha Levin wrote:
> > jump_label_text_reserved() doesn't modify the memory it works on, it just
> > checks whether there are any jump labels there.
> > 
> > Constify the parameters of it to prevent warnings when working with it.
> > 
> 
> I don't see any 'const' data passed to jump_label_text_reserved()? Where is the
> warning coming from? New users?

If the data is never going to be modified, then it's a good idea to add
const regardless of users. It's good documentation.


> 
> Also, does this mean 'ftrace_text_reserved()' and 'alternatives_text_reserved()'
> need to be updated as well?

Yes, change these too.

Thanks!

-- Steve


