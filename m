Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351Ab2GMVIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 17:08:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55589 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412Ab2GMVIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 17:08:07 -0400
Date: Fri, 13 Jul 2012 14:08:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Doug Ledford <dledford@redhat.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH] ns: move free_nsproxy() out of do_exit() path
Message-Id: <20120713140806.b3d0fda8.akpm@linux-foundation.org>
In-Reply-To: <1342180088-22647-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1342180088-22647-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2012 14:48:08 +0300
"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:

> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> free_nsproxy() is too heavy to be on exit path. Let's free namespaces
> asynchronously to not block exit_group() syscall.

Please be specific, and complete.

Why is it "too heavy"?  Where is the time being spent?  Is it spent in
D state or is it spent burning CPU cycles?  Does the patch simply
offload the work into kernel threads, providing no net gain?

> The patch also fixes bug with free namespace without synchronize_rcu() through
> put_nsproxy().

I just don't understand this description.  Please send a new one which
includes all details about the bug, including a description of
the user-visible effects of the bug.

