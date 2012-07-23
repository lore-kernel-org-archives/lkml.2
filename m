Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab2GWNaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 09:30:15 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33108 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab2GWNaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 09:30:12 -0400
Date: Mon, 23 Jul 2012 14:30:10 +0100
From: Matthew Garrett <mjg@redhat.com>
To: platform-driver-x86@vger.kernel.org,
        Arun Raghavan <arun.raghavan@collabora.co.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] apple-gmux: Fix kconfig dependencies
Message-ID: <20120723133010.GE21495@srcf.ucam.org>
References: <1341240929-3400-1-git-send-email-seth.forshee@canonical.com>
 <20120716235034.GB11710@ubuntu-530U>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120716235034.GB11710@ubuntu-530U>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 04:50:34PM -0700, Seth Forshee wrote:
> On Mon, Jul 02, 2012 at 09:55:29AM -0500, Seth Forshee wrote:
> > Fix the dependencies of apple-gmux to prevent it from being built-in
> > when one or more of its dependencies is built as a module. Otherwise it
> > can fail to build due to missing symbols.
> 
> Matthew: Are you okay with this, or is there some better way to do it?

I think this is probably about as good as it gets.

> I'm looking at Andreas's code for switcharoo support, and something I
> want to do along with it is make apple-gmux not dependent on backlight
> support (i.e. you can still build switcharoo support if
> BACKLIGHT_CLASS_DEVICE is disabled). I'm assuming this patch as a
> prerequisite. But things do get really monstrously ugly, so if there's a
> cleaner way to enforce this that I haven't found I'd love to hear about
> it.

Why do you want to support that case? One of the problems we have with 
the kernel at present is that it's trivial to come up with non-sensical 
configurations. I can't think of a single case where you'd want the gmux 
support without also having the backlight support code.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
