Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102Ab0F3S7E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 14:59:04 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42355 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab0F3S7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 14:59:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Y0Dh6l6B13hxHHzHyuzRoo/Z30I9CSeNIB3S86jvYGcsyR4SfSG9Cl/dlAMzoxVgWG
         yFpDOkX1NXYLHeaY5zMGm5Y0mayXn/1eTMaTsD7nIFg9Yp4DoMCZktwRv0MKA7e6i06F
         04MKyftQzKMDWCj0eD5Pj7EY8bWHTd6PqbxXM=
Date: Wed, 30 Jun 2010 22:58:54 +0400
From: Kulikov Vasiliy <segooon@gmail.com>
To: Nicolas Palix <npalix@diku.dk>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Roland Dreier <rdreier@cisco.com>,
       Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, Michal Marek <mmarek@suse.cz>,
       Sam Ravnborg <sam@ravnborg.org>, Julia Lawall <julia@diku.dk>,
       Gilles Muller <Gilles.Muller@lip6.fr>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, cocci@diku.dk,
       Wolfram Sang <w.sang@pengutronix.de>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Andy Isaacson <adi@hexapodia.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, walter harms <wharms@bfs.de>,
       Joerg Roedel <joro@8bytes.org>, Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/7] Add a target to use the Coccinelle checker
Message-ID: <20100630185851.GA17502@shinshilla>
References: <1275837307-4283-1-git-send-email-npalix@diku.dk>
 <1275837307-4283-2-git-send-email-npalix@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275837307-4283-2-git-send-email-npalix@diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jun 06, 2010 at 17:15 +0200, Nicolas Palix wrote:
> +    echo ' The semantic patch that makes this change is available'
> +    echo " in $FILE."
> +    echo ''
> +    echo ' More information about semantic patching is available at'
> +    echo ' http://coccinelle.lip6.fr/'
> +    echo ''
> +
> +    $SPATCH -D $MODE -very_quiet -sp_file $COCCI $OPT -dir $DIR

Here I've got output:

/usr/lib/coccinelle/spatch: unknown option `-very_quiet'.
Usage: spatch -sp_file <SP> <infile> [-o <outfile>] [-iso_file <iso>] [options]
Options are:
[...]


I use ubuntu Lucid 10.04 as said in Documentation/coccinelle.txt.

$ LANG=C apt-cache policy coccinelle
[...]
  Installed: 0.2.0.deb-1ubuntu2
[...]


If I delete -very_quiet then It runs OK, but output is not ommited:

init_defs_builtins: /usr/share/coccinelle/standard.h
HANDLING: /home/vasya/dev/linux-next/security/min_addr.c
HANDLING: /home/vasya/dev/linux-next/security/keys/proc.c
HANDLING: /home/vasya/dev/linux-next/security/keys/keyring.c
HANDLING: /home/vasya/dev/linux-next/security/keys/gc.c
HANDLING: /home/vasya/dev/linux-next/security/keys/process_keys.c
HANDLING: /home/vasya/dev/linux-next/security/keys/request_key_auth.c
[...]


> +if [ "$COCCI" = "" ] ; then
> +    for f in `find $srctree/scripts/coccinelle/ -name '*.cocci' -type f | sort`; do
> +	coccinelle $f $srctree;
> +    done
> +else
> +    coccinelle $COCCI $srctree
> +fi

I think it is more usefull to use $M instead of $srctree to run simple
'make coccicheck'.
