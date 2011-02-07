Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab1BGXYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 18:24:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755092Ab1BGXYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 18:24:11 -0500
Date: Mon, 7 Feb 2011 15:23:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [PATCH 1/2] CRED: Fix BUG() upon security_cred_alloc_blank()
 failure
Message-Id: <20110207152330.3771a11c.akpm@linux-foundation.org>
In-Reply-To: <20110207133610.18389.5602.stgit@warthog.procyon.org.uk>
References: <20110207133610.18389.5602.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Feb 2011 13:36:10 +0000
David Howells <dhowells@redhat.com> wrote:

> In cred_alloc_blank() since 2.6.32, abort_creds(new) is called with
> new->security == NULL and new->magic == 0 when security_cred_alloc_blank()
> returns an error.  As a result, BUG() will be triggered if SELinux is enabled
> or CONFIG_DEBUG_CREDENTIALS=y.
> 
> If CONFIG_DEBUG_CREDENTIALS=y, BUG() is called from __invalid_creds() because
> cred->magic == 0.  Failing that, BUG() is called from selinux_cred_free()
> because selinux_cred_free() is not expecting cred->security == NULL.  This does
> not affect smack_cred_free(), tomoyo_cred_free() or apparmor_cred_free().
> 
> Fix these bugs by
> 
> (1) Set new->magic before calling security_cred_alloc_blank().
> 
> (2) Handle null cred->security in creds_are_invalid() and selinux_cred_free().

You don't feel that these two patches should be backported into -stable?
