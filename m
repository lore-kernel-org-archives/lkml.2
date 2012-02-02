Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab2BBNwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 08:52:33 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61793 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364Ab2BBNwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 08:52:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH 1/2] lkdtm: use atomic_t to replace count_lock
Date: Thu, 2 Feb 2012 13:44:19 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Prarit Bhargava <prarit@redhat.com>,
        "Greg Kroah-Hartman" <greg@kroah.com>, Dave Young <dyoung@redhat.com>
References: <1328079501-24746-1-git-send-email-xiyou.wangcong@gmail.com> <201202011527.35366.arnd@arndb.de> <4F2A90B4.1050709@gmail.com>
In-Reply-To: <4F2A90B4.1050709@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201202021344.19455.arnd@arndb.de>
X-Provags-ID: V02:K0:a0Q/p9+sEan09ITaOO+mY0AMNs/bRTW5OExbwMlmsT+
 NH1cRorKsbQGebwStkkokT18uUl0ObbMwgEdGiyZUl7pGvCW/4
 F1nhrA8cTGgD3YoVloKnpg2uCanJEnKb+lhW7wHYjkpFXuuNNB
 c4FCzSBZR/knqHBuy3oNc72IO78Sn55eIKczMVXQ/6KXh5vo61
 ADvO0KOrC+m4TdGFT9Qszi/e7P/lnXwxqcax2rRG/1urCzrAMs
 wVYvOgiGTX3uPXN8npndBmq6z3ow8M+UoNaF5W6siODHmfW1ki
 fWZZknJnZvASdHicZCQZvPsBD7baHZEtMJ9gYanBAJPmefghFx
 tFL1JiE0wxqQeAanY494=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 February 2012, Cong Wang wrote:
> > In order to have an atomic here, you have to use a loop around
> > atomic_cmpxchg, like
> >
> >
> >       int old, new;
> >       old = atomic_read(&count);
> >       do {
> >               new = old ? old - 1 : cpoint_count;
> >               old = cmpxchg(&count, old, new);
> >       } while (old != new);
> >
> > I suppose you could also just keep the spinlock and move lkdtm_do_action()
> > outside of it?
> 
> If we still need spinlock, I think we don't need to bother atomic_t at all.

Yes, it's one or the other: If you use the cmpxchg loop, you don't need a
spinlock and vice versa.

	Arnd
