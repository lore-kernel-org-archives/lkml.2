Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335Ab1ISR55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 13:57:57 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:40420 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932213Ab1ISR54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 13:57:56 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Sep 2011 13:57:55 EDT
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: DpcqapkVM1n8ysPNh7qr8GM3pnh2.fTcTdcpQrem8CeCweT
 k_TuUV4G87hA9UE5Au3JEazp9BGPtkW.upGclS8kmlK_4JKFDoWgFQIbHz6T
 3AA0MOhC9x2TBydXDbx0DyBXuLbas3Xp0WVGLfmCzelCUZDDJGDJVdAWuwly
 M4x4mQGJp8JUu8ioYPFt4Dh98eFOCDxz7n_vs5WiXwE53pt9x9pjtREw4doH
 YU5YbqbSrlVXXvCb7iMzgSKgS1_26K9JvKB9np3nIQRps9Q.Qhb7P2hgrvhT
 ICidlfyQ7ihEVazNBaPky_LTgM9HObHnB6JryyDiteWBQy3uzigjMKhwp_H3
 iIwCaqBO.UpQDXeY0rQt_bNq7NEiQuESx4rOyDhySue07pwuWwSdVtVIVRW5
 Um67cz8FoMBCfGmy9WxTryQk-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 19 Sep 2011 12:51:10 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Vasiliy Kulikov <segoon@openwall.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Andrew Morton <akpm@linux-foundation.org>,
        kernel-hardening@lists.openwall.com, Kees Cook <kees@ubuntu.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Dan Rosenberg <drosenberg@vsecurity.com>,
        Theodore Tso <tytso@mit.edu>, Alan Cox <alan@linux.intel.com>,
        Jesper Juhl <jj@chaosbits.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [kernel-hardening] Re: [RFC PATCH 2/2] mm: restrict access to
 /proc/slabinfo
In-Reply-To: <20110919173539.GA3751@albatros>
Message-ID: <alpine.DEB.2.00.1109191249450.10968@router.home>
References: <20110910164134.GA2442@albatros> <20110914192744.GC4529@outflux.net> <20110918170512.GA2351@albatros> <CAOJsxLF8DBEC9o9pSwa6c6pMg8ByFBdsDnzg22P3ucQcP98uzA@mail.gmail.com> <20110919144657.GA5928@albatros> <CAOJsxLG8gW=BLOptpULsaAEwTravADKbNbXp5e9Wd7xVEfR9AQ@mail.gmail.com>
 <20110919155718.GB16272@albatros> <CAOJsxLGZm+npcR0YgXSE2wLC2iXCtzYyCdTDCt1LN=Z28Rm_UA@mail.gmail.com> <20110919161837.GA2232@albatros> <CAOJsxLE2od0f+6cbL2hA_31CbrqS7AUofx5DT2L9fO_7gxH+PQ@mail.gmail.com> <20110919173539.GA3751@albatros>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Sep 2011, Vasiliy Kulikov wrote:

> > > kmalloc() is still visible in slabinfo as kmalloc-128 or so.
> >
> > Yes, but there's no way for users to know where the allocations came from
> > if you mix them up with other kmalloc-128 call-sites. That way the number
> > of private files will stay private to the user, no? Doesn't that give you even
> > better protection against the infoleak?
>
> No, what it gives us is an obscurity, not a protection.  I'm sure it
> highly depends on the specific situation whether an attacker is able to
> identify whether the call is from e.g. ecryptfs or from VFS.  Also the
> correlation between the number in slabinfo and the real private actions
> still exists.

IMHO a restriction of access to slab statistics is reasonable in a
hardened environment. Make it dependent on CONFIG_SECURITY or some such
thing?



