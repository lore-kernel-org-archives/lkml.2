Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab0IBSi7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 14:38:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:36393 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab0IBSi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 14:38:58 -0400
X-Authority-Analysis: v=1.1 cv=F68j8apdn+AYvba2s2WjKYIAmW276Pjvg9wPu/ZwFig= c=1 sm=0 a=h6dlIqBDnR0A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=dOElBO8caiskp1CSq_YA:9 a=Hd_ie6yqzbWvdoaDfhYA:7 a=IfZq8ITWzFIYu0TliQIb15GKGgsA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: kernelshark plugins and ftrace array fields
From: Steven Rostedt <rostedt@goodmis.org>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
In-Reply-To: <1283451398.2356.360.camel@gandalf.stny.rr.com>
References: <4C7F9639.7000804@redhat.com>
	 <1283437521.2356.136.camel@gandalf.stny.rr.com> <4C7FB603.60609@redhat.com>
	 <1283451398.2356.360.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 02 Sep 2010 14:38:56 -0400
Message-ID: <1283452736.2356.388.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-02 at 14:16 -0400, Steven Rostedt wrote:
> On Thu, 2010-09-02 at 17:34 +0300, Avi Kivity wrote:

> 
> OK, with no modification of what I have already, I just created this
> handler:
> 
> static int
> kvm_emulate_insn_handler(struct trace_seq *s, struct record *record,
>                          struct event_format *event, void *context)
> {
>         struct format_field *field;
>         unsigned char *data = record->data;
>         int i;
> 
>         field = pevent_find_field(event, "insn");
>         if (!field) {
>                 trace_seq_puts(s, "Can't find inst field");
>                 return 0;
>         }
> 
>         trace_seq_puts(s, "insn: ");
>         for (i = 0; i < field->size; i++) {
>                 trace_seq_printf(s, "%s%02x",
>                                  i ? "," : "",
>                                  data[field->offset + i]);
>         }
> 
>         return 0;
> }
> 
> 
> I think this is what you would want, right?

I think I will add a:

void *pevent_get_field_raw(stuct trace_seq *s,
			struct event_format *event, 
			char *field_name,
			struct record *record,
			int **field_len);

which will return a pointer into record->data and set the field_len to
the actual size.

This will be useful for dynamic arrays too, since it is more complex
than just using a field->offset.

-- Steve


