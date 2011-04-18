Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab1DROQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 10:16:07 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:58774 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517Ab1DROP7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 10:15:59 -0400
MIME-Version: 1.0
Message-ID: <276f7410-ff4d-4a3b-ab9c-fd1b5fe8c952@default>
Date: Mon, 18 Apr 2011 07:12:46 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
Cc: Chris Mason <chris.mason@oracle.com>, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, adilger.kernel@dilger.ca, tytso@mit.edu,
        mfasheh@suse.com, jlbec@evilplan.org, matthew@wil.cx,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, hch@infradead.org,
        ngupta@vflare.org, jeremy@goop.org, JBeulich@novell.com,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        Dave Mccracken <dave.mccracken@oracle.com>, riel@redhat.com,
        avi@redhat.com, Konrad Wilk <konrad.wilk@oracle.com>, mel@csn.ul.ie,
        yinghan@google.com, gthelen@google.com, torvalds@linux-foundation.org
Subject: RE: [PATCH] xen: cleancache shim to Xen Transcendent Memory
References: <20110414212002.GA27846@ca-server1.us.oracle.com>
 <1302904935.22658.9.camel@localhost.localdomain>
 <5d23c6c4-5d68-4c2e-af24-2a08f592cb8e@default
 1303116441.5997.107.camel@zakaz.uk.xensource.com>
In-Reply-To: <1303116441.5997.107.camel@zakaz.uk.xensource.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6555.5000]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DAC4723.00C7:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Ian Campbell [mailto:Ian.Campbell@eu.citrix.com]
> > >
> > > On Thu, 2011-04-14 at 14:20 -0700, Dan Magenheimer wrote:
> > >
> > > There's no need to build this into a kernel which doesn't have
> > > cleancache (or one of the other frontends), is there? I think there
> > > should be a Kconfig option (even if its not a user visible one)
> with
> > > the appropriate depends/selects.
> >
> > Yes, you're right.  It should eventually depend on
> >
> > CONFIG_CLEANCACHE || CONFIG_FRONTSWAP
> >
> > though there's no sense merging this xen cleancache
> > shim at all unless/until Linus merges cleancache
> > (and hopefully later some evolution of frontswap).
> 
> Cleancache isn't in already? I thought I saw references to it in
> drivers/staging?

Linus said he would review it after 2.6.39-rc1 was released,
but has neither given thumbs up nor thumbs down so I'm
assuming he didn't have time and it will be reconsidered
for 2.6.40.  This latest patchset (V8) is updated in linux-next.

Yes, zcache is in driver/staging and has references to it.
I guess that proves the chicken comes before the egg...
or was it vice versa? :-)
 
> > And once cleancache (and/or frontswap) is merged,
> > there's very little reason NOT to enable one or
> > both on a Xen guest kernel.
> 
> There are software knobs to allow the host- and guest-admin to opt in
> or out as they desire though, right?

Definitely.  Both Xen and a Linux guest have runtime
options, which currently default to off.

Dan
