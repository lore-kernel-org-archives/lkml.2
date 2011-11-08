Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab1KHAZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 19:25:22 -0500
Received: from tango.0pointer.de ([85.214.72.216]:37737 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab1KHAZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 19:25:21 -0500
Date: Tue, 8 Nov 2011 01:25:20 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Davidlohr Bueso <dave@gnu.org>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [RFC PATCH] tmpfs: support user quotas
Message-ID: <20111108002520.GB25769@tango.0pointer.de>
References: <1320614101.3226.5.camel@offbook>
 <20111107112952.GB25130@tango.0pointer.de>
 <1320675607.2330.0.camel@offworld>
 <20111107135823.3a7cdc53@lxorguk.ukuu.org.uk>
 <CAPXgP117Wkgvf1kDukjWt9yOye8xArpyX29xx36NT++s8TS5Rw@mail.gmail.com>
 <20111107225314.0e3976a6@lxorguk.ukuu.org.uk>
 <20111107230712.GA25769@tango.0pointer.de>
 <20111107234337.1dc9d612@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111107234337.1dc9d612@lxorguk.ukuu.org.uk>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07.11.11 23:43, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:

> 
> On Tue, 8 Nov 2011 00:07:12 +0100
> Lennart Poettering <mzxreary@0pointer.de> wrote:
> 
> > On Mon, 07.11.11 22:53, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > 
> > > Per user would be quota, per process would be rlimit. Quite simple
> > > really, nice standard interfaces we've had for years. Various systems
> > 
> > Uh, have you ever really looked at resource limits? Some of them are
> > per-user, not per-process, i.e. RLIMIT_NPROC. And this would just be
> > another one.
> 
> NPROC is a bit of an oddity.

And half of the other resource limits are "oddities" too?
For  example RLIMIT_SIGPENDING is per-user and so is RLIMIT_MSGQUEUE,
and others too.

> And the standards have no idea how a resource limit hit for an fs would
> be reported, nor how an app installer would check for it. Quota on the
> other hand is defined behaviour.

EDQUOT is POSIX, but afaik there is no POSIX standardized API for quota,
is there? i.e. the reporting of the user hitting quota is defined, but
how to set the quota is left open. Which is nice, since it gives us the
flexibility to use resource limits here, since they so nicely apply to
the problem.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
