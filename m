Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066Ab1COUL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 16:11:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755392Ab1COUL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 16:11:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1300211077.3748.2.camel@localhost.localdomain>
References: <1300211077.3748.2.camel@localhost.localdomain> <20110310202516.GA16122@suse.de> <20110307210656.GA1750@suse.de> <18893.1299607373@redhat.com> <29980.1299861232@redhat.com> <20110315173810.GA12775@suse.de>
To: Eric Paris <eparis@redhat.com>
Cc: dhowells@redhat.com, Tony Jones <tonyj@suse.de>,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: PATCH [1/1]: audit: acquire creds selectively to reduce atomic op overhead
Date: Tue, 15 Mar 2011 20:11:17 +0000
Message-ID: <21526.1300219877@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris <eparis@redhat.com> wrote:

> WARN_ON(cred != current->cred && cred->refcnt != 1)

'tsk->parent == current' perhaps?  Or audit_alloc() could pass a flag
indicating the state, or just look to see if tsk->audit_context is still NULL.

David
