Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab0F3Vwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 17:52:43 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:41631 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755Ab0F3Vwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 17:52:42 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Kulikov Vasiliy <segooon@gmail.com>
Subject: Re: [PATCH 1/7] Add a target to use the Coccinelle checker
Date: Wed, 30 Jun 2010 23:52:33 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Randy Dunlap <rdunlap@xenotime.net>, Roland Dreier <rdreier@cisco.com>,
       Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, Michal Marek <mmarek@suse.cz>,
       Sam Ravnborg <sam@ravnborg.org>, Julia Lawall <julia@diku.dk>,
       Gilles Muller <Gilles.Muller@lip6.fr>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, cocci@diku.dk,
       Wolfram Sang <w.sang@pengutronix.de>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>,
       =?iso-8859-1?q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Andy Isaacson <adi@hexapodia.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, walter harms <wharms@bfs.de>,
       Joerg Roedel <joro@8bytes.org>, Jan Engelhardt <jengelh@medozas.de>
References: <1275837307-4283-1-git-send-email-npalix@diku.dk> <1275837307-4283-2-git-send-email-npalix@diku.dk> <20100630185851.GA17502@shinshilla>
In-Reply-To: <20100630185851.GA17502@shinshilla>
MIME-Version: 1.0
X-Length: 4741
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006302352.34594.npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 June 2010 20:58:54 Kulikov Vasiliy wrote:
> Hi,
> 
> On Sun, Jun 06, 2010 at 17:15 +0200, Nicolas Palix wrote:
> > +    echo ' The semantic patch that makes this change is available'
> > +    echo " in $FILE."
> > +    echo ''
> > +    echo ' More information about semantic patching is available at'
> > +    echo ' http://coccinelle.lip6.fr/'
> > +    echo ''
> > +
> > +    $SPATCH -D $MODE -very_quiet -sp_file $COCCI $OPT -dir $DIR
> 
> Here I've got output:
> 
> /usr/lib/coccinelle/spatch: unknown option `-very_quiet'.
> Usage: spatch -sp_file <SP> <infile> [-o <outfile>] [-iso_file <iso>] [options]
> Options are:
> [...]
> 
> 
> I use ubuntu Lucid 10.04 as said in Documentation/coccinelle.txt.
> 
> $ LANG=C apt-cache policy coccinelle
> [...]
>   Installed: 0.2.0.deb-1ubuntu2
> [...]
> 
> 
> If I delete -very_quiet then It runs OK, but output is not ommited:

Indeed, I just checked that. This option has been added in 0.2.1
which was not ported from Debian before the feature freeze of Ubuntu Lucid :(

> 
> init_defs_builtins: /usr/share/coccinelle/standard.h
> HANDLING: /home/vasya/dev/linux-next/security/min_addr.c
> HANDLING: /home/vasya/dev/linux-next/security/keys/proc.c
> HANDLING: /home/vasya/dev/linux-next/security/keys/keyring.c
> HANDLING: /home/vasya/dev/linux-next/security/keys/gc.c
> HANDLING: /home/vasya/dev/linux-next/security/keys/process_keys.c
> HANDLING: /home/vasya/dev/linux-next/security/keys/request_key_auth.c
> [...]
> 
> 
> > +if [ "$COCCI" = "" ] ; then
> > +    for f in `find $srctree/scripts/coccinelle/ -name '*.cocci' -type f | sort`; do
> > +	coccinelle $f $srctree;
> > +    done
> > +else
> > +    coccinelle $COCCI $srctree
> > +fi
> 
> I think it is more usefull to use $M instead of $srctree to run simple
> 'make coccicheck'.

What is the purpose of $M ?

I submitted an incremental patch to add support for $C.


> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Nicolas Palix
Tel: (+33) 1 44 27 87 25
Tel: (+33) 6 81 07 91 72
Web: http://www.diku.dk/~npalix/
