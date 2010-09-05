Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab0IEHIZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 03:08:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab0IEHIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 03:08:24 -0400
Message-ID: <4C8341E1.7050605@redhat.com>
Date: Sun, 05 Sep 2010 10:08:17 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: kernelshark plugins and ftrace array fields
References: <4C7F9639.7000804@redhat.com>	 <1283437521.2356.136.camel@gandalf.stny.rr.com> <4C7FB603.60609@redhat.com>	 <1283451398.2356.360.camel@gandalf.stny.rr.com>	 <1283452736.2356.388.camel@gandalf.stny.rr.com> <1283455443.2356.433.camel@gandalf.stny.rr.com>
In-Reply-To: <1283455443.2356.433.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/02/2010 10:24 PM, Steven Rostedt wrote:
>
> I just pushed out the changes and my new example looks like this:
>
> static int
> kvm_emulate_insn_handler(struct trace_seq *s, struct record *record,
>                           struct event_format *event, void *context)
> {
>          unsigned char *data;
>          int len;
>          int i;
>
>          data = pevent_get_field_raw(s, event, "insn", record,
>                                      &len, 1);
>          if (!data)
>                  return -1;
>
>          trace_seq_puts(s, "insn: ");
>          for (i = 0; i<  len; i++) {
>                  trace_seq_printf(s, "%s%02x",
>                                   i ? "," : "",
>                                   data[i]);
>          }
>
>          return 0;
> }
>

That looks perfect.  But on which branch can I find it?

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

