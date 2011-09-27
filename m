Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab1I0RH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 13:07:58 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57847 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913Ab1I0RHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 13:07:55 -0400
Date: Tue, 27 Sep 2011 19:07:55 +0200
From: Borislav Petkov <bp@alien8.de>
To: Simon Kirby <sim@hostway.ca>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [3.1-rc6] kmalloc(64) leak from IDE
Message-ID: <20110927170755.GA31384@gere.osrc.amd.com>
References: <20110922072643.GA27232@hostway.ca>
 <20110922084811.GC17640@liondog.tnic>
 <20110922202337.GB32661@hostway.ca>
 <20110923072118.GA13293@liondog.tnic>
 <20110923173808.GB26481@hostway.ca>
 <20110925085818.GA10947@liondog.tnic>
 <20110926080549.GA14697@hostway.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110926080549.GA14697@hostway.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(forgot to Cc linux-ide earlier, sorry)

On Mon, Sep 26, 2011 at 01:05:50AM -0700, Simon Kirby wrote:
> Ok, good. It's still running without any problem, and no new leaks
> reported.

Ok.

[..]

> > backporting it to -stable is a good point. I'll add the proper tagging
> > to the patch.
> 
> Do you know in which version the issue started, then?
> 
> If not, all I have to start with is that it was fine on 2.6.36, and I can
> bisect it, if that would help.

This is exactly the question: AFAICT, it could be that changes in the
block layer at some point have caused the ide bust and since almost no
one tests ide...

The patch adding the dynamic ide_cmd struct allocation is
395d8ef5bebe547a80737692f9789d2e36da16f2 from 2008 and I don't think it
caused the issue then but I could also be remembering it wrong.

So I wouldn't bisect it but test stable trees after 2.6.36 to see
whether they have the issue, and if so, only then the patch should be
backported.

And this is not that easy now with k.org down but looking at

http://web.archive.org/web/20110725015737/http://kernel.org/

the only stable trees which need to be tested are 2.6.39 and 3.0.

How does that sound?

-- 
Regards/Gruss,
Boris.
