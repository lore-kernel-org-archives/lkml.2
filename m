Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152Ab1ERRAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 13:00:00 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47838 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932991Ab1ERQ75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 12:59:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=g8a4OhTjSqu+Zz3/r7VIhiGFvSgclh6FwxI9VqDR9uaNIUwg7YUw/BF9hwnRgqiOkV
         XK8jSUft2upjeFum3WFcPiYJd929lUDigGZGbVfQqCzGNbGK9sDefeeV5b9+SimEL63a
         Fzp6K9s2wE+75jl29o5eckIqOCteqUTrfXpI8=
MIME-Version: 1.0
In-Reply-To: <1305682604-21383-1-git-send-email-nab@linux-iscsi.org>
References: <1305682604-21383-1-git-send-email-nab@linux-iscsi.org>
From: Bart Van Assche <bvanassche@acm.org>
Date: Wed, 18 May 2011 18:59:36 +0200
X-Google-Sender-Auth: AEOICQ2-Wo3v51m4pDRD1lWIYbg
Message-ID: <BANLkTi=e+v7PLcSc8GNov-TOXFF7rurXew@mail.gmail.com>
Subject: Re: [RFC] ib_srpt: initial .40-rc1 drivers/infiniband/ulp/srpt merge
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-rmda <linux-rdma@vger.kernel.org>,
        Roland Dreier <roland@purestorage.com>, Vu Pham <vu@mellanox.com>,
        David Dillow <dillowda@ornl.gov>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 3:36 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> ib_srpt: Convert se_wwn endpoint reference to struct srpt_port->port_wwn
> http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commitdiff;h=4e544a210acb227df1bb4ca5086e65bdf4e648ea

Why has that change been implemented ? As far as I know InfiniBand
HCAs have either one or two ports. If there are two ports present, at
most one is active at any time. I don't see the point of making
individual ports visible and configurable in configfs on the target
instead of the HCA. If a user enables one port of a HCA but not the
other, that could result in some really strange and hard to diagnose
failures if the IB subnet manager decides to switch over to the other
port. Or am I missing something ?

Bart.
