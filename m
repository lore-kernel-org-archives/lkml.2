Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab2D2QDd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 12:03:33 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55780 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752524Ab2D2QDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 12:03:32 -0400
Message-ID: <1335715408.12022.7.camel@joe2Laptop>
Subject: Re: [PATCH EDACv16 1/2] edac: Change internal representation to
 work with layers
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Mark Gross <mark.gross@intel.com>,
        Jason Uhlenkott <juhlenko@akamai.com>,
        Tim Small <tim@buttersideup.com>, "Arvind R." <arvino55@gmail.com>,
        Olof Johansson <olof@lixom.net>, Egor Martovetsky <egor@pasemi.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Michal Marek <mmarek@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hitoshi Mitake <h.mitake@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Niklas =?ISO-8859-1?Q?S=F6derlund?= 
	<niklas.soderlund@ericsson.com>,
        Shaohui Xie <Shaohui.Xie@freescale.com>,
        Josh Boyer <jwboyer@gmail.com>, linuxppc-dev@lists.ozlabs.org
Date: Sun, 29 Apr 2012 09:03:28 -0700
In-Reply-To: <4F9D5A2E.2030506@redhat.com>
References: <1335289087-11337-1-git-send-email-mchehab@redhat.com>
	 <1335291342-14922-1-git-send-email-mchehab@redhat.com>
	 <20120427133304.GE9626@aftab.osrc.amd.com>
	 <1335535895.25521.7.camel@joe2Laptop> <4F9AC44A.5000509@redhat.com>
	 <20120428085223.GB26065@aftab.osrc.amd.com> <4F9D4F6E.4070106@redhat.com>
	 <4F9D5A2E.2030506@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-29 at 12:11 -0300, Mauro Carvalho Chehab wrote:
> Em 29-04-2012 11:25, Mauro Carvalho Chehab escreveu:
> > Em 28-04-2012 05:52, Borislav Petkov escreveu:
> >> On Fri, Apr 27, 2012 at 01:07:38PM -0300, Mauro Carvalho Chehab wrote:
> >>> Yes. This is a common issue at the EDAC core: on several places, it calls the
> >>> edac debug macros (DEBUGF0...DEBUGF4) passing a __func__ as an argument, while
> >>> the debug macros already handles that. I suspect that, in the past, the __func__
> >>> were not at the macros, but some patch added it there, and forgot to fix the
> >>> occurrences of its call.
> >> The patch that added it is d357cbb445208 and you reviewed it.
> > And you wrote the patch that caused it.

And Boris should have also written the follow-on patches that
removed most/all of the debugfX and __func__ uses.

> > A single patch fixing this everywhere at drivers/edac is better and clearer than adding 
> > an unrelated fix on this patch. This is already complex enough to add more unrelated
> > things there.
> > 
> > Also, a simple perl/coccinelle script can replace all such __func__ occurrences 
> > on one shot.

You make it sound simple, but it'd be a pretty complicated
cocci script.  Some of the changes would have to be inspected
or changed by hand in any case.

[]

> Most of the issues can be solved with the above script-based patch. 
> 
> There are still 171 places (12 places at the core, the rest are on the drivers)
> that will require a more sophisticated patch or that requires a manual fix.
[]
> From: Mauro Carvalho Chehab <mchehab@redhat.com>
> Date: Sun, 29 Apr 2012 11:59:14 -0300
> Subject: [PATCH] edac: Don't add __func__ or __FILE__ for debugf[0-9] msgs

Thanks Mauro, you shouldn't have had to do this.


