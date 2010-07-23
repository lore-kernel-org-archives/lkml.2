Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760595Ab0GWPKp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 11:10:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46865 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760224Ab0GWPKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 11:10:40 -0400
X-Authority-Analysis: v=1.1 cv=NvN00vXXLC/2Fo3NdLZJXFUM7u9qr/FOWvgMjmHRJhk= c=1 sm=0 a=G2SHEswpWIAA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=enOvQawGAAAA:8 a=LoFBYVZpXIPHBrC0mfcA:9 a=h5ofyjrwckcfzgXCxqHpGsi3tvkA:4 a=PUjeQqilurYA:10 a=bkT6KWdcy0IA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] trace-cmd: Don't SIGSEGV when event field format
 cannot be parsed (v2).
From: Steven Rostedt <rostedt@goodmis.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1279832705-14219-1-git-send-email-ddaney@caviumnetworks.com>
References: <1279829325.3319.27.camel@gandalf.stny.rr.com>
	 <1279832705-14219-1-git-send-email-ddaney@caviumnetworks.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 23 Jul 2010 11:10:38 -0400
Message-ID: <1279897838.3319.51.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-22 at 14:05 -0700, David Daney wrote:
> >From the MIPS kernel we get things like:
> 
> print fmt: "page=%p pfn=%lu order=%d migratetype=%d", REC->page, ({ struct page *__pg = (REC->page); int __sec = page_to_section(__pg); (unsigned long)(__pg - __section_mem_map_addr(__nr_to_section(__sec))); }), REC->order, REC->migratetype
> 
> This cannot be parsed, leading to a NULL struct event_format* being
> passed to pevent_get_common_field_val, which produces a SIGSEGV.  It
> would be good to get a parsable format from the kernel, but to
> remediate the problem for legacy kernels, we can just return an error
> indicator in this case.  This allows some output from trace-cmd
> report, although perhaps with some missing data.  But this is better
> than crashing.
> 
> (v2): Do the check in all pevent_get_*
> 
> Signed-off-by: David Daney <ddaney@caviumnetworks.com>

Applied, thanks David!

-- Steve


