Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab0KCN0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 09:26:38 -0400
Received: from queueout04-winn.ispmail.ntl.com ([81.103.221.58]:48992 "EHLO
	queueout04-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754892Ab0KCN0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 09:26:36 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Glauber Costa <glommer@redhat.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        kvm-devel <kvm@vger.kernel.org>, Eelco Dolstra <e.dolstra@tudelft.nl>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Olivier Hanesse <olivier.hanesse@gmail.com>,
        Avi Kivity <avi@redhat.com>
In-Reply-To: <95805e88-b6d5-4ae2-9351-9e458656cfb8@email.android.com>
References: <4CC708DE.1070000@goop.org>
	 <1288115334.3530.7.camel@mothafucka.localdomain> <4CC8751E.40306@goop.org>
	 <95805e88-b6d5-4ae2-9351-9e458656cfb8@email.android.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 12:46:34 +0000
Message-ID: <1288788394.9309.2.camel@cthulhu.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 12.157.84.6
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [Xen-devel] Re: [PATCH] x86/pvclock-xen: zero last_value on
 resume
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=3ENABmdyEd/Fm7fR7+mZIuMDn6+IErAeEhlfWBImZFk= c=1 sm=0 a=8DdxjWjVwYkA:10 a=IkcTkHD0fZMA:10 a=xNf9USuDAAAA:8 a=ZfRw4ET0AAAA:8 a=viOL9Ws1ThB6qEOiPgEA:9 a=p35WDmoed7oj44Ex8lwA:7 a=vStYN8ZsSugNPdkUSLEkTnSlvl8A:4 a=QEXdDO2ut3YA:10 a=KciULlu47koA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-27 at 13:59 -0700, H. Peter Anvin wrote:
> I'll check it this evening when I'm at a working network again :(

Did this get applied? It seems to affect 2.6.32.x too
(http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=602273) so can we tag
it for stable as well?

Thanks,
Ian.

> 
> "Jeremy Fitzhardinge" <jeremy@goop.org> wrote:
> 
> > On 10/26/2010 10:48 AM, Glauber Costa wrote:
> >> On Tue, 2010-10-26 at 09:59 -0700, Jeremy Fitzhardinge wrote:
> >>> If the guest domain has been suspend/resumed or migrated, then the
> >>> system clock backing the pvclock clocksource may revert to a smaller
> >>> value (ie, can be non-monotonic across the migration/save-restore).
> >>> Make sure we zero last_value in that case so that the domain
> >>> continues to see clock updates.
> >>>
> >>> [ I don't know if kvm needs an analogous fix or not. ]
> >> After migration, save/restore, etc, we issue an ioctl where we tell
> >> the host the last clock value. That (in theory) guarantees
> >monotonicity.
> >>
> >> I am not opposed to this patch in any way, however.
> >
> >Thanks.
> >
> >HPA, do you want to take this, or shall I send it on?
> >
> >Thanks,
> >    J
> 

-- 
Ian Campbell

BOFH excuse #191:

Just type 'mv * /dev/null'.

