Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab0LDANg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 19:13:36 -0500
Received: from smtp-out.google.com ([74.125.121.35]:16826 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab0LDANf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 19:13:35 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:x-system-of-record;
	b=b8lKBYPpkQi1/G2X7trQ2RGos+cD5aPDKcYec1ArFVFHXZNxNMjwsHgELy/dPATwf
	DROZR4tCt/X61cHqGYO4w==
From: David Sharp <dhsharp@google.com>
To: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Cc: mrubin@google.com
Subject: [Patch 00/15] Reduce tracing payload size.
Date: Fri,  3 Dec 2010 16:13:14 -0800
Message-Id: <1291421609-14665-1-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a series of patches for tracing aiming to reduce the size of events in
the trace buffer. For some tracing tasks, the machine is so heavily loaded such
that events are produced much faster than they can be written to disk or
network. In this situation, the sizes of the trace events and the ring buffer
are the primary factors limiting the length of time that can be traced.  Even
with ktrace (which has significantly smaller event sizes), a fairly minimal set
of enabled events, and a 16MB buffer per cpu, we are finding we can only get
about 20 seconds of tracing. This is not enough when the problem being
diagnosed only occurs at greater timescales and cannot be easily detected at
runtime.

These patches are just a start to shrinking the size of trace events. I am
planning to also make small versions of trace events that are used when
CONFIG_SMALL_TRACES is enabled. I'm also open to discussion of other ways to
shrink event sizes.


The patches can be divided into three major groups.

The first group is self explanitory patches, not actually related to shrinking
events:

	tracing: Add a 'buffer_overwrite' debugfs file
	ring_buffer.c: Remove unused #include <linux/trace_irq.h>
	ring_buffer: Align buffer_page struct allocations only to fit the flags.

The second group is patches to adjust packing and alignment of tracing event
structures:

	ftrace: pack event structures.
	ftrace: fix event alignment: ftrace:context_switch and ftrace:wakeup
	ftrace: fix event alignment: module:module_request
	ftrace: fix event alignment: kvm:kvm_hv_hypercall
	ftrace: fix event alignment: mce:mce_record
	ftrace: fix event alignment: skb:kfree_skb
	ftrace: fix event alignment: jbd2:*
	ftrace: fix event alignment: ext4:*

The third group are patches to remove 8 bytes from struct trace_entry:

	trace_output.c: adjust conditional expression formatting.
	small_traces: Add config option to shrink trace events.
	small_traces: Remove trace output of large fields.
	small_traces: Remove 8 bytes from trace_entry.


Thanks,
d#
