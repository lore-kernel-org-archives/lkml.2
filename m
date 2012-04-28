Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab2D1Iwd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 04:52:33 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:34450 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab2D1Iwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 04:52:31 -0400
Date: Sat, 28 Apr 2012 10:52:23 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Joe Perches <joe@perches.com>, Borislav Petkov <bp@amd64.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Mark Gross <mark.gross@intel.com>,
        Jason Uhlenkott <juhlenko@akamai.com>,
        Tim Small <tim@buttersideup.com>,
        Ranganathan Desikan <ravi@jetztechnologies.com>,
        "Arvind R." <arvino55@gmail.com>, Olof Johansson <olof@lixom.net>,
        Egor Martovetsky <egor@pasemi.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Michal Marek <mmarek@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hitoshi Mitake <h.mitake@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
	<niklas.soderlund@ericsson.com>,
        Shaohui Xie <Shaohui.Xie@freescale.com>,
        Josh Boyer <jwboyer@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH EDACv16 1/2] edac: Change internal representation to work
 with layers
Message-ID: <20120428085223.GB26065@aftab.osrc.amd.com>
References: <1335289087-11337-1-git-send-email-mchehab@redhat.com>
 <1335291342-14922-1-git-send-email-mchehab@redhat.com>
 <20120427133304.GE9626@aftab.osrc.amd.com>
 <1335535895.25521.7.camel@joe2Laptop>
 <4F9AC44A.5000509@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9AC44A.5000509@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 01:07:38PM -0300, Mauro Carvalho Chehab wrote:
> Yes. This is a common issue at the EDAC core: on several places, it calls the
> edac debug macros (DEBUGF0...DEBUGF4) passing a __func__ as an argument, while
> the debug macros already handles that. I suspect that, in the past, the __func__
> were not at the macros, but some patch added it there, and forgot to fix the
> occurrences of its call.

The patch that added it is d357cbb445208 and you reviewed it.

> This is something that needs to be reviewed at the entire EDAC core (and likely
> at the drivers).

Looks like a job for a newbie to get her/his feet wet with kernel work.

> I opted to not touch on this at the existing debug logic, as I think that the
> better is to address all those issues on one separate patch, after fixing the
> EDAC core bugs.

No,

you simply need to remove the __func__ argument in your newly added debug call:

                debugf2("%s: %d: dimm%zd (%d:%d:%d): row %d, chan %d\n", __func__,
                        i, (dimm - mci->dimms),
                        pos[0], pos[1], pos[2], row, chn);

And while you're at it, remove the rest of the __func__ arguments from
your newly added debugfX calls.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
