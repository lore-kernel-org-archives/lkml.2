Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296Ab1FVEaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 00:30:30 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38124 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab1FVEa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 00:30:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:date:in-reply-to:references
         :content-type:x-mailer:content-transfer-encoding:message-id
         :mime-version;
        b=gSPKW3nPAN+nQR9Rp/gvFk1NPny2V3CPOQ0ITiio8iY9/+AkQ2Q18DBvenxpMKO+f/
         7LyuzBkkQ5Pd+yegaJJB+6JB6aNTH5XRQC38cXrvTKmKbgsRJ7PxoZr2TlQS48/stklv
         V9D1u7l1YHSX3pORjRnwV2V1NqMC9cR94sZK4=
Subject: Re: [GIT PULL] UBI changes for 2.6.40
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 22 Jun 2011 07:31:10 +0300
In-Reply-To: <20110612064002.GA1712@x4.trippels.de>
References: <20110524064147.4545.43792.sendpatchset@localhost.localdomain>
	 <20110612064002.GA1712@x4.trippels.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-2.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1308717074.18119.16.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Markus,

yes, sorry, this patch was probably a mistake - I just stupidly followed
the new trend.

On Sun, 2011-06-12 at 08:40 +0200, Markus Trippelsdorf wrote:
> Either reverting or using something like this fixes the problem:

However, I am a bit reluctant to revert it now because this would only
hide the issue. And some googling shows that networking people had a
similar error in the past and solved it by reverting before the change
went upstream.

> diff --git a/include/mtd/ubi-user.h b/include/mtd/ubi-user.h
> index 3c41097..47a6c21 100644
> --- a/include/mtd/ubi-user.h
> +++ b/include/mtd/ubi-user.h
> @@ -23,6 +23,10 @@
>  
>  #include <linux/types.h>
>  
> +#ifndef __packed
> +#define __packed __attribute__((packed))
> +#endif
> +
>  /*
>   * UBI device creation (the same as MTD device attachment)
>   * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This would be a dirty hack. I think a better solution is to enhance the
"scripts/headers_install.pl" script and teach it to substitute __packed
with __attribute__((packed)). Then at "make headers_install" time this
issue would be fixed up.

Or may be the definition of __packed has to be somehow included in
ubi-user.h ...

Would you please try to make a patch and send it to lkml to hopefully
generate some discussion and the right way to go would probably be
found?

-- 
Best Regards,
Artem Bityutskiy

