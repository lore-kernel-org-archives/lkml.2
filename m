Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251Ab2IENgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 09:36:32 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:58606 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab2IENg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 09:36:27 -0400
Message-ID: <1346852077.2389.7.camel@falcor>
Subject: Re: [RFC] module: signature infrastructure
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        David Howells <dhowells@redhat.com>, jmorris@namei.org,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 05 Sep 2012 09:34:37 -0400
In-Reply-To: <871uihl3bx.fsf@rustcorp.com.au>
References: <20120816013405.872.42381.stgit@warthog.procyon.org.uk>
	 <87627ufi2h.fsf@rustcorp.com.au>
	 <CALLzPKaA3MYncJD1X6B8f3p-R6FVA5-WDF-h6GGwdtinNpjqmw@mail.gmail.com>
	 <871uihl3bx.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090513-4242-0000-0000-000002CA1CF9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-05 at 09:59 +0930, Rusty Russell wrote:
> "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com> writes:
> > Hi,
> >
> > Please read bellow...
> >
> > On Tue, Sep 4, 2012 at 8:55 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> >> OK, I took a look at the module.c parts of David and Dmitry's patchsets,
> >> and didn't really like either, but I stole parts of David's to make
> >> this.
> >>
> >> So, here's the module.c part of module signing.  I hope you two got time
> >> to discuss the signature format details?  Mimi suggested a scheme where
> >> the private key would never be saved on disk (even temporarily), but I
> >> didn't see patches.  Frankly it's something we can do later; let's aim
> >> at getting the format right for the next merge window.
> >
> > In our patches key is stored on the disc in encrypted format...
> 
> Oh, I missed that twist.  Thanks for the explanation.
> 
> On consideration, I prefer signing to be the final part of the "modules"
> target rather than modules_install.  I run the latter as root, and that
> is wrong for doing any code generation.

Agreed, but keep in mind that 'modules_install' could subsequently strip
the module.

Mimi

> >> +       for (i = 0; i < *len - (sizeof(MODULE_SIG_STRING)-1); i++) {
> >> +               /* Our memcmp is dumb, speed it up a little. */
> >> +               if (((char *)mod)[i] != MODULE_SIG_STRING[0])
> >> +                       continue;
> >> +               if (memcmp(mod, MODULE_SIG_STRING, strlen(MODULE_SIG_STRING)))
> >
> > should be (mod+i)?
> 
> Yes, indeed.  Thanks, fixed.
> 
> >> +                       continue;
> >> +
> >> +               sig = mod + i + strlen(MODULE_SIG_STRING);
> >> +               siglen = *len - i - strlen(MODULE_SIG_STRING);
> >> +               *len = i;
> >> +               break;
> >> +       }
> >
> > In general please clarify why do you need such parsing at all?
> > Why not to have MODULE_SIG_STRING as a last octets of the module and
> > have signature length field before?
> > Then it is easy to get the signature and rest of the module?
> > That will be super fast...
> >
> > Please clarify.
> 
> Ignore performance, it's just not an issue here.  So the simplest code
> wins.
> 
> And it's also simpler to sign a module this way.
> 
>         (echo '~Module signature appended~'; gpg --sign ....) >> mod.ko
> 
> Cheers,
> Rusty.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


