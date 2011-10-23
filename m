Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab1JWLib (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 07:38:31 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:34941 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755389Ab1JWLia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 07:38:30 -0400
X-Sasl-enc: CFsOCeL+bKle0eImi5sNUGBYMhLI4itYL81Pkb2JFt5S 1319369909
Date: Sun, 23 Oct 2011 13:37:27 +0200
From: Greg KH <greg@kroah.com>
To: Jari Ruusu <jariruusu@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel.org tarball/patch signature files
Message-ID: <20111023113727.GA24285@kroah.com>
References: <4EA3F7C0.24E469C5@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EA3F7C0.24E469C5@users.sourceforge.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 02:17:20PM +0300, Jari Ruusu wrote:
> I noticed that patch-3.0.7.sign is a detached signature file for
> DECOMPRESSED patch-3.0.7.{bz2,gz,xz}.

That's exactly what I said in my announcement:
	https://lkml.org/lkml/2011/10/23/51
so I'm glad it's working properly :)

> Maybe this is not the best possible
> way to sign compressed tarballs/patches. This is because it places hell of
> lot of trust on quality/security of decompressor implementation.
> Historically decompressor implementations have had bugs and security flaws.
> It is stupid to assume that there won't be any more of them.
> 
> Wrong order to verify compressed tarball/patch:
> 
> (1) Feed potentially maliciously formatted data to decompressor, and exploit
>     any undiscovered/unpatched vulnerability in decompressor implementation.
> (2) Verify decompressed output.
> 
> Much better order would be:
> 
> (1) Verify compressed data.
> (2) Feed trusted data to decompressor.
> 
> So, would it be possible to have multiple signature files like this? Please.
> 
> patch-3.X.Y.bz2
> patch-3.X.Y.bz2.sign
> patch-3.X.Y.gz
> patch-3.X.Y.gz.sign
> patch-3.X.Y.xz
> patch-3.X.Y.xz.sign

Nope, sorry, let's try this way instead.  That way we only have to
generate one signature, not 3.

If you are really worried about decompressor bugs, then run them in a
virtual machine/chroot :)

greg k-h
