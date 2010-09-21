Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937Ab0IUAQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 20:16:20 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:42901 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755113Ab0IUAQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 20:16:18 -0400
Date: Mon, 20 Sep 2010 20:15:55 -0400 (EDT)
From: caiqian@redhat.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <2140525299.1437291285028155909.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1457818084.1437271285028093752.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Subject: Re: [Bug #17341] kdump regression compared to v2.6.35
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.71]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It had been fixed by Tejun already.

commit 477a3c33d1efa0342a74bd02da2e049191993e2c
Author: Tejun Heo <tj@kernel.org>
Date:   Tue Aug 31 10:54:35 2010 +0200

    workqueue: fix GCWQ_DISASSOCIATED initialization
    
    init_workqueues() incorrectly marks workqueues for all possible CPUs
    associated.  Combined with mayday_mask initialization bug, this can
    make rescuers keep trying to bind to an offline gcwq indefinitely.
    Fix init_workqueues() such that only online CPUs have their gcwqs have
    GCWQ_DISASSOCIATED cleared.

----- "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a summary
> report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.35.  Please verify if it still should be listed and let the
> tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17341
> Subject		: kdump regression compared to v2.6.35
> Submitter	: CAI Qian <caiqian@redhat.com>
> Date		: 2010-08-27 12:35 (25 days old)
> Message-ID	:
> <2136707099.1405541282912500148.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
> References	: http://marc.info/?l=linux-kernel&m=128291252612135&w=2
> Handled-By	: Tejun Heo <tj@kernel.org>
