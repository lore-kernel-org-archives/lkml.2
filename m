Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab1FXICU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 04:02:20 -0400
Received: from linux-sh.org ([111.68.239.195]:41780 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913Ab1FXICS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 04:02:18 -0400
Date: Fri, 24 Jun 2011 17:01:54 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sedat Dilek <sedat.dilek@googlemail.com>, linux-geode@lists.infradead.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH] gx1fb: Fix section mismatch warnings
Message-ID: <20110624080154.GA24184@linux-sh.org>
References: <20110616123240.ecd25243.randy.dunlap@oracle.com> <1294018289-3911-1-git-send-email-sedat.dilek@gmail.com> <20110106063906.GB15340@linux-sh.org> <20110616123119.6ca873fa.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110616123240.ecd25243.randy.dunlap@oracle.com> <20110616123119.6ca873fa.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 12:31:19PM -0700, Randy Dunlap wrote:
> Fix a chain of section mismatches in geode driver, beginning with:
> 
> WARNING: drivers/video/geode/gx1fb.o(.data+0x70): Section mismatch in reference from the variable gx1fb_driver to the function .init.text:gx1fb_probe()
> The variable gx1fb_driver references
> the function __init gx1fb_probe()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variable:
> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console
> 
> Making the changes that Paul pointed out resulted in a few more
> changes being needed, so they are all included here.

On Thu, Jun 16, 2011 at 12:32:40PM -0700, Randy Dunlap wrote:
> Fix section mismatch warning in sm501fb:
> 
> WARNING: drivers/video/sm501fb.o(.text+0x21d6): Section mismatch in reference from the function sm501fb_init_fb() to the variable .devinit.data:sm501_default_mode
> The function sm501fb_init_fb() references
> the variable __devinitdata sm501_default_mode.
> This is often because sm501fb_init_fb lacks a __devinitdata 
> annotation or the annotation of sm501_default_mode is wrong.

Both applied, thanks.
