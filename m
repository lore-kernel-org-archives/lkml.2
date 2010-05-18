Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab0ERNwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 09:52:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757366Ab0ERNwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 09:52:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100518133925.GA1353@redhat.com>
References: <20100518133925.GA1353@redhat.com> <20100517195414.GA21504@redhat.com> <2996.1274172907@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Andrew Tridgell <tridge@samba.org>, Eric Paris <eparis@parisplace.org>,
       Jakub Jelinek <jakub@redhat.com>, James Morris <jmorris@namei.org>,
       Roland McGrath <roland@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signals: check_kill_permission: don't check creds if same_thread_group()
Date: Tue, 18 May 2010 14:50:47 +0100
Message-ID: <25639.1274190647@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> Yes, but both current_cred() and same_thread_group(current, t) call
> get_current(), and gcc doesn't cache the result because we call
> audit_signal_info() in between.

Sorry, yes.  I was reading get_current() as current_cred() for some reason.

However, you are _still_ calling get_current() twice...  So that bit of your
changelog isn't really correct.

In fact, get_current() should be __attribute_const__ since it can't change
whilst you're looking at it, except within switch_to(), probably in a piece of
assembly code, so gcc should be free to cache it as long as it likes.

David
