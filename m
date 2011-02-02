Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab1BBX74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 18:59:56 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:41025 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755531Ab1BBX7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 18:59:54 -0500
Date: Wed, 2 Feb 2011 15:59:49 -0800
From: Dmitry Torokhov <dtor@vmware.com>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: Early crash (was: Re: module: show version information for
 built-in modules in sysfs)
Message-ID: <20110202235948.GA8676@dtor-ws.eng.vmware.com>
References: <AANLkTin4gOnEMruLDM=TkNYsNf5S370WqbcDVJzT7_Z4@mail.gmail.com>
 <20110201210944.GA12348@dtor-ws.eng.vmware.com>
 <AANLkTimv=KqtuR36dMNa+=OMi0mgd8JK4qsb_SpmKmhs@mail.gmail.com>
 <20110201222637.GA17521@dtor-ws.eng.vmware.com>
 <AANLkTikWVt8NEyHN+=yD4EWSXUQt0gt5nLJtKQDw397M@mail.gmail.com>
 <20110202194227.GA13794@dtor-ws.eng.vmware.com>
 <m2ipx2dp7v.fsf@igel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2ipx2dp7v.fsf@igel.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 02:52:04PM -0800, Andreas Schwab wrote:
> Dmitry Torokhov <dtor@vmware.com> writes:
> 
> > But why is it aligned on 2-byte boundary and why m64k is not happy with
> > module_version_attribute but is happy with kernel_param which is also
> > aligned similarly?
> 
> struct kernel_parm doesn't contain internal padding on 32 bit
> architectures (it does on 64bit architectures though).
> 
> > If we unroll module_version_attribute it woud look like this:
> >
> > struct module_version_attribute {
> >
> > 	struct module_attribute {
> >
> > 		struct attribute {
> > 			const char *name;
> > 			mode_t mode;
> > 		} attr;
> > 		...
> >
> > 	} mattr;
> >
> > 	const char *module_name;
> > 	const char *version;
> > };
> >
> > So I would expect it be aligned on (char *) boundary which should be the
> > same as (void *).
> 
> mode_t is a 16 bit type, thus any following member becomes aligned on an
> odd 2 byte boundary.

Even pointers? I'd expect pointers to be aligned on 4-bytes boundaries?

Thanks,

Dmitry
