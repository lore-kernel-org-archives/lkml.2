Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788Ab2KBRuS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:50:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932452Ab2KBRuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:50:13 -0400
Message-ID: <509407B7.3030904@redhat.com>
Date: Fri, 02 Nov 2012 18:49:43 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Ric Wheeler <rwheeler@redhat.com>, Petr Matousek <pmatouse@redhat.com>,
        Kay Sievers <kay@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: setting up CDB filters in udev (was Re: [PATCH v2 0/3] block:
 add queue-private command filter, editable via sysfs)
References: <20121025180045.GL11442@htj.dyndns.org> <1657557410.1945557.1351190120407.JavaMail.root@redhat.com> <20121031212241.GZ2945@htj.dyndns.org> <5093DD5E.6030808@redhat.com> <20121102165123.GB3823@mtj.dyndns.org>
In-Reply-To: <20121102165123.GB3823@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 02/11/2012 17:51, Tejun Heo ha scritto:
>>> > > What disturbs me is that it's a completely new interface to userland
>>> > > and at the same a very limited one at that.  So, yeah, it's
>>> > > bothersome.  I personally would prefer SCM_RIGHTS behavior change +
>>> > > hard coded filters per device class.
>> > 
>> > I think hard-coded filters are bad (I prefer to move policy to
>> > userspace), and SCM_RIGHTS without a ioctl is out of question, really.
> No rule is really absolute.  To me, it seems the suggested in-kernel
> per-device command code filter is both too big for the given problem

Is it?  150 lines of code?  The per-class filters would share the first
two patches with this series, add a long list of commands to filter, and
the ioctl would be on top of that.

Long lists are better kept in configuration files than in kernel
sources; not to mention the higher cost of getting the API wrong for a
ioctl vs. sysfs.

> while being too limited for much beyond that.

What are the use cases beyond these?  AFAIK these were the first two in
ten years or so...

> So, if we can get away
> with adding an ioctl, I personally think that would be a better
> approach.

I would really prefer to get a green light from Jens/James for per-class
filters in the kernel (which are worth a few hundred lines of data)
before implementing that.

Paolo
