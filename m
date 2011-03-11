Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab1CKQeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 11:34:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab1CKQeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 11:34:03 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20110310202516.GA16122@suse.de>
References: <20110310202516.GA16122@suse.de> <20110307210656.GA1750@suse.de> <18893.1299607373@redhat.com>
To: Tony Jones <tonyj@suse.de>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: PATCH [1/1]: audit: acquire creds selectively to reduce atomic op overhead
Date: Fri, 11 Mar 2011 16:33:52 +0000
Message-ID: <29980.1299861232@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Jones <tonyj@suse.de> wrote:

> I'm not seeing the 'tsk->real_cred' usage, can you clarify?

get_task_cred() and task_cred_xxxx() call __task_cred() which uses
tsk->real_cred.  These are the real credentials of the process, and the ones
that are used when the process is being acted upon and the ones that are
visible through /proc.

However, if a task is acting upon something, task->cred is used instead.  These
are not visible from the outside and may be overridden.  current_cred_xxx()
uses these.

It's possible that the credentials being used in audit_filter_rules() are
incorrect under most circumstances and should be task->cred, not
task->real_cred.

David
