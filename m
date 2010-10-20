Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab0JTKVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 06:21:37 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56707 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab0JTKVf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 06:21:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=p1Xw2sig1h3YKrevAelE+mhnzVH1EUA0JNe4pENRHh+PsgFZq2FxrZISjMT2DivQu/
         b9sfMoGPLy3MFZW6ePlQYmbvAFvohbYP6KunpqVJnZtlPTHt90f7Bhhz8bOfHkIkGkNV
         q/QuIX6d+dNrHfTAiIu95X+ZTbEGZ4WaYOAvE=
MIME-Version: 1.0
In-Reply-To: <4CBEAA6E.2060000@kernel.org>
References: <4CBDB834.2050905@kernel.org> <AANLkTi=gYununGYK-QuonZASyk49Rj2-+zG+f22fBF=g@mail.gmail.com>
 <4CBEAA6E.2060000@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
Date: Wed, 20 Oct 2010 12:21:13 +0200
X-Google-Sender-Auth: Iz8KcvHdruGNXPcJM9gvz-KcPE8
Message-ID: <AANLkTikLUhN691OzPiqO_hqeAkE7VfWA6Gkwqt98MHN9@mail.gmail.com>
Subject: Re: [PATCH v2.6.36-rc7] infiniband: update workqueue usage
To: Tejun Heo <tj@kernel.org>
Cc: Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 10:38 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On 10/19/2010 08:40 PM, Bart Van Assche wrote:
>> On Tue, Oct 19, 2010 at 5:24 PM, Tejun Heo <tj@kernel.org> wrote:
>>> [ ... ]
>>> This is to prepare for deprecation of flush_scheduled_work().
>>> [ ... ]
>>> Index: work/include/rdma/ib_verbs.h
>>> [ ... ]
>>> +extern struct workqueue_struct *ib_wq;
>>> [ ... ]
>>
>> This patch adds a declaration of a global variable to a public header
>> file. That might be unavoidable, but it doesn't make me happy.
>
> Hmm... that's one very interesting reason to be unhappy.  Can you
> please elaborate why addition of a global variable doesn't make you
> happy?

In the past every time I saw a global variable being added in a
software project that meant that some software concept was not being
abstracted properly. Which does not necessarily mean that that is the
case with this patch.

With the posted patch, just like with the current implementation, e.g.
the flush_workqueue() call in the ipath driver will make that driver
wait until work scheduled by the core/sa_query.c code finished and
vice versa. Is that necessary ? If not, using multiple work queues for
IB instead of one would allow to get rid of that global ib_wq
declaration.

Bart.
