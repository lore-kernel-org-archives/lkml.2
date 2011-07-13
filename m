Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab1GMA1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 20:27:36 -0400
Received: from smtp-out.google.com ([216.239.44.51]:16555 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab1GMA1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 20:27:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:date:message-id:subject:from:to:cc:
	content-type:x-system-of-record;
	b=aH8K5U5gRtWeLIY4CW0a68rweJH+cabzS9cC9pmI7OOJkD1XKtJGaM0Kl3Pa90XmV
	ZbEkR4HrmrrOmgkgX3Niw==
MIME-Version: 1.0
Date: Tue, 12 Jul 2011 17:27:33 -0700
Message-ID: <CAA9TWobmZyyhPkumX5zN_Lp3J+XQA39R10bn9r0+Vt-mznD7og@mail.gmail.com>
Subject: ftrace: trace_pipe_raw, blocking, and splice()
From: Slava Pestov <slavapestov@google.com>
To: linux-kernel@vger.kernel.org
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi ftrace users,

I notice that tracing_buffers_splice_read() has this comment in it
around line 3900:

/* TODO: block */

Was the original intention that reading from trace_pipe_raw with
tracing enabled should block if there is no data available, rather
than returning with end of file?

If so, I suggest adding a new trace_raw special file which behaves
like the current trace_pipe_raw (return 0 on EOF). Then we'd change
trace_pipe_raw to block on EOF.

Does this sound reasonable or is breaking APIs like this unacceptable?

Slava
