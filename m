Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934442Ab1CYCjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 22:39:15 -0400
Received: from smtp-out.google.com ([74.125.121.67]:47474 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934385Ab1CYCjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 22:39:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=HLPjoFGQ5sl77uG26yTTUHW81hsHypN2W5Eo5FwoiAgzCbUHhw028I5feSSdwT5ZEA
         gJtqIjfe5kHRLqG+EloA==
MIME-Version: 1.0
From: Justin TerAvest <teravest@google.com>
Date: Thu, 24 Mar 2011 19:38:50 -0700
Message-ID: <BANLkTimiL5VZki4oUaw5hQYgB=E2jYwKrw@mail.gmail.com>
Subject: Why do we use cpu nice priority for ioprio?
To: jaxboe@fusionio.com, Vivek Goyal <vgoyal@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Chad Talbott <ctalbott@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not clear why the cpu nice value should be mapped to the ioprio
for a task when none is picked.

Internally, at cfq_init_prio_data(), we just set:
		ioprio = IOPRIO_NORM;
		ioprio_class = IOPRIO_CLASS_BE;
if ioprio_class is IOPRIO_CLASS_NONE.


The problem is that  today, SCHED_RR and SCHED_FIFO threads
automatically get bumped up to RT class. This all happens behind the
curtains and the io_class of the thread is still shown as NONE with
sys_ioprio_get(). What's the motivation behind this promotion of
ioprio class?

I'd be happy to send a patch to change the behavior, but I'm curious
why the code promotes based on task nice values today.

Thanks!
