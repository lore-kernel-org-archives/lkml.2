Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab1AHQpQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 11:45:16 -0500
Received: from mailbox20.lycos.com ([209.202.250.20]:50669 "EHLO
	mailbox20.lycos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab1AHQpO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 11:45:14 -0500
Date: Sat, 8 Jan 2011 11:45:05 -0500 (EST)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
        Claudio Scordino <claudio@evidence.eu.com>
Message-ID: <27552986.2181294505105130.JavaMail.root@mail-zbox20.bo3.lycos.com>
In-Reply-To: <18673709.2121294505029740.JavaMail.root@mail-zbox20.bo3.lycos.com>
Subject: Re: On Linux numbering scheme
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [178.46.203.148]
X-Mailer: Zimbra 5.0 (ZimbraWebClient - FF3.0 (Linux)/5.0.18_GA_3028.CentOS5)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- "Greg KH" <gregkh@suse.de> wrote:

> On Sat, Jan 08, 2011 at 09:49:26AM -0500, Artem S. Tashkinov wrote:
> > ----- "Geert Uytterhoeven" <geert@linux-m68k.org> wrote:
> > 
> > > On Thu, Jan 6, 2011 at 09:31, Claudio Scordino
> > > <claudio@evidence.eu.com> wrote:
> > > >>   As time passes by, the Linux numbering scheme makes even
> less
> > > sense.
> > > >>   Some time ago there was a discussion on LKML about a new
> > > numbering
> > > >>   scheme but it didn't come to any positive conclusion and
> then
> > > the
> > > >>   subject was forgotten entirely. Not meaning to raise a
> clamour
> > > here
> > > >>   (and I suppose I represent a large group of Linux users
> here).
> > > I'm
> > > >>   willing to suggest a numbering scheme which I hope will
> answer
> > > all
> > > >>   known complaints and criticism.
> > > >
> > > > This seems to be a periodically recurrent topic on the list.
> > > >
> > > > If I've correctly understood all points of view, there are
> currently
> > > two
> > > > groups of developers:
> > > >
> > > > 1. Those who want to maintain the current numbering scheme,
> because
> > > they
> > > > feel comfortable with it, and because they can easily
> understand
> > > the
> > > > number of releases between one release and another.
> > > >
> > > > 2. Those who prefer having a scheme somehow related to the date,
> so
> > > they
> > > > can easily understand when a certain kernel has been released
> (i.e.
> > > how
> > > > "old" it is).
> > > >
> > > > Does really exist a numbering scheme that can satisfy both
> groups
> > > of
> > > > people ? Probably not.
> > > >
> > > > My only idea would be to maintain the usual numbering scheme,
> and
> > > just
> > > > replace the second number (6) with the year of release.
> > > >
> > > > For example:
> > > >
> > > >        2.6.36 would be 2.10.36
> > > >
> > > >        2.6.37 would be 2.11.37
> > > >
> > > >        2.6.38 would be 2.11.38
> > > >
> > > >        and so on...
> > > >
> > > > This way, you put some information about the year of release
> > > without
> > > > loosing all the benefits of the current scheme.
> > > >
> > > > But this means having two independent incremental numbers,
> which
> > > maybe
> > > > is a too insane scheme.
> > > 
> > > Then why not drop the leading "2." completely?
> > > 
> > 
> > This will break too many user space scripts/applications which
> expect
> > 2.x.x.x numbers.
> 
> What userspace scripts/applications expect numbers like that?  How do
> they handle releases like what Linus just did (2.6.37)?
> 

I've just grepped through all the shell scripts installed in Fedora 14 and
I haven't found any `uname -r` references, so it seems like  the base system
is quite safe (I haven't tried to grep through binaries as I have no clue
how to check them).

However sources of VMWare/NVIDIA/VBox/etc. kernel modules have multiples
instances of:

#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 4, 7)
#  error This driver does not support 2.4 kernels older than 2.4.7!
#elif LINUX_VERSION_CODE < KERNEL_VERSION(2, 5, 0)
#  define KERNEL_2_4
#elif LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 0)
#  error This driver does not support 2.5 kernels!
#elif LINUX_VERSION_CODE < KERNEL_VERSION(2, 7, 0)
#  define KERNEL_2_6
#else
#  error This driver does not support development kernels!
#endif

So, it seems like the only obstacle that stops us from starting a completely
new numbering scheme is proprietary or corporations driven/developed software.

Best wishes,

Artem

