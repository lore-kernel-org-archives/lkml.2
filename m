Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab1IVUF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 16:05:28 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:42361 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab1IVUF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 16:05:26 -0400
Date: Thu, 22 Sep 2011 22:05:24 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Richard Cochran <richardcochran@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>, lkml <linux-kernel@vger.kernel.org>,
        gthelen@google.com, tartler@cs.fau.de,
        Dmitry Fink <Dmitry.Fink@palm.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Eric B Munson <ebmunson@us.ibm.com>,
        Bruce Ashfield <Bruce.Ashfield@windriver.com>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kconfig: Add merge_config.sh script
Message-ID: <20110922200524.GA1012@merkur.ravnborg.org>
References: <1316582561-23066-1-git-send-email-john.stultz@linaro.org> <20110921064423.GA4103@netboy.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110921064423.GA4103@netboy.at.omicron.at>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 08:44:23AM +0200, Richard Cochran wrote:
> On Tue, Sep 20, 2011 at 10:22:41PM -0700, John Stultz wrote:
> > After noticing almost every distro has their own method of managing
> > config fragments, I went looking at some best practices, and wanted
> > to try to consolidate some of the different approaches so this fairly
> > simple infrastructure can be shared (and new distros/build systems
> > don't have to implement yet another config fragment merge script).
> 
> John,
> 
> I have been wanting to make or find a way to start with an allnoconfig
> and enable a short list of config options (and the options that are
> needed to allow them). I don't want the other defaults at all.

>From Documentation/kbuild/kconfig.txt:

===================================================================
This 'KCONFIG_ALLCONFIG' file is a config file which contains
(usually a subset of all) preset config symbols.  These variable
settings are still subject to normal dependency checks.

Examples:
        KCONFIG_ALLCONFIG=custom-notebook.config make allnoconfig
or
        KCONFIG_ALLCONFIG=mini.config make allnoconfig
or
        make KCONFIG_ALLCONFIG=mini.config allnoconfig

These examples will disable most options (allnoconfig) but enable or
disable the options that are explicitly listed in the specified
mini-config files.
===================================================================

I think this should do what you want.

	Sam
