Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab2EXJv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 05:51:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50846 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab2EXJvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 05:51:55 -0400
Subject: Re: [PATCH 02/16] perf: Add ability to attach registers dump to
 sample
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
In-Reply-To: <1337801535-12865-3-git-send-email-jolsa@redhat.com>
References: <1337801535-12865-1-git-send-email-jolsa@redhat.com>
	 <1337801535-12865-3-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 May 2012 11:51:50 +0200
Message-ID: <1337853110.9783.93.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 21:32 +0200, Jiri Olsa wrote:
> +perf_output_sample_regs(struct perf_output_handle *handle,
> +                       struct pt_regs *regs, u64 mask)
> +{
> +       int i = 0;
> +
> +       do {
> +               u64 val;
> +
> +               if (mask & 1) {
> +                       val = perf_reg_value(regs, i);
> +                       perf_output_put(handle, val);
> +               }
> +
> +               mask >>= 1;
> +               i++;
> +       } while (mask);
> +} 

we have bitmap functions available that can do this far faster on a
number of architectures (like x86) that have bit scanning instructions.

