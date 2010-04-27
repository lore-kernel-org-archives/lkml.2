Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab0D0Uno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 16:43:44 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:41396 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755588Ab0D0Unl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 16:43:41 -0400
Date: Tue, 27 Apr 2010 11:41:39 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Ashwin Ganti <ashwin.ganti@gmail.com>, David Howells <dhowells@redhat.com>,
       Greg KH <greg@kroah.com>, rsc@swtch.com, ericvh@gmail.com,
       linux-security-module@vger.kernel.org, Ron Minnich <rminnich@gmail.com>,
       jt.beard@gmail.com, Andrew Morgan <morgan@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, Eric Paris <eparis@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Kyle Moffett <kyle@moffetthome.net>, Steve Grubb <sgrubb@redhat.com>
Subject: [PATCH 0/3] p9auth fs: introduction
Message-ID: <20100427164139.GA7359@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is an updated version of the p9auth setuid capability
module, which hopefully addresses all previous feedback.  It
is now a separate filesystem instead of a device, as per Eric's
suggestion.

During the last round, Alan Cox made a great suggestion of sending
credentials over AF_UNIX sock allowing the recipient to 'become me.'
I think that's still an interesting idea, and intend to pursue it
as Eric pushes the patches to translate userids across user
namespaces.

The tradeoffs are worth discussing.  On the one
hand, p9auth requires a scary CAP_GRANT_ID capability, while a
SO_PASSAUTH would be more akin to an extension of CAP_SETUID.
Also, SO_PASSAUTH would be usable by any unprivileged app, while
one would hope there would be only one p9auth service for the whole
system.  On the other hand, the p9auth API appears to be pretty
well settled and understood, and only provides for a very simple
setting of all uids and all gids to one value, plus some auxiliary
groups, which is perfect for use by simple login servers.

p9auth and SO_PASSAUTH don't appear to be mutually exclusive.  I don't
know how painful it would be for plan-9 folks to make use of the
SO_PASSAUTH feature.  (It should definately be possible)  But in any
case here is the next iteration of p9auth fs for discussion and
consideration.

thanks,
-serge
