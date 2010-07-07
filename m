Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973Ab0GGPW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 11:22:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45468 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839Ab0GGPWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 11:22:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=m4kDh7pH68FKSZGzPomVkQ+sKORMEJBUT9o5hY6nZnER1bsj1GFAj97LQ+l7wQfhye
         FnUOoTjfG/126Y9MYgxf56idnXWmICzF7WRh7DY1yVYB+1D3C2wK7RE/qcOJb2gAhHQM
         Dn8AXRFQA37vaqdTkb6H2azE3UrPvMGGGWiEs=
MIME-Version: 1.0
Date: Wed, 7 Jul 2010 17:22:54 +0200
Message-ID: <AANLkTim1wmWOJTbzrQgqQnB_VHJF8gWfr41DbjP9r8AJ@mail.gmail.com>
Subject: [PATCH 0/2] cfq-iosched: fixing RQ_NOIDLE handling.
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Cc: Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,
patch 8e55063 "cfq-iosched: fix corner cases in idling logic", is
suspected for some regressions on high end hardware.
The two patches from this series:
- [PATCH 1/2] cfq-iosched: fix tree-wide handling of rq_noidle
- [PATCH 2/2] cfq-iosched: RQ_NOIDLE enabled for SYNC_WORKLOAD
fix two issues that I have identified, related to how RQ_NOIDLE is
used by the upper layers.
First patch makes sure that a RQ_NOIDLE coming after a sequence of
possibly idling requests from the same queue on the no-idle tree will
clear the noidle_tree_requires_idle flag.
Second patch enables RQ_NOIDLE for queues in the idling tree,
restoring the behaviour pre-8e55063 patch.

An other option to consider is the partial revert of 8e55063, if the
corner cases we are trying to handle are not frequent enough to
justify this added complexity.

Thanks,
Corrado
