Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab2LRQxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 11:53:38 -0500
Received: from www84.your-server.de ([213.133.104.84]:40609 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259Ab2LRQxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 11:53:36 -0500
Message-ID: <1355849558.26967.24.camel@wall-e>
Subject: Re: [PATCH 6/6] Add 32 bit VDSO support for 32 and 64 bit kernels
From: Stefani Seibold <stefani@seibold.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, ak@linux.intel.com, aarcange@redhat.com,
        john.stultz@linaro.org, luto@amacapital.net, xemul@parallels.com,
        gorcunov@openvz.org, andriy.shevchenko@linux.intel.com
Date: Tue, 18 Dec 2012 17:52:38 +0100
In-Reply-To: <50D09733.3080502@zytor.com>
References: <1355823656-13902-1-git-send-email-stefani@seibold.net>
	 <1355823656-13902-7-git-send-email-stefani@seibold.net>
	 <50D09733.3080502@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 18.12.2012, 08:17 -0800 schrieb H. Peter Anvin:
> On 12/18/2012 01:40 AM, stefani@seibold.net wrote:
> > From: Stefani Seibold <stefani@seibold.net>
> > 
> > This patch adds support for 32 bit VDSO.
> > 
> > For 32 bit programs running on a 32 bit kernel, the same mechanism is
> > used as for 64 bit programs running on a 64 bit kernel.
> > 
> > For 32 bit programs running under a 64 bit IA32_EMULATION, it is a
> > little bit more tricky. In this case the VVAR and HPET will be mapped
> > into the 32 bit address space, by cutting of the upper 32 bit. So the
> > address for this will not changed in the view of the 32 bit VDSO. The
> > HPET will be mapped in this case at 0xff5fe000 and the VVAR at 0xff5ff000.
> > 
> > The transformation between the in 64 bit kernel representation and the 32 bit
> > abi will be also provided.
> > 
> > So we have one VDSO Source for all.
> > 
> 
> You seem to once again have disregarded the request to make the vvar and
> hpet part of the vdso address space proper.  If this is not possible or
> highly impractical, please extend a technical motivation why that is so,
> rather than simply ignoring it.
> 

Pardon, i never disregarded nor i have agreed that this is going to be a
part of the VDSO. I currently have also no idea how to do this and i see
no need at the moment to do this revamp. The 64 bit VDSO lives since
more than 6 years with this kind of implementation.

You asked me to do the VDSO 32 bit stuff for the IA32_EMULATION, before
it is ready for inclusion into the kernel. Thats exactly what i did. I
spend the whole weekend of my spare time to do this implementation. Now
we have them all.

The patch works perfectly, all issues are solved:

- Calling conventions
- ABI transformations
- System call gateway for X86 32 bit
- Mapping of the FIXMAP and HPET into the lower 32 bit address space for
IA32_EMULATION
- Support for 32 bit programs in 32 kernel and 64 bit kernel
- One VDSO source for all

If you prefer an other solutions, its okay. There are many ways to code
things. But for now i think it is a good step ahead. That is what i
currently can provide.

- Stefani


