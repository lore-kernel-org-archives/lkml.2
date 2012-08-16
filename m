Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247Ab2HPBgH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 21:36:07 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:65388 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360Ab2HPBgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 21:36:01 -0400
MIME-Version: 1.0
In-Reply-To: <1344946071.3117.26.camel@dabdike.int.hansenpartnership.com>
References: <CAOAMb1Dd5_KWQme+EzXdpnABk=A50+vXuLMoS+r5et6=o0605g@mail.gmail.com>
	<CAOAMb1Dp=E6fjMhdh6ze6Hq48qUixTpsqHZf3z742AUAqhU5Ug@mail.gmail.com>
	<1344946071.3117.26.camel@dabdike.int.hansenpartnership.com>
Date: Thu, 16 Aug 2012 10:35:59 +0900
Message-ID: <CAOAMb1COJbAF=ys7ZcpTuJNP6QzbQzuqz7gS4qPqSc1rfbnHTw@mail.gmail.com>
Subject: Re: [PATCH RESEND] remove the queue unlock in scsi_requset_fn
From: Chanho Min <chanho0207@gmail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Bart Van Assche <bvanassche@acm.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> functions will occur in line.  I also don't see why the sdev reference
> couldn't drop to zero here.
scsi_request_fn is called under the lock of request_queue->queue_lock.
If we drop the sdev reference to zero here,
scsi_device_dev_release_usercontext is
invoked and make request_queue to NULL. When caller of scsi_request_fn try to
unlock request_queue->queue_lock, the oops is occurred.

Thanks, Chanho
