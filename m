Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab1BFBRt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 20:17:49 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:51280
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751747Ab1BFBRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 20:17:48 -0500
Date: Sun, 6 Feb 2011 01:18:31 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: david@lang.hm
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Gergely Nagy <algernon@balabit.hu>,
        James Morris <jmorris@namei.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: CAP_SYSLOG, 2.6.38 and user space
Message-ID: <20110206011831.GB15805@mail.hallyn.com>
References: <1296733177.14846.26.camel@moria>
 <20110203153252.GA24153@mail.hallyn.com>
 <20110204160513.GB17396@mail.hallyn.com>
 <1296837186.24742.15.camel@moria>
 <20110204171502.GA24226@mail.hallyn.com>
 <alpine.DEB.2.00.1102042301420.8162@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1102042301420.8162@asgard.lang.hm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting david@lang.hm (david@lang.hm):
> On Fri, 4 Feb 2011, Serge E. Hallyn wrote:
> 
> >Quoting Gergely Nagy (algernon@balabit.hu):
> >>On Fri, 2011-02-04 at 16:05 +0000, Serge E. Hallyn wrote:
> >>>Quoting Serge E. Hallyn (serge@hallyn.com):
> >>>>>From 2d7408541dd3a6e19a4265b028233789be6a40f4 Mon Sep 17 00:00:00 2001
> >>>>From: Serge Hallyn <serge@peq.(none)>
> >>>>
> >>>>At 2.6.39 or 2.6.40, let's add a sysctl which defaults to 0.  When
> >>>>0, refuse if cap_sys_admin, if 1, then allow.  This will allow
> >>>>users to acknowledge (permanently, if they must, using /etc/sysctl.conf)
> >>>>that they've seen the syslog message about cap_sys_admin being
> >>>>deprecated for syslog.
> >>>>
> >>>>Signed-off-by: Serge Hallyn <serge@hallyn.com>
> >-			goto warn; /* switch to return -EPERM after 2.6.39 */
> >+		     !capable(CAP_SYSLOG)) {
> >+			/* remove after 2.6.39 */
> >+			if (capable(CAP_SYS_ADMIN))
> >+				WARN_ONCE(1, "Attempt to access syslog with CAP_SYS_ADMIN "
> >+				  "but no CAP_SYSLOG (deprecated).\n");
> >+			else
> >+				return -EPERM;
> >+		}
> >	}
> 
> why does this need to be removed after 2.6.39?
> 
> whenever you go to remove it you will break userspace, what's the
> benifit of breaking userspace?
> 
> I can understand that it's better to have a syslog daemon with
> CAP_SYSLOG instead of CAP_SYS_ADMIN, but does "it would be better to
> have userspace changed" really translate into "it's so important to
> have userspace changed that we need to break any userspace that
> hasn't changed"?
> 
> I really don't think so.

I think I agree with you.  If someone wants to grant one of the other
CAP_SYS_ADMIN powers without CAP_SYSLOG, then they can break that into
yet another, i.e. CAP_IPCSET.  Makes sense.

thanks,
-serge
