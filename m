Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab2JJOMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 10:12:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:43496 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756325Ab2JJOMF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 10:12:05 -0400
Message-ID: <1349878302.1279.18.camel@twins>
Subject: Re: [PATCH 4/8] perf x86: Adding hardware events translations for
 amd cpus
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>
Date: Wed, 10 Oct 2012 16:11:42 +0200
In-Reply-To: <1349873598-12583-5-git-send-email-jolsa@redhat.com>
References: <1349873598-12583-1-git-send-email-jolsa@redhat.com>
	 <1349873598-12583-5-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-10 at 14:53 +0200, Jiri Olsa wrote:
> +static ssize_t amd_event_sysfs_show(char *page, u64 config)
> +{
> +       u64 event = (config & ARCH_PERFMON_EVENTSEL_EVENT) |
> +                   (config & AMD64_EVENTSEL_EVENT) >> 24;
> +
> +       return x86_event_sysfs_show(page, config, event);
> +} 

You'll need to filter out 0xF<<32 bits before passing them on in
@config, Intel has a different meaning for them.


