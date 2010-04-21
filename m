Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab0DUKuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 06:50:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044Ab0DUKuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 06:50:19 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100421012908.GB24251@us.ibm.com>
References: <20100421012908.GB24251@us.ibm.com> <20100421012749.GA21338@us.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: dhowells@redhat.com, lkml <linux-kernel@vger.kernel.org>,
       Ashwin Ganti <ashwin.ganti@gmail.com>, Greg KH <greg@kroah.com>,
       rsc@swtch.com, ericvh@gmail.com, linux-security-module@vger.kernel.org,
       Ron Minnich <rminnich@gmail.com>, jt.beard@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrew Morgan <morgan@kernel.org>, oleg@us.ibm.com,
       Eric Paris <eparis@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-api@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 3/3] p9auth: add p9auth driver
Date: Wed, 21 Apr 2010 11:49:15 +0100
Message-ID: <23120.1271846955@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn <serue@us.ibm.com> wrote:

> +	if (ret == 0)
> +		commit_creds(new);
> +	else
> +		abort_creds(new);
> +
> +	return ret;

If you make this:

	if (ret == 0)
		return commit_creds(new);
	abort_creds(new);
	return ret;

then gcc can tail-call commit_creds(), which is guaranteed to return 0.

David
