Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab2IUQij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 12:38:39 -0400
Received: from ngcobalt02.manitu.net ([217.11.48.102]:40365 "EHLO
	ngcobalt02.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab2IUQih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 12:38:37 -0400
X-Greylist: delayed 3795 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Sep 2012 12:38:37 EDT
X-manitu-Original-Sender-IP: 92.74.58.115
X-manitu-Original-Receiver-Name: ngcobalt02.manitu.net
Message-ID: <505C8937.4040505@grandegger.com>
Date: Fri, 21 Sep 2012 17:35:19 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: TRACE_EVENT without ARGS
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I would like to define trace events for functions without arguments,
e.g. my_yield(). But TRACE_EVENT requires at least one argument to be
defined and I also have not found an example in the kernel sources,
apart from:

  $ cat include/trace/events/xen.h
  ...
  TRACE_EVENT(xen_mmu_flush_tlb,
              TP_PROTO(int x),
              TP_ARGS(x),
              TP_STRUCT__entry(__array(char, x, 0)),
              TP_fast_assign((void)x),
              TP_printk("%s", "")
          );

It uses a dummy argument to work around the problem. Is that the
recommended way to handle such cases?

TIA,

Wolfgang
