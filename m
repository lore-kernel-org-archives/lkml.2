Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499Ab2ACHGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 02:06:54 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:45259 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab2ACHGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 02:06:52 -0500
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jan 2012 02:06:51 EST
Date: Tue, 3 Jan 2012 07:56:59 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Guillem Jover <guillem@hadrons.org>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-api@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH] Use __unused0 instead of __unused for user visible
	struct member names
Message-ID: <20120103065659.GA32216@merkur.ravnborg.org>
References: <20120102024418.GA10483@gaara.hadrons.org> <20120102202243.GA31103@elie.hsd1.il.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120102202243.GA31103@elie.hsd1.il.comcast.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 02, 2012 at 02:22:43PM -0600, Jonathan Nieder wrote:
> (+cc: some possible relevant people)
> Hi,
> 
> Guillem Jover wrote:
> 
> > On BSD systems __unused has traditionally been defined to mean the
> > equivalent of gcc's __attribute__((__unused__)), some parts of the
> > Linux tree use that convention too (e.g. perf). The problem comes when
> > defining such macro while trying to build unmodified source code with
> > BSD origins on systems with Linux headers.
> >
> > Rename the user visible struct members from __unused to __unused0 to
> > not cause compilation failures due to that macro, which should not be
> > a problem as those members are supposed to be private anyway.

^__ is reserved for libc internal stuff and there is no reason to
name the unused/padding members "__unused".
So one or a set of patches that rename them all to something more
sensible would be fine.

	Sam
