Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab0JOBzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 21:55:08 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41179 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab0JOBzH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 21:55:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=o5Ukoda2sP36HMb9G3Gizews4sP2u5TKZdHBU3OuCjx85FmLmp7GMBEXukHiB7JqUu
         0K/U9CRn1Q3sbp9NZGfXQ07s3WBlmAboQ19wgOJyrOcchqABXW0E22Jdiu+Wl9xVgyvf
         +/IvyW4bh1+WJW8dpzAzFIFA+HIb0n4pMsOM4=
MIME-Version: 1.0
Reply-To: linasvepstas@gmail.com
In-Reply-To: <1287103733-7121-1-git-send-email-nacc@us.ibm.com>
References: <1287103733-7121-1-git-send-email-nacc@us.ibm.com>
From: Linas Vepstas <linasvepstas@gmail.com>
Date: Thu, 14 Oct 2010 20:54:46 -0500
Message-ID: <AANLkTinEzRpREFzDVhPS5ynqjYydHOs9iW5NM6W9Tf9A@mail.gmail.com>
Subject: Re: [PATCH v2] pseries: don't override CONFIG_PPC_PSERIES_DEBUG
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: michael@ellerman.id.au, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Brian King <brking@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>, Frans Pop <elendil@planet.nl>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 October 2010 19:48, Nishanth Aravamudan <nacc@us.ibm.com> wrote:
> eeh and pci_dlpar #undef DEBUG, but I think they were added before the
> ability to control this from Kconfig. It's really annoying to only get
> some of the debug messages from these files. Leave the lpar.c #undef
> alone as it produces so much output as to make the kernel unusable.
> Update the Kconfig text to indicate this particular quirk :)
>
> Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>

OK, ignore my last email.

Acked by: Linas Vepstas <linasvepstas@gmail.com>


> --- a/arch/powerpc/platforms/pseries/Kconfig
> +++ b/arch/powerpc/platforms/pseries/Kconfig
> @@ -47,6 +47,12 @@ config LPARCFG
>  config PPC_PSERIES_DEBUG
>        depends on PPC_PSERIES && PPC_EARLY_DEBUG
>        bool "Enable extra debug logging in platforms/pseries"
> +        help
> +         Say Y here if you want the pseries core to produce a bunch of
> +         debug messages to the system log. Select this if you are having a
> +         problem with the pseries core and want to see more of what is
> +         going on. This does not enable debugging in lpar.c, which must
> +         be manually done due to its verbosity.
>        default y

Umm, I see "default y" and you are not changing this but ... default y
?? Really?

Also, I am guessing that the lpar spam is due only to a handful of printk's,
while most of the rest will be infrequent.  Just knock out the
high-frequency ones...

--linas
