Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab1G1Uj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 16:39:59 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:49716 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab1G1Uj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 16:39:57 -0400
Subject: Re: [PATCH 10/13] iscsi-target: Add iSCSI Error Recovery Hierarchy
	support
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Fubo Chen <fubo.chen@gmail.com>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>
In-Reply-To: <CAJAFBLCgOeqnrPae+GQyjnoOUkF632Nrn4Bh-3d4K3KXCezbqw@mail.gmail.com>
References: <1311410747-29947-1-git-send-email-nab@linux-iscsi.org>
	 <1311410747-29947-11-git-send-email-nab@linux-iscsi.org>
	 <CAJAFBLCgOeqnrPae+GQyjnoOUkF632Nrn4Bh-3d4K3KXCezbqw@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 28 Jul 2011 13:30:36 -0700
Message-Id: <1311885036.6931.218.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-28 at 13:42 +0200, Fubo Chen wrote:
> On Sat, Jul 23, 2011 at 10:45 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > This patch adds support for RFC-3720 compatiable ErrorRecoveryLevel
> > support as defined in Section 6.1.5.  Error Recovery Hierarchy.
> >
> > This includes support for iSCSI session reinstatement, iSCSI within
> > command and within connection recovery, and explict/implict connection
> > recovery (CSM-E and CSM-I) from state machines in Section 7 of RFC-3720.
> >
> > These functions are called from iscsi_target.c to handle processing
> > based on the negotiated session-wide ErrorRecoveryLevel parameter.
> >
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> 
> This is interesting. Is ERL2 similar to md ? If so, when should I use
> md and when ERL2 ?
> 

I think you mean dm-multipath and not md RAID here..

dm-multipath with TCM's ALUA multipath code provides a fabric
independent (iSCSI, FCoE, FC, SRP, etc) method of path failover across
multiple target ports for LUNs with a matching IEEE Extended Registered
WWN.

ERL=2 is a fabric dependent method of performing iSCSI connection
recovery on one or more failed TCP connections, where outstanding I/O
can be implictly retried and/or explictly migrated (TASK_REASSIGN) to an
active connection without having to restart the iSCSI I_T Nexus, or
notify the client side multipath layer that a I_T nexus has been lost.

Their use is not mutually exclusive, and can be used together to
complement one another.

--nab

