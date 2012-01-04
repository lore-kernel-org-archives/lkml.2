Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab2ADNf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 08:35:28 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:30546 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab2ADNf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 08:35:26 -0500
Date: Wed, 4 Jan 2012 14:35:22 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Guillem Jover <guillem@hadrons.org>, Jonathan Nieder <jrnieder@gmail.com>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH] Use __unused0 instead of __unused for user visible
	struct member names
Message-ID: <20120104133522.GA7147@merkur.ravnborg.org>
References: <20120102024418.GA10483@gaara.hadrons.org> <20120102202243.GA31103@elie.hsd1.il.comcast.net> <20120103065659.GA32216@merkur.ravnborg.org> <20120104081414.GA29745@gaara.hadrons.org> <4F0431F4.4050303@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F0431F4.4050303@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 12:03:16PM +0100, Michal Marek wrote:
> On 4.1.2012 09:14, Guillem Jover wrote:
> > On Tue, 2012-01-03 at 07:56:59 +0100, Sam Ravnborg wrote:
> >> On Mon, Jan 02, 2012 at 02:22:43PM -0600, Jonathan Nieder wrote:
> >>> Guillem Jover wrote:
> >>>> On BSD systems __unused has traditionally been defined to mean the
> >>>> equivalent of gcc's __attribute__((__unused__)), some parts of the
> >>>> Linux tree use that convention too (e.g. perf). The problem comes when
> >>>> defining such macro while trying to build unmodified source code with
> >>>> BSD origins on systems with Linux headers.
> >>>>
> >>>> Rename the user visible struct members from __unused to __unused0 to
> >>>> not cause compilation failures due to that macro, which should not be
> >>>> a problem as those members are supposed to be private anyway.
> >>
> >> ^__ is reserved for libc internal stuff and there is no reason to
> >> name the unused/padding members "__unused".
> >> So one or a set of patches that rename them all to something more
> >> sensible would be fine.
> > 
> > On a quick glance, I've found other functionally similar struct
> > member names present on the tree:
> > 
> >   __unused __unusedN __reserved __reservedN __reserved_N __resN
> >   __pad __padN __flr_pad __ifi_pad __tcpm_padN __tcpct_padN
> > 
> > Do you mean you'd like to see patch(es) to rename all those? I'd not
> > mind providing them, although my immediate concern right now is just
> > regarding __unused.
> 
> __.* and _[A-Z].* are reserved for the implementation. Unfortunately,
> both the kernel userspace headers and the libc are part of the
> implementation, so there needs to be some common sense applied to avoid
> clashes. IMO renaming __unused to __unused0 on the basis that some
> headers define __unused to __attribute__((__unused__)) makes sense, but
> blindly renaming any occurence of double underscore helps little.

Agree on Michael on this.

	Sam
