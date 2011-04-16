Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab1DPN7e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 09:59:34 -0400
Received: from pqueuea.post.tele.dk ([193.162.153.9]:34723 "EHLO
	pqueuea.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab1DPN7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 09:59:31 -0400
Date: Sat, 16 Apr 2011 15:59:12 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Francis Moreau <francis.moro@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Kbuild: how to cleanly retrieve information compilation about
	the last build
Message-ID: <20110416135912.GA1044@merkur.ravnborg.org>
References: <BANLkTi=GXro_xEiRyzZY86kWM9duJ3KAUQ@mail.gmail.com> <BANLkTi=2aRu6x3uZtpMvPd2BSpYpkT5yfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=2aRu6x3uZtpMvPd2BSpYpkT5yfQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 16, 2011 at 10:05:43AM +0200, Francis Moreau wrote:
> Hello Sam,
> 
> Maybe could suggest something, it would be great.
> 
> Thanks
> 
> On Thu, Apr 14, 2011 at 9:13 AM, Francis Moreau <francis.moro@gmail.com> wrote:
> > Hello,
> >
> > I'm writing a script to automatise some parts of my kernel compilation process.
> >
> > From those scripts I'd like to be able to call the top makefile the
> > same way it had been called during its last invocation.
> >
> > For example, if Ido:
> >
> >     $ make CC=my-gcc CFLAGS="-g -fwhatever"
> >
> > I would like to retrieve the "CC=my-gcc CFLAGS="-g -fwhatever" part of
> > the last invocation so my script can call make with the same
> > arguments.
> >
> > Is this possible ?

There is nothing made in kbuild to preserve the value of randomly
added variable assignments on the command-line.

If you specify O=... then a Makfile file is generated in the output
directory that thus emulate the O= setting.

CCFLAGS has btw. no effect when you build a kernel.

If you on a regular basis need to pass flags on the command-line
then you likely are doing something odd as this is not the typical use.
So please reconsider what you are doing.

And you can as pointed out by Américo Wang always save the
command line in your calling script.

	Sam
