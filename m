Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab2CWQUz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 12:20:55 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58783 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753209Ab2CWQUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 12:20:54 -0400
X-Sasl-enc: 3G/jsmysk3yCvJmOFMF1b6FBWzxJ1RsQtoN25/YsyLaH 1332519653
Date: Fri, 23 Mar 2012 09:20:51 -0700
From: Greg KH <greg@kroah.com>
To: Jonathan McCune <jonmccune@cmu.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sysfs binary attribute API flux
Message-ID: <20120323162051.GA20834@kroah.com>
References: <CAEwYmTJzzUi1qfRHYfZg77g1K7myNsAh2oDiY7hWxzRO5hQGHA@mail.gmail.com>
 <20120322212816.GB30888@kroah.com>
 <CAEwYmT+K7qr94D+ef1hgG1A2u0a9z+sopBjm08N2DcxM1FrM1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEwYmT+K7qr94D+ef1hgG1A2u0a9z+sopBjm08N2DcxM1FrM1w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 09:25:54AM -0400, Jonathan McCune wrote:
> On Thu, Mar 22, 2012 at 5:28 PM, Greg KH <greg@kroah.com> wrote:
> >> necessary to move some binary data from userspace into the kernel.
> > What exact type of binary data are you talking about here?
> 
> There is a statically linked executable, which will also take a binary
> blob as input, and produce another as output.

You are passing the kernel an executable?  I'm afraid to ask...

> >> have been using sysfs's 'struct bin_attribute'.  Unfortunately, every
> >> few kernel versions, my code breaks because of a change in the
> >> definition of some elements in this struct.  For example, kernel
> >
> > Is this a problem?  It's only an issue for code that lives outside of
> > the kernel, and there's nothing we can do about that, sorry.
> 
> My main question is one about best practices.  If using sysfs and
> keeping up with such changes is the best option available, I can live
> with that.  However, if I've somehow missed a preferred alternative,
> then I would like to use it.

No kernel api is stable, nor will it ever be, see
Documentation/stable_api_nonsense.txt for details.  As your code is
living outside of the main kernel.org tree, you will have to deal with
this for any number of different function calls you make, sysfs is not
unique at all here.

> > debugfs?
> 
> This may be an option, but my understanding is that it makes even
> fewer promises about API stability.

You are thinking about the user/kernel api stability here, not the
in-kernel api, right?  Please don't confuse the two.

> > What exactly are you using this data for?  Who creates it?  What does it
> > represent?
> 
> The research project involves using Intel TXT (or the AMD SVM
> equivalent) as a form of context switch mechanism to execute the
> statically-linked binary code in isolation from the rest of the
> system.  Thus, there's some amount of systems-level code (executes in
> ring 0) in the binary to preserve the state of the Linux kernel, but
> the majority of it performs some kind of application-specific
> (executes in ring 3) function (e.g., protects some SSL / SSH / VPN
> keys). Another way to think about it is as a provision for arbitrarily
> many virtual smart cards, e.g., from userspace this shouldn't look all
> that different from loading binary code into some kind of peripheral
> device with support for arbitrary execution. In case you're interested
> in the code or the research paper describing the approach in more
> detail:
> 
> http://flickertcb.sourceforge.net/
> 
> http://www.ece.cmu.edu/~jmmccune/papers/mccune_parno_perrig_reiter_isozaki_eurosys08.pdf

Why not just create a new syscall for your work?  That would be easier
in the longrun, and really, that is what you are doing here.

best of luck,

greg k-h
