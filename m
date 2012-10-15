Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab2JOWEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 18:04:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55545 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab2JOWE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 18:04:29 -0400
Date: Mon, 15 Oct 2012 15:04:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, criu@openvz.org, ebiederm@xmission.com,
        rientjes@google.com, devel@openvz.org
Subject: Re: [PATCH] proc: check vma->vm_file before dereferencing
Message-Id: <20121015150428.8c6dee14.akpm@linux-foundation.org>
In-Reply-To: <20121015215230.GP19449@moon>
References: <20121015152957.24859.7960.stgit@localhost.localdomain>
	<20121015144048.8fa16d28.akpm@linux-foundation.org>
	<20121015215230.GP19449@moon>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2012 01:52:30 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> On Mon, Oct 15, 2012 at 02:40:48PM -0700, Andrew Morton wrote:
> > On Mon, 15 Oct 2012 19:30:03 +0400
> > Stanislav Kinsbursky <skinsbursky@parallels.com> wrote:
> > 
> > > It can be equal to NULL.
> > > 
> > 
> > Please write better changelogs, so people do not have to ask questions
> > such as:
> > 
> > - Under what conditions does this bug trigger?
> > 
> > - In which kernel version(s)?
> > 
> > - Is it a post-3.6 regression?
> 
> Andrew, would the following changelog be enough?
> 
> The commit 7b540d0646ce122f0ba4520412be91e530719742 switched
> proc_map_files_readdir to use @f_mode directly instead of grabbing
> @file reference, but same time the test for @vm_file presence was
> lost leading to nil dereference. The patch brings the test back.
> 
> The all proc_map_files feature is CONFIG_CHECKPOINT_RESTORE wrapped
> (which is set to 'n' by default) so the bug doesn't affect regular
> kernels.
> 
> The regression is 3.7-rc1 only as far as I can tell.

Ah, I see, great, thanks.
