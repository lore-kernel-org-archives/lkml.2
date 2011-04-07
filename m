Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab1DGV5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 17:57:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36158 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab1DGV5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 17:57:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=jOArVU6aJ5tifjQoqWX4KjrEiB0ZnCxlyuH2o1M6o72GqakcFTfnqljJnUDUYrdpqu
         m/+/XEWAQAEygu1HDulnZKOjLVQgxXdZ+HRlILsESKweZ5lqoecgwidCE1d/akTOE/RZ
         iwSIlY40KNla/eOJx7QSIDaxxYcWOsfIT0KXA=
Date: Thu, 7 Apr 2011 23:57:04 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, mrubin@google.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH perf 0/2] perf: trace-event-parse: support more
 operators and print formats
Message-ID: <20110407215700.GF1798@nowhere>
References: <1300746846-28245-1-git-send-email-dhsharp@google.com>
 <BANLkTimhAis_f5OXgzfMD7uKeX5qHYUsgA@mail.gmail.com>
 <20110407142605.GC1798@nowhere>
 <BANLkTin43CY46KTb2WOTK0hgm2bN1VbP4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTin43CY46KTb2WOTK0hgm2bN1VbP4w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, 2011 at 01:25:04PM -0700, David Sharp wrote:
> On Thu, Apr 7, 2011 at 7:26 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > On Wed, Apr 06, 2011 at 07:01:40PM -0700, David Sharp wrote:
> >> Hi, any feedback on these patches? I think it's important that perf
> >> and trace-cmd don't drift in the syntax they accept.
> >>
> >> d#
> >
> > Sorry, I forgot these.
> >
> >> On Mon, Mar 21, 2011 at 3:34 PM, David Sharp <dhsharp@google.com> wrote:
> >> > These patches correspond to similar patches recently applied to trace-cmd
> >> >
> >> > [ Re-sending with more Cc's ]
> >> >
> >> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> >> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> >> > Cc: Steven Rostedt <rostedt@goodmis.org>
> >> > Cc: Ingo Molnar <mingo@elte.hu>
> >> > Cc: Stephane Eranian <eranian@google.com>
> >> >
> >> >
> >> > David Sharp (2):
> >> >  perf: trace-event-parse: support additional operators: '!', '~',  and
> >> >    '!='
> >> >  perf: trace-event-parse: support printing short fields
> >
> > So we now have trace events that use these new operations? Which ones?
> > A quick grep on "TP_printk" and "!" doesn't give me any result, probably
> > because TP_printk is often multiline.
> >
> 
> We (google) have some events that use '~' and '!', and I threw in '!='
> mostly because it needed to be differentiated from '!' during
> tokenizing.
> 
> We set the MSB of the syscall number in raw_syscalls events to
> indicate a compat syscall, and use '~' and '!' (and '&' and '>>') to
> extract the bit. eg, for sys_exit:
> print fmt: "NR %ld = %ld isCompat: %d", REC->id & (~0UL>>1), REC->ret,
> !!(REC->id & ~(~0UL>>1))
> Patches for this will be forthcoming, but, you know: time.

Please consider the compat syscall tracing patches from Jason Baron
and Ian Munsie:

http://lkml.org/lkml/2010/6/23/69

They were pretty clean IIRC. Someone just need to rebase them, clean
up some last things and repost.

> 
> If our internally-added events are not sufficient reason, I think it
> still makes sense to support as much of the C expression syntax as
> reasonable. Leaving holes in the syntax mostly just causes frustration
> when these operators would be useful. And since they do work with the
> in-kernel output (which has the whole compiler to leverage), use of
> unsupported operators can go unnoticed for quite a while.

Hmm, ok.
