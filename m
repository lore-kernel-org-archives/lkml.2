Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759071Ab2HJOq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 10:46:56 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40668 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758259Ab2HJOqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 10:46:51 -0400
Date: Fri, 10 Aug 2012 15:51:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Masatake YAMATO <yamato@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/15] Proc entry showing inodes on sockfs and types
Message-ID: <20120810155127.3173b904@pyramind.ukuu.org.uk>
In-Reply-To: <20120810.230532.947107481182263685.yamato@redhat.com>
References: <20120810.230532.947107481182263685.yamato@redhat.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#ifdef CONFIG_PROC_FS
> +	/* Set non-zero value if this protocol manages its
> +	   own /proc/net/PROTOCOL entry and the entry has inode column. */
> +        int has_own_proc_entry;
> +#endif

Is it really worth ifdefs in every file for what is (or should be) a bool
value in the protocol structs of which there are not many

>  };
>  
>  /*
> diff --git a/net/socket.c b/net/socket.c
> index dfe5b66..4044b58 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -105,6 +105,10 @@
>  #include <linux/sockios.h>
>  #include <linux/atalk.h>
>  
> +#ifdef CONFIG_PROC_FS
> +#include <linux/rwlock_types.h>
> +#endif

You can include it anyway and that makes it easier to avoid bugs

