Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206Ab2C1LGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 07:06:54 -0400
Received: from shelob.oktetlabs.ru ([195.131.132.186]:34746 "EHLO
	shelob.oktetlabs.ru" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752206Ab2C1LGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 07:06:53 -0400
X-Greylist: delayed 516 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Mar 2012 07:06:53 EDT
X-DKIM: Sendmail DKIM Filter v2.8.2 shelob.oktetlabs.ru 2B3727F4D9
Authentication-Results: shelob.oktetlabs.ru/2B3727F4D9; dkim=none
	(no signature) header.i=unknown; dkim-adsp=none
Date: Wed, 28 Mar 2012 14:57:59 +0400
From: "Alexandra N. Kossovsky" <Alexandra.Kossovsky@oktetlabs.ru>
To: Jason Baron <jbaron@redhat.com>
Cc: "Yurij M. Plotnikov" <Yurij.Plotnikov@oktetlabs.ru>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Dead circle in epoll file descriptor causes soft lockup on
 kernel 3.2.12
Message-ID: <20120328105757.GS29100@oktetlabs.ru>
References: <4F717174.9090008@oktetlabs.ru>
 <20120327140510.GA2419@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120327140510.GA2419@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 10:05:10AM -0400, Jason Baron wrote:
> On Tue, Mar 27, 2012 at 11:51:16AM +0400, Yurij M. Plotnikov wrote:
> > Adding epoll file descriptors in each other in circle causes soft
> > lockup on kernel 3.2.12 (I'm using Debian kernel
> > 3.2.0-0.bpo.1-amd64). The following steps describe the problem:
> > 
> > 1. epoll_create(1) -> 3
> > 2. epoll_create(1) -> 4
> > 3. socket(SOCK_STREAM) -> 5
> > 4. bind(5, 0.0.0.0:0) -> 0
> > 5. listen(5, 1) -> 0
> > 6. epoll_ctl(3, ADD, 5, events = 0) -> 0
> > 7. epoll_ctl(3, ADD, 4, events = EPOLLIN) -> 0
> > 8. epoll_ctl(4, ADD, 3, events = EPOLLIN) -> -1(ELOOP)
> > 9. close(3) -> 0
> > 10. close(4) -> 0
> > 11. close(5) -> 0
> > 
> > After repetaing this sequence 2-3 times soft lockup appers. In
> > attachment c program to reproduce this problem.
> > 
> 
> Good catch. The patch below should fix this - please verify. Thanks.

Verified.  You patch solves our problem.  Thank you very much for fast
response.

-- 
Alexandra N. Kossovsky
OKTET Labs (http://www.oktetlabs.ru/)
