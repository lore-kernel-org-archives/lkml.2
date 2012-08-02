Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab2HBVis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 17:38:48 -0400
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:18800 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab2HBViq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 17:38:46 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 0/6] menuconfig: jump to search results
Date: Thu, 2 Aug 2012 23:38:40 +0200
User-Agent: KMail/1.13.5 (Linux/3.5.0-treguer; KDE/4.4.5; x86_64; ; )
Cc: Benjamin Poirier <bpoirier@suse.de>, Borislav Petkov <bp@alien8.de>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Michal Marek <mmarek@suse.cz>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Arnaud Lacombe <lacombar@gmail.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>
References: <1343676130-29770-1-git-send-email-bpoirier@suse.de> <20120802133252.GA3752@x1.osrc.amd.com> <20120802141847.GB21766@d2.synalogic.ca>
In-Reply-To: <20120802141847.GB21766@d2.synalogic.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201208022338.41040.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All,

On Thursday 02 August 2012 16:18:47 Benjamin Poirier wrote:
> On 2012/08/02 15:32, Borislav Petkov wrote:
> > On Tue, Jul 31, 2012 at 09:17:51AM -0400, Benjamin Poirier wrote:
> > > > * when searching for "DELAY" for example, I get results without numbers
> > > > to which I can't jump to:
> > > > 
> > > > ...
> > > >   │ Symbol: DEFAULT_IO_DELAY_TYPE [=0]
> > > >   │ Type  : integer
> > > >   │
> > > >   │
> > > >   │ Symbol: IO_DELAY_TYPE_0X80 [=0]
> > > >   │ Type  : integer
> > > > ...
> > > > 
> > > > maybe because they don't have "---help---" section?
> > > 
> > > Because they don't have a prompt - they don't appear in any menu at all.
> > > In that case there's nowhere to jump to. That's why those symbols don't
> > > get a number.
> > 
> > Right, so how about you don't show them at all then?
> 
> It's a search for CONFIG_ symbols not "menus". Even though the user
> doesn't have direct control over some symbols, it's still useful to know
> they exist and (possibly) what enables them. For example, searching for
> LOCKDEP tells me I can enable DEBUG_LOCK_ALLOC to get it.

Agreed.

Consider this (very simple) situation :

    config A
        bool "A"
        select B

    config B
        bool

    config C
        bool "C"
        depends on B

Returning the symbol B in the search results allows to:
  - see its dependencies           -> to see why it is thus set
  - see in what file it is defined -> to change the deps and/or selects

So, yes, returning prompt-less symbols as search results is important.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
