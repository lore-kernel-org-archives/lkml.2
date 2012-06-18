Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab2FROVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 10:21:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18839 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab2FROVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 10:21:34 -0400
X-Authority-Analysis: v=2.0 cv=NbpkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=ARy8Wg5PTaYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=cHmhIeQKhJPtM6hQA08A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340029292.25903.101.camel@gandalf.stny.rr.com>
Subject: Re: [RFC PATCH 0/2] libtraceevent/perf: Add support for trace-cmd
 plugins
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org, weisbec@gmail.com, namhyung.kim@lge.com,
        mingo@kernel.org, peterz@infradead.org
Date: Mon, 18 Jun 2012 10:21:32 -0400
In-Reply-To: <87lijlhv9v.fsf@sejong.aot.lge.com>
References: <1339695333-64591-1-git-send-email-dsahern@gmail.com>
	 <87lijlhv9v.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-18 at 17:35 +0900, Namhyung Kim wrote:
> Hi, David
> 
> On Thu, 14 Jun 2012 11:35:31 -0600, David Ahern wrote:
> > Now that perf is using libtraceevent and libtraceevent is based
> > on trace-cmd both can be extended to leverage the plugins written
> > for trace-cmd to improve pretty printing of the events.
> >
> > Given that it is based on code from trace-cmd I am not sure what the
> > right approach is, so wanted to throw this out for comments/suggestions.
> >
> 
> Yeah, it can be useful to reuse existing code for extending the
> functionality. But I'm not so sure including the plugin APIs into
> libtraceevent is the right thing (at least in its current form).
> 
> And for this particular case in patch 2/2, it seems that format of the
> kvm_emulate_insn event is broken already and should be fixed anyway.
> Further improvement in this area can be addressed in perf kvm or other
> users if needed.
> 
> So I'd like to hear from others.
> Arnaldo and Steven, what do you think?

It's been crazy lately, so sorry for the late reply David.

Anyway, I think it is important to get this into either libtraceevent or
another library, but I agree with Namhyung that it should not go in, in
its current form.

Either we add the 'pevent_' names to it, and we need to change things a
bit.

I want to redesign the plugin interface. Well, I do not need to be the
one to redesign it, but it needs to be updated by someone.

Plugins need an interface that they can take parameters, or be modified
at run time. An option passed to perf or trace-cmd could modify how the
plugin works. Or during viewing of the output, parameters can be passed
to tell plugins to do things differently.

Basically, we need to discuss the interface between plugins and the
libtraceevent library. Once we get a good idea of what is needed, then
we can start reusing the code from trace-cmd to make a much better
interface for users.

Thanks!

-- Steve


