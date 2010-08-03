Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab0HCTxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 15:53:38 -0400
Received: from mail.perches.com ([173.55.12.10]:2226 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106Ab0HCTxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 15:53:37 -0400
Subject: Re: [PATCH] flex_array: add helpers to get and put to make
 pointers easy to use
From: Joe Perches <joe@perches.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
        dave@linux.vnet.ibm.com, akpm@linux-foundation.org, jmorris@namei.org,
        sds@tycho.nsa.gov
In-Reply-To: <20100803193623.22126.18019.stgit@paris.rdu.redhat.com>
References: <20100803193623.22126.18019.stgit@paris.rdu.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Aug 2010 12:53:33 -0700
Message-ID: <1280865213.6088.15.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-03 at 15:36 -0400, Eric Paris wrote:
> Getting and putting arrays of pointers with flex arrays is a PITA.  You
> have to remember to pass &ptr to the _put and you have to do weird and
> wacky casting to get the ptr back from the _get.  Add two functions
> flex_array_get_ptr() and flex_array_put_ptr() to handle all of the magic.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>
> ---
> 
>  include/linux/flex_array.h |    6 ++++++
>  lib/flex_array.c           |   25 ++++++++++++++++++++++++-
>  2 files changed, 30 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/flex_array.h b/include/linux/flex_array.h
> index 1d747f7..f4e4eb2 100644
> --- a/include/linux/flex_array.h
> +++ b/include/linux/flex_array.h
> @@ -70,4 +70,10 @@ int flex_array_clear(struct flex_array *fa, unsigned int element_nr);
>  void *flex_array_get(struct flex_array *fa, unsigned int element_nr);
>  int flex_array_shrink(struct flex_array *fa);
>  
> +#define flex_array_put_ptr(fa, nr, src, gfp)	({						\
> +						 void *_src = (src);				\
> +						 flex_array_put((fa), (nr), &_src, (gfp));	\
> +						})

Might be nicer to use fewer indents.
Isn't this equivalent?

#define flex_array_put_ptr(fa, nr, src, gfp)			\
	flex_array_put(fa, nr, &(void *)(src), gfp)


