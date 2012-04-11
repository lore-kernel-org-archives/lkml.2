Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab2DKKr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 06:47:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394Ab2DKKrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 06:47:55 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120409190350.GA14716@redhat.com>
References: <20120409190350.GA14716@redhat.com> <20120409190323.GA14712@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] cred: copy_process() should clear child->replacement_session_keyring
Date: Wed, 11 Apr 2012 11:47:49 +0100
Message-ID: <14057.1334141269@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> keyctl_session_to_parent(task) sets ->replacement_session_keyring,
> it should be processed and cleared by key_replace_session_keyring().
> 
> However, this task can fork before it notices TIF_NOTIFY_RESUME and
> the new child gets the bogus ->replacement_session_keyring copied by
> dup_task_struct(). This is obviously wrong and, if nothing else, this
> leads to put_cred(already_freed_cred).
> 
> change copy_creds() to clear this member. If copy_process() fails
> before this point the wrong ->replacement_session_keyring doesn't
> matter, exit_creds() won't be called.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: David Howells <dhowells@redhat.com>
