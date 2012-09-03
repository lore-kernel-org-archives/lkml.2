Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab2IDF6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 01:58:23 -0400
Received: from ozlabs.org ([203.10.76.45]:38871 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273Ab2IDF6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 01:58:21 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>, zohar@linux.vnet.ibm.com,
        jmorris@namei.org, dhowells@redhat.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 4/7] modsig: add integrity_module_check hook
In-Reply-To: <68a6f647ca1d4429d6b781b6cfeed9c93a346c14.1345055639.git.dmitry.kasatkin@intel.com>
References: <cover.1345055638.git.dmitry.kasatkin@intel.com> <68a6f647ca1d4429d6b781b6cfeed9c93a346c14.1345055639.git.dmitry.kasatkin@intel.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 04 Sep 2012 08:36:28 +0930
Message-ID: <87pq623dvv.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Kasatkin <dmitry.kasatkin@intel.com> writes:
> +#else
> +static inline int integrity_module_check(const void *buf, unsigned long len)
> +{
> +	return 0;
> +}
> +#endif

...

> +	err = integrity_module_check(hdr, len);
> +	if (err < 0)
> +		goto free_hdr;
> +
> +	/* cut signature tail */
> +	info->len = err;

This is a bug.

Firstly, you want the 'long' not 'int' as the return vale from
integrity_module_check().  But mainly, you want it to return 'len' not
0.

I'd also prefer it to be *immediately* after we copy from userspace.

Cheers,
Rusty.
