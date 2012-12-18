Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab2LRTRx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 14:17:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306Ab2LRTRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 14:17:52 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <9cfc0861cd3ae0a7d4e72056c00b8bebef1490eb.1355853060.git.joe@perches.com>
References: <9cfc0861cd3ae0a7d4e72056c00b8bebef1490eb.1355853060.git.joe@perches.com> <6433.1355840610@warthog.procyon.org.uk>
To: Joe Perches <joe@perches.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Warn on #include <uapi/...
Date: Tue, 18 Dec 2012 19:17:03 +0000
Message-ID: <12373.1355858223@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> wrote:

> +			if ($path =~ "^uapi/") {
> +				ERROR("UAPI_INCLUDE",
> +				      "#include should not start with uapi/\n" . $herecurr);
>  			}

But does this limit the check only to headers in uapi/ directories?  You need
to be able to do this outside of a uapi/ directory.  For instance,
include/linux/fs.h shadows include/uapi/linux/fs.h and so the former has to
#include the latter directly as <uapi/linux/fs.h> or else suffer a circular
link.

David
