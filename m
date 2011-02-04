Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab1BDIkK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 03:40:10 -0500
Received: from brother.balabit.com ([195.70.62.219]:44541 "EHLO
	lists.balabit.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab1BDIkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 03:40:08 -0500
Subject: Re: CAP_SYSLOG, 2.6.38 and user space
From: Gergely Nagy <algernon@balabit.hu>
To: Marc Koschewski <marc@osknowledge.org>
Cc: david@lang.hm, "Serge E. Hallyn" <serge@hallyn.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>
In-Reply-To: <20110204080302.GA24941@marc.osknowledge.org>
References: <1296733177.14846.26.camel@moria>
	 <20110203153252.GA24153@mail.hallyn.com> <1296748401.14846.39.camel@moria>
	 <20110203165132.GA28172@mail.hallyn.com>
	 <alpine.DEB.2.00.1102031647150.30983@asgard.lang.hm>
	 <20110204080302.GA24941@marc.osknowledge.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Feb 2011 09:40:04 +0100
Message-ID: <1296808804.24742.6.camel@moria>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-04 at 09:03 +0100, Marc Koschewski wrote:
> Moreover, this change really is 'hell' on _many_ machines. We had discussed a
> thousands time to not break existing applications. So a) either make it optional in
> the kernel so that userspace still works with CAP_SYS_ADMIN _and_ CAP_SYSLOG
> while dropping a note that it should be fixed in userspace _and_ mark it as
> deprecated as of mid 2012 or b) revert it.

I think the sysctl method would be superior, because it places the
migration time in the hands of the distributions/admins, and gives
syslogds a way to adjust, and use either CAP_SYS_ADMIN or CAP_SYSLOG,
based on the presence of the sysctl setting (as opposed to using either
and just postponing the flag-day from 2.6.38 to mid 2012, where we'd
have the same issues we have now: unupgraded userspace breaking).

Having both CAP_SYS_ADMIN and CAP_SYSLOG at the same time, for the sole
purpose of reading kernel log messages would kind of defeat the purpose
of CAP_SYSLOG. Therefore, a solution that allows both at the same time
doesn't look all that good to me.

However, having it toggle-able does, and solves all my worries at least:
defaulting to CAP_SYS_ADMIN maintains backwards compatibility, upgraded
systems can switch to CAP_SYSLOG if and when the system is ready for
that. All's well!

-- 
|8]


