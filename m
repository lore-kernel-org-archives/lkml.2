Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab2BWPYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 10:24:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756191Ab2BWPYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 10:24:45 -0500
Date: Thu, 23 Feb 2012 16:17:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ptrace] Problem with ptrace cleanup logic.
Message-ID: <20120223151754.GA1065@redhat.com>
References: <201202230526.q1N5QdUc035041@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201202230526.q1N5QdUc035041@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23, Tetsuo Handa wrote:
>
> I noticed that ptrace(PTRACE_ATTACH, 1) makes the global init process remain
> killable even after a process that called ptrace(PTRACE_ATTACH, 1) exits.

Yes, known problem. We should cleanup the usage of signal->flags.
This also allows to kill the new bitfields in signal_struct.

But firstly we should cleanup force_sig_info(), I sent the initial
patches.

The problem is: init loses SIGNAL_UNKILLABLE.

Oleg.

