Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926Ab2BNSNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 13:13:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753616Ab2BNSNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 13:13:19 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120214172340.GA22645@redhat.com>
References: <20120214172340.GA22645@redhat.com> <1329219673-28711-21-git-send-email-matt@console-pimps.org> <1329219673-28711-1-git-send-email-matt@console-pimps.org> <17603.1329234976@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Matt Fleming <matt@console-pimps.org>,
        linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-am33-list@redhat.com
Subject: Re: [PATCH 20/40] mn10300: Use set_current_blocked() and block_sigmask()
Date: Tue, 14 Feb 2012 18:12:59 +0000
Message-ID: <27258.1329243179@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> No, only current can change ->blocked. This is even documented in
> sigprocmask(). And more, the only correct way to change ->blocked
> is set_current_blocked(). OK, with a couple of "I know what I am
> doing" exceptions in kernel/signal.c.

I was looking at force_sig_info() and derivatives.  Is that what you refer to?

If so, is it worth providing a force_sig_info_current(),
force_sigsegv_current() and force_sig_current() to make things clearer to grep
for, I wonder?

David
