Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933479Ab2GDKZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 06:25:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48197 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab2GDKZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 06:25:08 -0400
Subject: Re: [PATCH 04/10] perf, x86: Making hardware events translations
 available in sysfs
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1341352848-11833-5-git-send-email-jolsa@redhat.com>
References: <1341352848-11833-1-git-send-email-jolsa@redhat.com>
	 <1341352848-11833-5-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jul 2012 12:24:54 +0200
Message-ID: <1341397494.2507.88.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-04 at 00:00 +0200, Jiri Olsa wrote:
> +static struct attribute *events_attr[] = {
> +       &event_attr_cycles.attr,
> +       &event_attr_instructions.attr,
> +       &event_attr_cache_references.attr,
> +       &event_attr_cache_misses.attr,
> +       &event_attr_branch_instructions.attr,
> +       &event_attr_branch_misses.attr,
> +       &event_attr_bus_cycles.attr,
> +       &event_attr_stalled_cycles_frontend.attr,
> +       &event_attr_stalled_cycles_backend.attr,
> +       &event_attr_ref_cycles.attr,
> +       NULL,
> +}; 

Hmm, should we do:

  if (!config)
    return -EINVAL;

or somesuch to clearly indicate an event isn't supported?

Its currently a bit of a mixed bag between 0 and -1.. we might want to
clean that up too.

