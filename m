Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab1ACDqr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 22:46:47 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44339 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab1ACDqq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 22:46:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=e+YN3eJktCQikTPppDVuIGYUwMsPrOuQ5902cykRfiSDXBL9zsoUIHJg+Qqr4ebpgJ
         sAsQDeGWSKVLIBYTlIUSGSMmAbSrOBXNnM2lwFBW9NoT1kzMUWSsqlOwLGy7QIiaOU9e
         w4L6nP3SZc+06NnIpf3UH2IqWWbGuKDChgsXg=
MIME-Version: 1.0
In-Reply-To: <E1PZXeb-0004AV-2b@tytso-glaptop>
References: <E1PZXeb-0004AV-2b@tytso-glaptop>
Date: Mon, 3 Jan 2011 12:46:45 +0900
Message-ID: <AANLkTi=9ZNk6w8PxvveWHy5+okfTyKUj3L2ywFOuFjoq@mail.gmail.com>
Subject: Re: Should we be using unlikely() around tests of GFP_ZERO?
From: Minchan Kim <minchan.kim@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 3, 2011 at 8:48 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> Given the patches being busily submitted by trivial patch submitters to
> make use kmem_cache_zalloc(), et. al, I believe we should remove the
> unlikely() tests around the (gfp_flags & __GFP_ZERO) tests, such as:
>
> -       if (unlikely((flags & __GFP_ZERO) && objp))
> +       if ((flags & __GFP_ZERO) && objp)
>                memset(objp, 0, obj_size(cachep));
>
> Agreed?  If so, I'll send a patch...

I support it.

Recently Steven tried to gather the information.
http://thread.gmane.org/gmane.linux.kernel/1072767
Maybe he might have a number for that.


>
>                                                - Ted
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom policy in Canada: sign http://dissolvethecrtc.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>



-- 
Kind regards,
Minchan Kim
