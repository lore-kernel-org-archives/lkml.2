Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab2DANzK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 09:55:10 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61199 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab2DANzG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 09:55:06 -0400
Date: Sun, 1 Apr 2012 09:55:39 -0400
From: Jeff Layton <jlayton@samba.org>
To: Steve French <smfrench@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Pavel Shilovsky <piastry@etersoft.ru>, linux-cifs@vger.kernel.org
Subject: Re: [ 105/175] CIFS: Respect negotiated MaxMpxCount
Message-ID: <20120401095539.31323c95@corrin.poochiereds.net>
In-Reply-To: <CAH2r5muM-4_pVt59XeNrOZZ=28P0hT8GiMqBUk+0nxnUw9L+VA@mail.gmail.com>
References: <20120330195801.GA31806@kroah.com>
	<20120330194846.517484801@linuxfoundation.org>
	<20120331201825.036fe1d8@corrin.poochiereds.net>
	<CAH2r5muM-4_pVt59XeNrOZZ=28P0hT8GiMqBUk+0nxnUw9L+VA@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Apr 2012 02:26:58 -0500
Steve French <smfrench@gmail.com> wrote:

> On Sat, Mar 31, 2012 at 7:18 PM, Jeff Layton <jlayton@samba.org> wrote:
> > On Fri, 30 Mar 2012 12:50:10 -0700
> > Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> >> 3.3-stable review patch.  If anyone has any objections, please let me know.
> >>
> >
> > I'm not sure it's a good idea to put this patch into any stable release
> > just yet. I think it's a correct and necessary fix, but it has some
> > potential to cause regressions too (or uncover other preexisting
> > problems with this code). Might it be best to wait until we have some
> > more experience with this before we push it into stable?
> 
> Delaying it a little is probably ok, but weigh that against the
> frequency/severity
> of the problem that Pavel's fix addresses:  ie sequential writes to some
> versions of Windows 7 and Windows Vista can fail partway
> through large file copy (which also causes those servers
> to become unresponsive to subsequent connection requests
> as well) so the fix does address a hot problem.
> 
> 
> 

I'm not disputing whether this patch is correct. It's clearly a bug
that cifs.ko has never respected this value, and it's quite problematic
with certain servers.

The problem is that we don't have any confirmation that:

a) this fixes any of the problems that we think it will

b) this doesn't introduce any regressions

The request slot allocation code is quite fiddly and fragile, and I
think the potential for "b" is somewhat high. I'd feel more comfortable
if we waited until we have more experience with this patch before
merging it into stable.

-- 
Jeff Layton <jlayton@samba.org>
