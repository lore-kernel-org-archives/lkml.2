Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab1ACUuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 15:50:22 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:60577 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab1ACUuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 15:50:21 -0500
Date: Mon, 3 Jan 2011 21:50:19 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andres Salomon <dilinger@queued.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Sedat Dilek <sedat.dilek@googlemail.com>, sameo@linux.intel.com,
        tj@kernel.org, joe@perches.com, linux-kernel@vger.kernel.org,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH] misc/cs5535: Fix section mismatch derived from
	cs5535_mfgpt_drv variable
Message-ID: <20110103205019.GA10739@merkur.ravnborg.org>
References: <1294023088-31687-1-git-send-email-sedat.dilek@gmail.com> <20110103114310.8b06e73e.akpm@linux-foundation.org> <20110103195131.GA9568@merkur.ravnborg.org> <20110103123431.02a15ba4@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110103123431.02a15ba4@queued.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 03, 2011 at 12:34:31PM -0800, Andres Salomon wrote:
> On Mon, 3 Jan 2011 20:51:31 +0100
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > On Mon, Jan 03, 2011 at 11:43:10AM -0800, Andrew Morton wrote:
> > > On Mon,  3 Jan 2011 03:51:28 +0100
> > > Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> > > 
> > > > >From my build.log:
> > > > 
> > > > WARNING: drivers/misc/cs5535-mfgpt.o(.data+0x0): Section mismatch
> > > > in reference from the variable cs5535_mfgpt_drv to the
> > > > function .devinit.text:cs5535_mfgpt_probe() The variable
> > > > cs5535_mfgpt_drv references the function __devinit
> > > > cs5535_mfgpt_probe() If the reference is valid then annotate the
> > > > variable with __init* or __refdata (see linux/init.h) or name the
> > > > variable: *driver, *_template, *_timer, *_sht, *_ops, *_probe,
> > > > *_probe_one, *_console,
> > > 
> > > Confused.  cs5535_mfgpt_probe() _does_ have a name of the form
> > > "*_probe", so why did it warn?
> > 
> > The varibale need to follow the naming scheme.
> > In this case the function was named *_probe - which has no
> > significance in the section mismatch checks.
> > 
> > > > variable with __init* or __refdata (see linux/init.h) or name the
> > > > variable:
> >     ^^^^^^^^
> > ^^^^^^^^^ 
> > 
> > 	Sam
> 
> I see.  So it should really be renamed cs5535_mfgpt_driver, or _drv
> added to the whitelist.  Or the whitelist dropped, and all drivers
> changed to explicitly mark the structs with __devinitdata.

It is preferred that the variables are annotated __refdata.
> 
> It's kind of bizarre that we have variable names signifying whether or
> not warnings get issued..

It really helped to remove a lot of nosie when we introduced this check.

	Sam
