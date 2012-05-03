Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab2ECGkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 02:40:41 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43068 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab2ECGki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 02:40:38 -0400
MIME-Version: 1.0
In-Reply-To: <1336010118.14207.75.camel@gandalf.stny.rr.com>
References: <1328212844-11889-2-git-send-email-vnagarnaik@google.com>
 <1335388704-26790-1-git-send-email-vnagarnaik@google.com> <1336010118.14207.75.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Wed, 2 May 2012 23:40:06 -0700
Message-ID: <CAL26m8KgvuUGhK_T91fM2dNtFt4+KSOb5-C8yNiZ888BZW1PEg@mail.gmail.com>
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

On Wed, May 2, 2012 at 6:55 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> Hmm, something in this patch breaks buffers_size_kb and friends.

I checked and I guess you are referring to the initial state of the
buffer_size_kb, which returns:
0 (expanded: 1408)
instead of:
7 (expanded: 1408)

I found this got in with the earlier patch which added per-cpu
buffer_size_kb. I will send a small fix-up patch for it.

After expanding the ring buffer to various sizes, I couldn't find any
other breakage. Is there any other behavior that you saw as odd?



Vaibhav Nagarnaik
