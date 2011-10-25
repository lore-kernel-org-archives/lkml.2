Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab1JYCTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 22:19:18 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:39673 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755818Ab1JYCTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 22:19:13 -0400
X-Sasl-enc: eMPa//oK0poyJvOUhgsFtpEOPjrmDlDTSK/ZOePsJUQt 1319509152
Date: Tue, 25 Oct 2011 03:49:11 +0200
From: Greg KH <greg@kroah.com>
To: Jari Ruusu <jariruusu@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel.org tarball/patch signature files
Message-ID: <20111025014911.GC22764@kroah.com>
References: <4EA3F7C0.24E469C5@users.sourceforge.net>
 <20111023113727.GA24285@kroah.com>
 <4EA41FB7.CB5369CF@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EA41FB7.CB5369CF@users.sourceforge.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 05:07:51PM +0300, Jari Ruusu wrote:
> Greg KH wrote:
> > On Sun, Oct 23, 2011 at 02:17:20PM +0300, Jari Ruusu wrote:
> > > Wrong order to verify compressed tarball/patch:
> > >
> > > (1) Feed potentially maliciously formatted data to decompressor, and exploit
> > >     any undiscovered/unpatched vulnerability in decompressor implementation.
> > > (2) Verify decompressed output.
> > >
> > > Much better order would be:
> > >
> > > (1) Verify compressed data.
> > > (2) Feed trusted data to decompressor.
> > >
> > > So, would it be possible to have multiple signature files like this? Please.
> > >
> > > patch-3.X.Y.bz2
> > > patch-3.X.Y.bz2.sign
> > > patch-3.X.Y.gz
> > > patch-3.X.Y.gz.sign
> > > patch-3.X.Y.xz
> > > patch-3.X.Y.xz.sign
> > 
> > Nope, sorry, let's try this way instead.  That way we only have to
> > generate one signature, not 3.
> 
> How about one signed message that contains multiple SHA256 sums or whatever?
> 
>   sha256sum patch-3.X.Y.{bz2,gz,xz} | gpg --clearsign -a >patch-3.X.Y.sign
> 
> That allows verification before decompression.
> 
> > If you are really worried about decompressor bugs, then run them in a
> > virtual machine/chroot :)
> 
> I am not amused.
> 
> Greg, please put your security hat on, and look at this from security point
> of view. Decompression after verify removes/closes attacks utilizing yet
> unidentified decompressor bugs or security flaws.

Please realize that we are building this whole thing back up from
scratch here, and some services are not possible to do just yet.

Also realize our constraints.  I don't want to, and in fact it's almost
impossible to, upload the 3 compressed tarballs over a large number of
internet connections that I have access to as I travel around the world.
So, given that you don't want all kernel release maintainers to store
their private keys on the server (remember what just happened), the
ability to generate that signature would be a pretty difficult thing,
right?

So, we are working on a proposal that has a "throw away" signature for
the compressed files, that can be verified by people after they download
the tarball to ensure that they didn't get something "odd".  That will
handle the sha256sum, and allow us to add future compression types with
no need to regenerate the "real" signatures from the original release.

The real check, to verify that this tarball really came from "me" should
be done on the uncompressed tarball, which is what I can sign, and it is
something that you, or anyone else, can reliable duplicate on their own
by just using git and not even downloading the tarball at all.

In other words, we just saved you a MASSIVE bandwidth transation for all
of your future kernel downloads, and you can reliable know that the
tarball you have in your system is what is on the kernel.org servers
without you even having to download it yourself and run those
decompression tools that you don't trus.

And still you complain :)

Hope this helps explain why this is the way it is.  It's as if people
think we are just making it up as we go along...

greg k-h
