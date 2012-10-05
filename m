Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130Ab2JERM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 13:12:29 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:40815 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756998Ab2JERM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 13:12:28 -0400
Message-ID: <1349457006.20387.41.camel@falcor>
Subject: Re: Module xattr signatures
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Kasatkin@ozlabs.org,
        Kees Cook <keescook@chromium.org>, David Howells <dhowells@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 05 Oct 2012 13:10:06 -0400
In-Reply-To: <CALLzPKYTaOX0SNkT_z9snyEMSQ4paKLf3H-C=O0vM-Gc8O99UA@mail.gmail.com>
References: <87a9w11yhs.fsf@rustcorp.com.au>
	 <CALLzPKYTaOX0SNkT_z9snyEMSQ4paKLf3H-C=O0vM-Gc8O99UA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12100517-7606-0000-0000-0000043CF273
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-05 at 17:42 +0300, Kasatkin, Dmitry wrote:
> Hello,
> 
> On Fri, Oct 5, 2012 at 4:47 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> >
> > Hi all,
> >
> >         Had a talk with Mimi, and IMA still wants xattr signatures on
> > modules like they have for other files with EVM.  With Kees' patches now
> > merged into my modules-wip branch (warning, rebases frequently), this
> > should be pretty simple.  Dmitry?
> >
> 
> Yes, there is no difference for IMA/EVM what type of file has a
> signature to verify.
> It just reads the signature from the xattr. With the module hook it
> will just do the same
> for modules as well. It is independent of appended signature verification.
> The format of signatures is different at the moment.

> >         The question of whether this falls back to appended signatures
> > if there's no xattr support, or whether we fix cpio depends on whether
> > someone is prepared to do the latter.  As Mimi points out, AIX, bsd,
> > solaris all have versions of cpio that support extended attributes, as
> > does the bsdcpio Debian package, for example.
> >
> 
> As I already said in one of my early mails, I am not sure at all if
> IMA really needs to verify a signature,
> if primary mechanism is to use appended signature.

Which is the preferred method is exactly the point. That depends on your
use case.  For systems with IMA-appraisal already enabled, there would
not be any reason for the appended signature verification.

Now, with the MODULE_CHECK hook, systems could define an IMA-appraisal
policy to appraise just kernel modules.

The remaining issue is how to deal with filesystems that don't have
extended attribute support.  As we've already had this discussion, lets
summarize the different options:

- don't support them

Not very friendly.

- modify the new syscall to pass the signature and signature length

Kees nixed this idea.

- fall back to appended signature verification

In addition to David Howell's version of the appended signature
verification, I would like having the existing EVM/IMA-appraisal
signature format, based on Dmitry's proposed kernel module patches, as
another option.

thanks,

Mimi

