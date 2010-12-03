Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab0LCQUQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 11:20:16 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:39587 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab0LCQUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 11:20:14 -0500
Date: Fri, 3 Dec 2010 21:50:03 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Rik van Riel <riel@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 2/3] sched: add yield_to function
Message-ID: <20101203162003.GA13515@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20101202144129.4357fe00@annuminas.surriel.com>
 <20101202144423.3ad1908d@annuminas.surriel.com>
 <1291355656.7633.124.camel@marge.simson.net>
 <20101203134618.GG27994@linux.vnet.ibm.com>
 <1291387511.7992.15.camel@marge.simson.net>
 <4CF90341.4020101@redhat.com>
 <1291388987.7992.27.camel@marge.simson.net>
 <4CF90E3D.7090103@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF90E3D.7090103@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 03, 2010 at 10:35:25AM -0500, Rik van Riel wrote:
> Do you have suggestions on what I should do to make
> this yield_to functionality work?

Keeping in mind the complications of yield_to, I had suggested we do something
suggested below:

http://marc.info/?l=kvm&m=129122645006996&w=2

Essentially yield to other tasks on your own runqueue and when you get to run
again, try reclaiming what you gave up earlier (with a cap on how much one can
feedback this relinquished time). It can be accomplished via a special form of 
yield(), available only to in-kernel users, kvm in this case.

- vatsa 
