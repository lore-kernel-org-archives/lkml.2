Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab2JOVwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 17:52:43 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:63116 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab2JOVwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 17:52:42 -0400
Date: Tue, 16 Oct 2012 01:52:30 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, criu@openvz.org, ebiederm@xmission.com,
        rientjes@google.com, devel@openvz.org
Subject: Re: [PATCH] proc: check vma->vm_file before dereferencing
Message-ID: <20121015215230.GP19449@moon>
References: <20121015152957.24859.7960.stgit@localhost.localdomain>
 <20121015144048.8fa16d28.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121015144048.8fa16d28.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 02:40:48PM -0700, Andrew Morton wrote:
> On Mon, 15 Oct 2012 19:30:03 +0400
> Stanislav Kinsbursky <skinsbursky@parallels.com> wrote:
> 
> > It can be equal to NULL.
> > 
> 
> Please write better changelogs, so people do not have to ask questions
> such as:
> 
> - Under what conditions does this bug trigger?
> 
> - In which kernel version(s)?
> 
> - Is it a post-3.6 regression?

Andrew, would the following changelog be enough?

The commit 7b540d0646ce122f0ba4520412be91e530719742 switched
proc_map_files_readdir to use @f_mode directly instead of grabbing
@file reference, but same time the test for @vm_file presence was
lost leading to nil dereference. The patch brings the test back.

The all proc_map_files feature is CONFIG_CHECKPOINT_RESTORE wrapped
(which is set to 'n' by default) so the bug doesn't affect regular
kernels.

The regression is 3.7-rc1 only as far as I can tell.
