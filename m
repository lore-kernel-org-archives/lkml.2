Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102Ab2ECSny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 14:43:54 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:49889 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247Ab2ECSnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 14:43:53 -0400
MIME-Version: 1.0
In-Reply-To: <1336054375.14207.84.camel@gandalf.stny.rr.com>
References: <1328212844-11889-2-git-send-email-vnagarnaik@google.com>
 <1335388704-26790-1-git-send-email-vnagarnaik@google.com> <1336010118.14207.75.camel@gandalf.stny.rr.com>
 <CAL26m8KgvuUGhK_T91fM2dNtFt4+KSOb5-C8yNiZ888BZW1PEg@mail.gmail.com>
 <1336049840.14207.82.camel@gandalf.stny.rr.com> <1336054375.14207.84.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Thu, 3 May 2012 11:43:22 -0700
Message-ID: <CAL26m8J8=-yvtW+7F+XqTKgZs4NxiT3gSYJFC3RetjBwJvzL2g@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] trace: Make removal of ring buffer pages atomic
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Laurent Chavey <chavey@google.com>,
        Justin Teravest <teravest@google.com>,
        David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 3, 2012 at 7:12 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> It's also giving me errors when I try to enable events or anything else
> when tracing_on is disabled.

Yes, I had to add a check to see if resizing is safe. I re-used
record_disabled in this patch for that purpose.

In the next patch for "atomic addition of pages" I added a new field
resize_disabled to guard against unsafe resizing. So with that patch,
you won't see this behavior. It also fixes the issue with trace-cmd
where the ring buffer doesn't get expanded.



Vaibhav Nagarnaik
