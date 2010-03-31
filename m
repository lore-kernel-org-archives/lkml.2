Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954Ab0CaHjd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 03:39:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53068 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab0CaHjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 03:39:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
Subject: Re: [RFC 7/9] ppp: use big tty mutex
Date: Wed, 31 Mar 2010 09:39:14 +0200
User-Agent: KMail/1.13.1 (Linux/2.6.33-00063-g0795fff; KDE/4.4.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <gregkh@suse.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
References: <1269982580-9361-1-git-send-email-arnd@arndb.de> <1269982580-9361-8-git-send-email-arnd@arndb.de> <2375c9f91003302137x7753a744pb2d2f0655738c7e4@mail.gmail.com>
In-Reply-To: <2375c9f91003302137x7753a744pb2d2f0655738c7e4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201003310939.15324.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/pOgDBpDkt+jq9r50ZX2LclL3ELCLdy15TGDe
 ApZCLXiinSCWarTbEOp3c+gFA3GvpPUSnDw5RYRB3+t1zz76bJ
 75iToRmdH8gw+jbfjsq6w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 March 2010 06:37:12 Américo Wang wrote:
> > @@ -362,7 +362,8 @@ static const int npindex_to_ethertype[NUM_NP] = {
> >  */
> >  static int ppp_open(struct inode *inode, struct file *file)
> >  {
> > -       cycle_kernel_lock();
> > +       tty_lock();
> > +       tty_unlock();
> 
> I don't really get your point here. :) Why do you do this?

This is a blind conversion of the API from the common BKL functions to
the TTY lock functions. There is no cycle_tty_lock(), so I'm manually
doing the cycle.

The reason why cycle_kernel_lock() was introduced in the first place
is that some drivers may depend on the open() function not returning
while another CPU holds the BKL. I did not feel qualified (or motivated)
to determine if the ppp code has the behavior, so I left it at this.

	Arnd
