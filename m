Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab1COUFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 16:05:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756429Ab1COUFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 16:05:00 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20110315173810.GA12775@suse.de>
References: <20110315173810.GA12775@suse.de> <20110310202516.GA16122@suse.de> <20110307210656.GA1750@suse.de> <18893.1299607373@redhat.com> <29980.1299861232@redhat.com>
To: Tony Jones <tonyj@suse.de>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: PATCH [1/1]: audit: acquire creds selectively to reduce atomic op overhead
Date: Tue, 15 Mar 2011 20:04:47 +0000
Message-ID: <21411.1300219487@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Jones <tonyj@suse.de> wrote:

> Agree. Also I believe it is safe to use tsk->cred directly as tsk == current 
> or tsk is being created by copy_process.  

You can't quite access it like that without sparse throwing a warning.  The
pointer is marked with an __rcu attribute, so you need to use something like
this:

	cred = rcu_dereference_check(tsk->cred, (tsk == current ||
						 called_from_copy_process());

David
