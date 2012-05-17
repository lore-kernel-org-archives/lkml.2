Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762124Ab2EQQZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 12:25:43 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51707 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758579Ab2EQQZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 12:25:38 -0400
Message-Id: <20120517160738.116113099@openvz.org>
User-Agent: quilt/0.48-1
Date: Thu, 17 May 2012 20:07:38 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        linux-fsdevel@vger.kernel.org
Subject: [rfc 0/4] procfs fdinfo extension
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

when we do restore files such as eventfd/eventpoll we need to pass
appropriate parameters to system calls. Unfortunately there is no
easy way to retrieve this information from the kernel. So to make
possible to obtain this kind of information the proc/pid/fdinfo/fd
handling code has been modified to print "extra" snippets depending
on file type.

The base idea is to make fdinfo being seq-files and plug-in helpers.
For example eventpoll files together with basic pos/flags now print
out target file descriptor number, events and data associated with
an event:

 | pos:	0
 | flags:	02
 | tfd:        5 events:       1d data: ffffffffffffffff

This series is early draft not for inclusion yet but just to
gather people opinions on idea in general and implementation
details. I tried to make the change as small as I can.

I'm working on fsnotify part at moment but since it's not
yet complete decided to not include this patch, it'll appear
later.

(I've been said that idea of extending fdinfo to provide
 additional data snippets was approved on LSF this year.
 Am I right, Pavel?)

Any comments and complains are highly appreciated!

	Cyrill
