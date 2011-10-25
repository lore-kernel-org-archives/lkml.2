Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab1JYEb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 00:31:59 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49783 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab1JYEb6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 00:31:58 -0400
MIME-Version: 1.0
In-Reply-To: <20111025014911.GC22764@kroah.com>
References: <4EA3F7C0.24E469C5@users.sourceforge.net> <20111023113727.GA24285@kroah.com>
 <4EA41FB7.CB5369CF@users.sourceforge.net> <20111025014911.GC22764@kroah.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Tue, 25 Oct 2011 00:31:36 -0400
Message-ID: <CAGZ=bqKvb96VvZ5a+VJWZXKdr553n8SW2=JOLZS1fGY5KE7iZg@mail.gmail.com>
Subject: Re: kernel.org tarball/patch signature files
To: Greg KH <greg@kroah.com>
Cc: Jari Ruusu <jariruusu@users.sourceforge.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 21:49, Greg KH <greg@kroah.com> wrote:
> Please realize that we are building this whole thing back up from
> scratch here, and some services are not possible to do just yet.
>
> Also realize our constraints.  I don't want to, and in fact it's almost
> impossible to, upload the 3 compressed tarballs over a large number of
> internet connections that I have access to as I travel around the world.
> So, given that you don't want all kernel release maintainers to store
> their private keys on the server (remember what just happened), the
> ability to generate that signature would be a pretty difficult thing,
> right?
>
> So, we are working on a proposal that has a "throw away" signature for
> the compressed files, that can be verified by people after they download
> the tarball to ensure that they didn't get something "odd".  That will
> handle the sha256sum, and allow us to add future compression types with
> no need to regenerate the "real" signatures from the original release.
>
> The real check, to verify that this tarball really came from "me" should
> be done on the uncompressed tarball, which is what I can sign, and it is
> something that you, or anyone else, can reliable duplicate on their own
> by just using git and not even downloading the tarball at all.
>
> In other words, we just saved you a MASSIVE bandwidth transation for all
> of your future kernel downloads, and you can reliable know that the
> tarball you have in your system is what is on the kernel.org servers
> without you even having to download it yourself and run those
> decompression tools that you don't trus.
>
> And still you complain :)
>
> Hope this helps explain why this is the way it is.  It's as if people
> think we are just making it up as we go along...

Well, in theory it could still be done (albeit not in practice right now).

There is a tool called "pristine-tar" designed to generate a
byte-identical tar.gz given the original source tree.  Obviously with
git-archive you don't need the "tar" portion, but it also includes
"pristine-gz" and "pristine-bz2" tools which tease out and store the
original compression parameters in a small file.  It's commonly used
to be able to "import" a bunch of source files and a tarball into GIT
without storing the entire original tarball as a binary file.

So the kernel developers would locally produce the uncompressed and
compressed tarballs, then digitally sign them and create small
"pristine-{gz,bz2,xz}" archive deltas; the signatures and deltas would
be uploaded.

The kernel.org server would use the original input and compression
parameters to reconstruct the byte-identical compressed archive from
the output of "git archive --format=tar", again with the "pristine-*"
tools.

Unfortunately, while there are "pristine-gz" and "pristine-bz2" tools,
there has not yet been developed a "pristine-xz" tool:
  http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=499489

So it's not yet reasonably possible for the kernel.org archive, but
sometime in the future it might become so.

Cheers,
Kyle Moffett

-- 
Curious about my work on the Debian powerpcspe port?
I'm keeping a blog here: http://pureperl.blogspot.com/
