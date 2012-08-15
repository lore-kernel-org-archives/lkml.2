Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab2HORTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 13:19:36 -0400
Received: from cs-smtp-1.Stanford.EDU ([171.64.64.25]:56224 "EHLO
	cs-smtp-1.Stanford.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab2HORTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 13:19:34 -0400
X-Greylist: delayed 1584 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Aug 2012 13:19:34 EDT
From: Ben Pfaff <blp@cs.stanford.edu>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: tglx@linutronix.de, mingo@redhat.com, davem@davemloft.net, hpa@zytor.com,
        thierry.reding@avionic-design.de, bfields@redhat.com,
        eric.dumazet@gmail.com, xemul@parallels.com, neilb@suse.de,
        netdev@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        paul.gortmaker@windriver.com, viro@zeniv.linux.org.uk,
        gorcunov@openvz.org, akpm@linux-foundation.org,
        tim.c.chen@linux.intel.com, devel@openvz.org, ebiederm@xmission.com
Subject: Re: [RFC PATCH 0/5] net: socket bind to file descriptor introduced
References: <20120815161141.7598.16682.stgit@localhost.localdomain>
Reply-To: blp@cs.stanford.edu
Date: Wed, 15 Aug 2012 09:52:53 -0700
In-Reply-To: <20120815161141.7598.16682.stgit@localhost.localdomain>
	(Stanislav Kinsbursky's message of "Wed, 15 Aug 2012 20:21:56 +0400")
Message-ID: <87wr102j2y.fsf@blp.benpfaff.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Spam-Score: -1.8
X-Scan-Signature: 58355bea2820b4cf9b9c8322cdf0b49d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanislav Kinsbursky <skinsbursky@parallels.com> writes:

> This system call is especially required for UNIX sockets, which has name
> lenght limitation.

The worst of the name length limitations can be worked around by
opening the directory where the socket is to go as a file
descriptor, then using /proc/self/fd/<fd>/<basename> as the name
of the socket.  This technique also works with "connect" and in
other contexts where a struct sockaddr is needed.  At first
glance, it looks like your patches only help with "bind".
