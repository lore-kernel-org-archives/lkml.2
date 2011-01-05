Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab1AEKX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 05:23:59 -0500
Received: from canuck.infradead.org ([134.117.69.58]:50025 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab1AEKX6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 05:23:58 -0500
Subject: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <20110105173823.B658.A69D9226@jp.fujitsu.com>
References: <20110105110837.B62A.A69D9226@jp.fujitsu.com>
	 <4D242D60.9060301@redhat.com> <20110105173823.B658.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 05 Jan 2011 11:24:14 +0100
Message-ID: <1294223054.2016.235.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-05 at 17:40 +0900, KOSAKI Motohiro wrote:
> > > If you are interesting GIL mess and issue, please feel free to ask more.
> > 
> > I suggest looking into an explicit round-robin scheme, where each thread 
> > adds itself to a queue and an unlock wakes up the first waiter.
> 
> I'm sure you haven't try your scheme. but I did. It's slow.

Of course it is, but then your locking scheme (GIL) is the problem, not
the locking constructs.
