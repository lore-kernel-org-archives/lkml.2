Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab2BAAVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 19:21:10 -0500
Received: from [206.117.179.246] ([206.117.179.246]:33327 "EHLO labridge.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752937Ab2BAAVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 19:21:09 -0500
Message-ID: <1328055665.14714.5.camel@joe2Laptop>
Subject: Re: [PATCH 1/4] coda: Remove unnecessary OOM messages
From: Joe Perches <joe@perches.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
        codalist@TELEMANN.coda.cs.cmu.edu, linux-kernel@vger.kernel.org
Date: Tue, 31 Jan 2012 16:21:05 -0800
In-Reply-To: <4F288178.4040405@gmail.com>
References: <cover.1328049542.git.joe@perches.com>
	 <db4ffce1e5a8a3a6e54e7a4f6487e822709dbdba.1328049542.git.joe@perches.com>
	 <4F288178.4040405@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Since CODA_ALLOC no longer uses __FILE__ and __LINE__ and doesn't use
> the cast argument any more, it can be replaced with a static inline
> function. Something like this (untested, applies on top of your patch):

Hi Ryan.

I didn't want to be quite so invasive
but this looks like a nice cleanup to me.

Maybe because alloc/free functions are
used relatively infrequently, maybe it'd
be better to not declare the functions
inline but add them to coda_linux.c

> +static inline void *coda_alloc(size_t size)
> +{
> +	if (size < PAGE_SIZE)
> +		return kzalloc(size, GFP_KERNEL);
> +	return vzalloc(size);
> +}
[]
> +static inline void coda_free(const void *ptr, size_t size)
> +{
> +	if (size < PAGE_SIZE)
> +		kfree(ptr);
> +	else
> +		vfree(ptr);
> +}


