Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab1ESKk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 06:40:26 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52377 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab1ESKkX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 06:40:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=vp1ACbTtGGO/h3lHtFvEn8VPiddS+MXaQrGB33PFB6WK+U0yFXaMJH1tddq5cGU4qG
         dAv0VWjKDZk+a8undtm7Pf0T4Fz/0EPTpITHYhOLjd2sLIxf80aRgr7ExBAvjvvlZbuY
         1BBVhW+I6Pq/GDj2AQolACQaRRrD1jdF5M2zc=
MIME-Version: 1.0
In-Reply-To: <1305778694.2856.533.camel@haakon2.linux-iscsi.org>
References: <1305682604-21383-1-git-send-email-nab@linux-iscsi.org>
 <BANLkTi=e+v7PLcSc8GNov-TOXFF7rurXew@mail.gmail.com> <20110518170556.GB2595@obsidianresearch.com>
 <BANLkTimQXU0u5gtRzXsnsB=sCF-bvpY+Ag@mail.gmail.com> <BANLkTi==bZ0h3o5FNrg8PSJFp6F-zh5hTA@mail.gmail.com>
 <1305778694.2856.533.camel@haakon2.linux-iscsi.org>
From: Bart Van Assche <bvanassche@acm.org>
Date: Thu, 19 May 2011 12:40:02 +0200
X-Google-Sender-Auth: HXoqfhXwr6grbrBP0UYNIKAZuAk
Message-ID: <BANLkTi=Xb-ypQNa3=MmwiLeE4Q9FWHnZXg@mail.gmail.com>
Subject: Re: [RFC] ib_srpt: initial .40-rc1 drivers/infiniband/ulp/srpt merge
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Roland Dreier <roland@purestorage.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-rmda <linux-rdma@vger.kernel.org>, Vu Pham <vu@mellanox.com>,
        David Dillow <dillowda@ornl.gov>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 6:18 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> The srpt_port->port_wwn patch in question does
> current ensure that sport->enabled has been set via an configfs
> attribute at:
>
>   /sys/kernel/config/target/srpt/$IB_PORT_GUID/tpgt_1/enable
>
> and will reject all SRP login attempts to an individual struct srpt_port
> until the attribute has been explictly triggered.
>
> This allows ib_srpt to follow what is expected by rtsadmin-v2 +
> lio-utils, and used to generate /etc/target/srpt_start.sh used to save
> persistent fabric configuration.  Currently other fabrics like
> iscsi-target and tcm_qla2xxx expect to be able to reject fabric login
> requests before the full set of WWPN endpoints, LUNs, NodeACLs +
> MappedLUNs have been recreated during an typical init.d/target start
> operation.
>
> I think it makes sense to do the same for the SRPT control plane on an
> individual HCA port GUID basis as long as there are no underlying fabric
> issues, and that Roland is happy.  In terms of supporting more than one
> type of /sys/kernel/config/target/srpt/$WWPN/$TPGT/ layout, I would
> really like to avoid this for mainline code unless there is a really
> good reason..

I'm still wondering whether it was a good idea to switch from ib<n>
style names to port GIDs. Not only will that make it hard for users to
match the ib<n> names already assigned to InfiniBand HCAs with target
port names but this also deviates from the naming scheme used for any
other Linux device. Ethernet devices e.g. appear as eth<n> in /dev
instead of a MAC address like 00:1a:64:10:18:6f.

Bart.
