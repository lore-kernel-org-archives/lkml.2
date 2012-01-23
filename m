Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab2AWUkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 15:40:20 -0500
Received: from tango.0pointer.de ([85.214.72.216]:52278 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab2AWUkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 15:40:19 -0500
Date: Mon, 23 Jan 2012 21:40:17 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, axboe@kernel.dk, ctalbott@google.com,
        rni@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/17] blkcg: shoot down blkio_groups on elevator switch
Message-ID: <20120123204016.GA21822@tango.0pointer.de>
References: <1327202725-3383-9-git-send-email-tj@kernel.org>
 <20120123152055.GD25986@redhat.com>
 <20120123153913.GB12652@google.com>
 <20120123155216.GF25986@redhat.com>
 <20120123155745.GD12652@google.com>
 <20120123161042.GG25986@redhat.com>
 <20120123161619.GE12652@google.com>
 <20120123162553.GI25986@redhat.com>
 <20120123171049.GH12652@google.com>
 <20120123182745.GK25986@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120123182745.GK25986@redhat.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23.01.12 13:27, Vivek Goyal (vgoyal@redhat.com) wrote:

> > Why can't systemd order elevator switch before other actions?
> 
> Because systemd does not know. For systemd it is just launching services
> and what services are doing is not known to systemd.
> 
> I think systemd does have some facilities so that services can express
> dependency on other services and dependent service blocks on completion
> of service it is depenent on. So may be in this case any service dealing
> with cgroups shall have to be dependent on this service which tunes
> the system and changes elevator.
> 
> CCing lennart for more info on systemd.

Yes, the dependency logic is quite elaborate in systemd. If a service
really needs to it can plug itself into the early-boot phase, instead of
normal boot. It's where we usually load drivers via udev and apply
sysctl and these things, hence before any of the "real" services. So far
only udev itself (and plymouth in some way) are of this special kind
that run this early, but other services may move themselves this
early as well, if they want to.

Note that sticking code in the early boot phase means you need to know
what you do, i.e. not rely on device nodes being there, drivers probed,
access modes fixed, temporary files set up and so on, after all it's
where we do all those things in the first place. You can order yourself
individually after those tasks however, if needed.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
