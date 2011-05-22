Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab1EVTOx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 15:14:53 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42185 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab1EVTOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 15:14:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=BoIM6v1rU/HbfDkrUJbT3UQq04r9NI172dJi5SotqkT40y4RKHUidrw6vRJFXOPYSW
         guZ5AkGNohHJbiwslMMfjJsp5AOMgpw5KVXSXVQJWLTzl7oczQhKhwz0AP4DnZj6yEEw
         TC7ShQ1VXhjd8xR4TNqRSaVxNXQOgOt5ej3D4=
MIME-Version: 1.0
In-Reply-To: <20110519184113.GE12525@obsidianresearch.com>
References: <1305682604-21383-1-git-send-email-nab@linux-iscsi.org>
 <BANLkTi=e+v7PLcSc8GNov-TOXFF7rurXew@mail.gmail.com> <20110518170556.GB2595@obsidianresearch.com>
 <BANLkTikOCeNcDvoCM=BOSxQaSECFhJ05Gg@mail.gmail.com> <20110519174420.GD12525@obsidianresearch.com>
 <BANLkTikOsqazAE-mHFrM+=4GTs+249Ae5Q@mail.gmail.com> <20110519184113.GE12525@obsidianresearch.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Sun, 22 May 2011 21:14:23 +0200
X-Google-Sender-Auth: yyfFpyq4IryDRwlqDood-ruWLvo
Message-ID: <BANLkTimK+da8N1uTyCmYqggHzd-+yZSTig@mail.gmail.com>
Subject: Re: [RFC] ib_srpt: initial .40-rc1 drivers/infiniband/ulp/srpt merge
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-rmda <linux-rdma@vger.kernel.org>,
        Roland Dreier <roland@purestorage.com>, Vu Pham <vu@mellanox.com>,
        David Dillow <dillowda@ornl.gov>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 8:41 PM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> This is why in the IB verbs architecture nearly everything is tied to
> a *device*, not a port.

LIO has a feature called "access control lists" that allows to define
which initiators are allowed to log in to a target. For a single-rail
HCA it makes most sense to configure that information per HCA. For a
dual-rail HCA the most flexible approach is to allow the user to
configure ACLs per HCA port. That made me wonder whether it is
possible to find out from software whether a dual-port HCA is
single-rail or dual-rail. A quick glance at struct ib_device_attr and
struct ib_port_attr in <rdma/ib_verbs.h> didn't yield any field usable
for this purpose. Did I overlook something ?

Bart.
