Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265Ab2IXVzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 17:55:15 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53853 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab2IXVzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 17:55:11 -0400
Date: Tue, 25 Sep 2012 01:55:07 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] c/r: prctl: fix build error for no-MMU case
Message-ID: <20120924215507.GL16532@moon>
References: <1348522892-12705-1-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348522892-12705-1-git-send-email-msalter@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 05:41:32PM -0400, Mark Salter wrote:
> Commit 1ad75b9e1 added some address checking to prctl_set_mm()
> used by checkpoint-restore. This causes a build error for no-MMU
> systems:
> 
>    kernel/sys.c: In function 'prctl_set_mm':
>    kernel/sys.c:1868:34: error: 'mmap_min_addr' undeclared (first use in this function)
> 
> The test for mmap_min_addr doesn't make a lot of sense for no-MMU
> code as noted in commit 6e1415467. This patch defines mmap_min_addr
> as 0UL in the no-MMU case so that the compiler will optimize away
> tests for "addr < mmap_min_addr".
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>

Thanks, Mark! I should add that this mmap_min_addr currently
referenced in other parts of code only under CONFIG_MMU so this
definition in header should not break anything.

Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>
