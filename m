Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab2BOVXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 16:23:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55132 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab2BOVXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 16:23:14 -0500
Date: Wed, 15 Feb 2012 13:23:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
Cc: masami.hiramatsu.pt@hitachi.com, ananth@in.ibm.com,
        linux-kernel@vger.kernel.org, jbaron@redhat.com, rostedt@goodmis.org,
        srikar@linux.vnet.ibm.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] Return proper error code from register_kprobe()
Message-Id: <20120215132310.21c0dc77.akpm@linux-foundation.org>
In-Reply-To: <4F3B5BB3.9030907@linux.vnet.ibm.com>
References: <4F3B5BB3.9030907@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Feb 2012 12:46:03 +0530
Prashanth Nageshappa <prashanth@linux.vnet.ibm.com> wrote:

> register_kprobe() aborts if the address of the new request falls in a
> prohibited area (such as ftrace pouch, __kprobes annotated functions,

I'm sitting here wondering what you meant to type when you typed
"ftrace pouch".  I'm stumped!  But you're not allowed to tell us - that
would take all the fun out of it.

> non-kernel text addresses, jump label text). We however don't return the
> right error on this abort, resulting in a silent failure - incorrect 
> adding/reporting of kprobes ('perf probe do_fork+18' or
> 'perf probe mcount' for instance).
> 
> In V2 we are incorporating Masami Hiramatsu's  feedback.
> 
> This patch fixes it by returning -EINVAL upon failure.
> 
> While we are here, rename the label used for exit to be more appropriate.
> 
> Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Signed-off-by: Prashanth K Nageshappa <prashanth@linux.vnet.ibm.com>
> Cc: stable@vger.kernel.org

So we want this for 3.3 with a -stable backport.
