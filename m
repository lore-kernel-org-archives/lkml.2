Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab0IUGRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 02:17:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40528 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab0IUGRq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 02:17:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=O3KZHmsxk4i2cGCKbGB7JHDl7SILB/+FpOyDsWeSz4zH9H1imLneUYIUyLgrn2vwCn
         SYDmOCqhA21WP9yFRmTppNEGeE+1qtqZ5lqzn1ZET1/PuHIJrTW3nmT2ULqDRBsp+A3P
         aHs3cOW7/w6MueqPqw777FShqKn5yNtd8u2po=
MIME-Version: 1.0
In-Reply-To: <20100921161031.7745150e.sfr@canb.auug.org.au>
References: <20100921161031.7745150e.sfr@canb.auug.org.au>
Date: Tue, 21 Sep 2010 01:17:43 -0500
Message-ID: <AANLkTikbM17xs41abm+6DTa9DJLYM8XYeVg=bZr_n8M5@mail.gmail.com>
Subject: Re: linux-next: manual merge of the bkl-vfs tree with the cifs tree
From: Steve French <smfrench@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Greear <greearb@candelatech.com>,
        linux-cifs@vger.kernel.org, Jan Blunck <jblunck@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alternatively - I could merge the trivially modified bkl cifs patch
into the cifs-2.6.git tree if that is easier

On Tue, Sep 21, 2010 at 1:10 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Arnd,
>
> Today's linux-next merge of the bkl-vfs tree got a conflict in
> fs/cifs/cifsfs.c between commit d090dbeacd3763845d83d5de4d85aad025a28677
> ("cifs: Allow binding to local IP address") from the cifs tree and commit
> b8f05b0b9ea89cfaf6759b1eb47fff683e7016a5 ("BKL: Remove BKL from CifsFS")
> from the bkl-vfs tree.
>
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc fs/cifs/cifsfs.c
> index 52e89ea,4e273f7..0000000
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@@ -35,8 -35,6 +35,7 @@@
>  #include <linux/delay.h>
>  #include <linux/kthread.h>
>  #include <linux/freezer.h>
> - #include <linux/smp_lock.h>
>  +#include <net/ipv6.h>
>  #include "cifsfs.h"
>  #include "cifspdu.h"
>  #define DECLARE_GLOBALS_HERE
>



-- 
Thanks,

Steve
