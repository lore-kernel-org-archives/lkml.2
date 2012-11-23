Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab2KWNlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 08:41:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:37560 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab2KWNlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 08:41:52 -0500
Date: Fri, 23 Nov 2012 11:41:47 -0200
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Sage Weil <sage@inktank.com>,
        Alex Elder <elder@inktank.com>
Subject: Re: [ 117/171] libceph: drop ceph_con_get/put helpers and nref member
Message-ID: <20121123134141.GB3759@herton-Z68MA-D2H-B3>
References: <20121122004033.298367941@linuxfoundation.org>
 <20121122004045.096368181@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121122004045.096368181@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 04:41:03PM -0800, Greg Kroah-Hartman wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Sage Weil <sage@inktank.com>
> 
> (cherry picked from commit d59315ca8c0de00df9b363f94a2641a30961ca1c)
> 
> These are no longer used.  Every ceph_connection instance is embedded in
> another structure, and refcounts manipulated via the get/put ops.
> 
> Signed-off-by: Sage Weil <sage@inktank.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[...]
>  
>  /*
> - * generic get/put
> - */
> -struct ceph_connection *ceph_con_get(struct ceph_connection *con)
> -{
> -	int nref = __atomic_add_unless(&con->nref, 1, 0);
> -
> -	dout("con_get %p nref = %d -> %d\n", con, nref, nref + 1);
> -
> -	return nref ? con : NULL;
> -}
> -
> -void ceph_con_put(struct ceph_connection *con)
> -{
> -	int nref = atomic_dec_return(&con->nref);
> -
> -	BUG_ON(nref < 0);
> -	if (nref == 0) {
> -		BUG_ON(con->sock);
> -		kfree(con);
> -	}
> -	dout("con_put %p nref = %d -> %d\n", con, nref + 1, nref);
> -}
> -
> -/*
>   * initialize a new connection.

Although harmless in functionality not having it, may be it would be
good to also apply with this also the following commit:

commit 261030215d970c62f799e6e508e3c68fc7ec2aa9
Author: Alex Elder <elder@inktank.com>
Date:   Thu Jun 21 12:49:23 2012 -0700

    libceph: drop declaration of ceph_con_get()

    For some reason the declaration of ceph_con_get() and
    ceph_con_put() did not get deleted in this commit:
        d59315ca libceph: drop ceph_con_get/put helpers and nref member
    
    Clean that up.

-- 
[]'s
Herton
