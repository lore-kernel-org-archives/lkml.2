Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965269Ab1GMKjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 06:39:45 -0400
Received: from ozlabs.org ([203.10.76.45]:45256 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965209Ab1GMKjo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 06:39:44 -0400
From: Michael Neuling <mikey@neuling.org>
To: Sonny Rao <sonnyrao@chromium.org>
cc: acme@redhat.com, anton@samba.org, rostedt@goodmis.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] perf: robustify proc and debugfs file recording
In-reply-to: <1310505348-20163-1-git-send-email-sonnyrao@chromium.org>
References: <1310505348-20163-1-git-send-email-sonnyrao@chromium.org>
Comments: In-reply-to Sonny Rao <sonnyrao@chromium.org>
   message dated "Tue, 12 Jul 2011 14:15:48 -0700."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Wed, 13 Jul 2011 20:39:41 +1000
Message-ID: <29926.1310553581@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sonny,


> While attempting to create a timechart of boot up I found
> perf didn't tolerate modules being loaded/unloaded.  This patch
> fixes this by reading the file once and then writing the size
> read at the correct point in the file.  It also simplifies the
> code somewhat.

I'm getting a bunch of unused variables warnings when I compile this.
Care to clean them up?

    CC util/trace-event-info.o
util/trace-event-info.c: In function ‘read_header_files’:
util/trace-event-info.c:221:27: error: unused variable ‘check_size’ [-Werror=unused-variable]
util/trace-event-info.c:221:21: error: unused variable ‘size’ [-Werror=unused-variable]
util/trace-event-info.c: In function ‘copy_event_system’:
util/trace-event-info.c:255:27: error: unused variable ‘check_size’ [-Werror=unused-variable]
util/trace-event-info.c:255:21: error: unused variable ‘size’ [-Werror=unused-variable]
util/trace-event-info.c: In function ‘read_proc_kallsyms’:
util/trace-event-info.c:377:21: error: unused variable ‘check_size’ [-Werror=unused-variable]
util/trace-event-info.c: In function ‘read_ftrace_printk’:
util/trace-event-info.c:394:21: error: unused variable ‘check_size’ [-Werror=unused-variable]
cc1: all warnings being treated as errors

Mikey
