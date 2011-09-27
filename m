Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab1I0R5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 13:57:39 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54028 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab1I0R5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 13:57:37 -0400
MIME-Version: 1.0
In-Reply-To: <20110830020100.GK3162@dastard>
References: <CAO+b5-pAY9Qn4OXKnxAHaBSrJi_6nTPOGZ+QgVg9iRdTCmequA@mail.gmail.com>
 <alpine.LFD.2.00.1108291342110.3904@dhcp-27-109.brq.redhat.com>
 <CAO+b5-qBCBuROmqSPHofQ4A4xxpaUVJL8AzGDHfy7k8QcWYzWw@mail.gmail.com> <20110830020100.GK3162@dastard>
From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 27 Sep 2011 19:57:14 +0200
X-Google-Sender-Auth: M969f94Wrx0zlKx5CZzoWp2X_30
Message-ID: <CAO+b5-rL=ucZ-2bA9Qj-RfWbJzGasDBQMLF_4XX2xzC28YECBg@mail.gmail.com>
Subject: Re: blkdev_issue_discard() hangs forever if the underlying storage
 device is removed
To: Dave Chinner <david@fromorbit.com>
Cc: Lukas Czerner <lczerner@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 4:01 AM, Dave Chinner <david@fromorbit.com> wrote:
> The underlying block device driver is supposed to handle timing out
> of lost IOs and causing them to be completed with an error.
> blkdev_issue_discard() is simply waiting for that error to be
> delivered.

Hi Dave,

You're probably right that it's not a block layer issue. This patch
fixed it for me: http://marc.info/?l=linux-scsi&m=131680195721932&w=2

Bart.
