Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934112Ab1EWUFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 16:05:09 -0400
Received: from leopard.mail.utk.edu ([160.36.0.85]:59954 "EHLO
	leopard.mail.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933755Ab1EWUFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 16:05:04 -0400
Date: Mon, 23 May 2011 16:04:31 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: linux-kernel@vger.kernel.org
cc: fbuihuu@gmail.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        acme@redhat.com
Subject: perf: regression with PERF_EVENT_IOC_REFRESH
Message-ID: <alpine.DEB.2.00.1105231555490.17453@cl320.eecs.utk.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

the changeset 2e939d1d   perf: Limit event refresh to sampling event

changes the behavior of
  ioctl( , PERF_EVENT_IOC_REFRESH, )

before the changeset, you could have a counter group where only one of the 
subevents was sampling.  PERF_EVENT_IOC_REFRESH would correctly enable 
sampling for only that subevent.

With the changeset applied, this fails with EINVALID.  Now you can only 
sample in a group leader.

Was this an intended change?  It breaks various of our PAPI regression 
tests that worked fine before the change was committed.

Vince
vweaver1@eecs.utk.edu
