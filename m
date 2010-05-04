Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934Ab0EDO6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 10:58:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932366Ab0EDO57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 10:57:59 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100427164517.GC7530@us.ibm.com>
References: <20100427164517.GC7530@us.ibm.com> <20100427164139.GA7359@us.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: dhowells@redhat.com, lkml <linux-kernel@vger.kernel.org>,
       Ashwin Ganti <ashwin.ganti@gmail.com>, Greg KH <greg@kroah.com>,
       rsc@swtch.com, ericvh@gmail.com, linux-security-module@vger.kernel.org,
       Ron Minnich <rminnich@gmail.com>, jt.beard@gmail.com,
       Andrew Morgan <morgan@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, Eric Paris <eparis@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Kyle Moffett <kyle@moffetthome.net>, Steve Grubb <sgrubb@redhat.com>
Subject: Re: [PATCH 3/3] RFC: p9auth: add p9auth fs
Date: Tue, 04 May 2010 15:57:17 +0100
Message-ID: <4067.1272985037@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn <serue@us.ibm.com> wrote:

> +	result = kzalloc(MAX_DIGEST_SIZE, GFP_KERNEL);
> ...
> +	ret = crypto_hash_digest(&desc, &sg, plain_text_size, result);

Does result have to be pre-cleared?

> +	user_buf = kzalloc(count+1, GFP_KERNEL);
> +	if (!user_buf)
> +		goto out;
> +
> +	if (copy_from_user(user_buf, buffer, count)) {

user_buf doesn't need preclearing.  It's just a waste of time.  This occurs
three times.

David
