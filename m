Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab2FHLl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 07:41:57 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:3998 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752969Ab2FHLl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 07:41:56 -0400
Message-ID: <1339155706.25798.55.camel@x61.thuisdomein>
Subject: Re: [PATCH] delete seven tty headers
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org
Date: Fri, 08 Jun 2012 13:41:46 +0200
In-Reply-To: <4FD1DB30.80307@suse.cz>
References: <1339145808.25798.28.camel@x61.thuisdomein>
	 <4FD1DB30.80307@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 08 Jun 2012 11:41:46.0303 (UTC) FILETIME=[AEF9B4F0:01CD456B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-08 at 13:00 +0200, Jiri Slaby wrote:
> On 06/08/2012 10:56 AM, Paul Bolle wrote:
> > --- a/include/linux/Kbuild
> > +++ b/include/linux/Kbuild
> > @@ -84,7 +84,6 @@ header-y += capability.h
> >  header-y += capi.h
> >  header-y += cciss_defs.h
> >  header-y += cciss_ioctl.h
> > -header-y += cdk.h
> >  header-y += cdrom.h
> >  header-y += cgroupstats.h
> >  header-y += chio.h
> > @@ -93,7 +92,6 @@ header-y += cn_proc.h
> >  header-y += coda.h
> >  header-y += coda_psdev.h
> >  header-y += coff.h
> > -header-y += comstats.h
> >  header-y += connector.h
> >  header-y += const.h
> >  header-y += cramfs_fs.h
> 
> NACK for these two files. I rather prefer going through the
> deprecate-wait_years-delete path (removal of __KERNEL__ parts, if there
> are any, is OK). 

No, none of these headers have __KERNEL__ parts.

> I doubt there are any users at all, but we still should
> gave them a chance to fix their builds (remove those #include's and
> potentially used defined/structs) and not introduce a userspace build
> breakage.

I guess I'm being naive here, but will userspace still end up with
something usable on older kernels (ie, kernels that still used the
various things provided by these headers)? And, even then, are there
still stable kernels that could possibly have working drivers related to
these two headers?

If so I'm fine with providing these headers some additional time. But
then we should add a "#warning# to these two headers and add a related
entry to Documentation/feature-removal-schedule.txt). 

> The rest is OK to be removed.

Thanks,


Paul Bolle

