Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab1JWOHz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 10:07:55 -0400
Received: from mail.tnnet.fi ([217.112.240.26]:43248 "EHLO mail.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755560Ab1JWOHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 10:07:54 -0400
Message-ID: <4EA41FB7.CB5369CF@users.sourceforge.net>
Date: Sun, 23 Oct 2011 17:07:51 +0300
From: Jari Ruusu <jariruusu@users.sourceforge.net>
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: kernel.org tarball/patch signature files
References: <4EA3F7C0.24E469C5@users.sourceforge.net> <20111023113727.GA24285@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Sun, Oct 23, 2011 at 02:17:20PM +0300, Jari Ruusu wrote:
> > Wrong order to verify compressed tarball/patch:
> >
> > (1) Feed potentially maliciously formatted data to decompressor, and exploit
> >     any undiscovered/unpatched vulnerability in decompressor implementation.
> > (2) Verify decompressed output.
> >
> > Much better order would be:
> >
> > (1) Verify compressed data.
> > (2) Feed trusted data to decompressor.
> >
> > So, would it be possible to have multiple signature files like this? Please.
> >
> > patch-3.X.Y.bz2
> > patch-3.X.Y.bz2.sign
> > patch-3.X.Y.gz
> > patch-3.X.Y.gz.sign
> > patch-3.X.Y.xz
> > patch-3.X.Y.xz.sign
> 
> Nope, sorry, let's try this way instead.  That way we only have to
> generate one signature, not 3.

How about one signed message that contains multiple SHA256 sums or whatever?

  sha256sum patch-3.X.Y.{bz2,gz,xz} | gpg --clearsign -a >patch-3.X.Y.sign

That allows verification before decompression.

> If you are really worried about decompressor bugs, then run them in a
> virtual machine/chroot :)

I am not amused.

Greg, please put your security hat on, and look at this from security point
of view. Decompression after verify removes/closes attacks utilizing yet
unidentified decompressor bugs or security flaws.

If I remember correctly, newer versions of OpenSSH disable compression
before authentication. They do that to pre-emptively close attacks resulting
yet unidentified bugs in decompression code.

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
