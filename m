Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab1BXQiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 11:38:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52117 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379Ab1BXQis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 11:38:48 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=mN7ZcCAKFbIA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=4XXrQqqHCXNTUQO3fVIA:9 a=olrQjJ-KNaLQMzUOaHIA:7 a=3ODR_NZB3-bt-v4t1-gmwlBpLFEA:4 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Thu, 24 Feb 2011 11:38:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Dan Carpenter <error27@gmail.com>, Greg KH <gregkh@suse.de>,
        Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        Eugene Teo <eugeneteo@kernel.sg>,
        Ralph Campbell <infinipath@qlogic.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
        Matthew Wilcox <matthew@wil.cx>, James Morris <jmorris@namei.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, Nick Piggin <npiggin@kernel.dk>,
        Arnd Bergmann <arnd@arndb.de>, Ian Campbell <ian.campbell@citrix.com>,
        Jarkko Sakkinen <ext-jarkko.2.sakkinen@nokia.com>,
        Tejun Heo <tj@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 2/2] debugfs: only allow root access to debugging
 interfaces
Message-ID: <20110224163844.GC888@home.goodmis.org>
References: <1298398198-18482-1-git-send-email-kees.cook@canonical.com>
 <1298398198-18482-2-git-send-email-kees.cook@canonical.com>
 <20110222181613.GU4000@outflux.net>
 <20110222191333.GA9991@suse.de>
 <20110222192248.GX4000@outflux.net>
 <20110222193314.GA11033@suse.de>
 <20110222202915.GC1966@bicker>
 <20110222205847.GA1867@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222205847.GA1867@khazad-dum.debian.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 05:58:47PM -0300, Henrique de Moraes Holschuh wrote:
> 
> I do wish this went in.  debugfs is a hazard, both security-wise and
> kernel-quality wise.  Anything that has to end up enabled in a distro
> kernel really does not belong in debugfs.  In fact, if you would object
> to a kernel taint if a feature is used, IMO it certainly don't belong on
> debugfs.
> 

As I am one of the culprits of adding tool interfaces into debugfs, I'll
give my opinion too.

When I first started using debugfs, it was because it was so much easier
to add files to than /sys, and I remember /proc is something we do not
want to add more functionality to.

It was also because we had no idea how ftrace was going to be used and
what the final ABI was going to be. I was hoping that we can experiment
with the interface and after some time we could move it out of debugfs
with a stable ABI. But this, for various reasons, never materialized.

Currently things are still in a large flux, and I do not know how this
will play out. Although the changes in /debugfs/tracing has toned down a
lot, there's also the work going in on how to merge perf and ftrace.
This may start changes as well, and perhaps deprecate interfaces. I
don't know.

Having debugfs as the main interface was not the goal of all this, but
we seemed to have just gotten stuck with it.

-- Steve

