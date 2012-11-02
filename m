Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab2KBOtQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 10:49:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735Ab2KBOtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 10:49:15 -0400
Message-ID: <5093DD5E.6030808@redhat.com>
Date: Fri, 02 Nov 2012 15:49:02 +0100
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
References: <20121025180045.GL11442@htj.dyndns.org> <1657557410.1945557.1351190120407.JavaMail.root@redhat.com> <20121031212241.GZ2945@htj.dyndns.org>
In-Reply-To: <20121031212241.GZ2945@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 31/10/2012 22:22, Tejun Heo ha scritto:
> Hello, Paolo.
> 
> On Thu, Oct 25, 2012 at 02:35:20PM -0400, Paolo Bonzini wrote:
>>> Disabling filters if opened by root and tranfering via SCM_RIGHTS
>>> would be the simplest interface-wise (there's no new interface at
>>> all).  Would that be too dangerous security-wise?
>>
>> That would be a change with respect to what we have now.  After
>> transferring a root-opened (better: CAP_SYS_RAWIO-opened) file
>> descriptor to an unprivileged process your SG_IO commands get
>> filtered.  So a ioctl is needed if you want to rely on SCM_RIGHTS.
> 
> Yeah, I get that it's a behavior change, but would that be a problem?

Worse, it's a potential security hole because previously you'd get
filtering and now you wouldn't.

Considering that SCM_RIGHTS is usually used to transfer a file
descriptor from a privileged process to an unprivileged one, I'd be very
worried of that.

>>> I guess I just feel quite reluctant to expose another rather obscure
>>> userland configurable in-kernel filter and at the same time I'm not
>>> sure whether this is flexible enough.  What if a device is shared by
>>> multiple virtual machines which are trusted at different levels?
>>
>> No, you just don't do that.  If a device is passed through to virtual
>> machines, it is between similar virtual machines (for some definition
>> of similar).  The only case where you have this sharing is in practice
>> if either the device is read-only (my patch does give you a basic
>> two-level filtering, with two separate bitmaps for RO and RW) or if you
>> allow persistent reservations (which is as close to full trust as you
>> can get).
> 
> What disturbs me is that it's a completely new interface to userland
> and at the same a very limited one at that.  So, yeah, it's
> bothersome.  I personally would prefer SCM_RIGHTS behavior change +
> hard coded filters per device class.

I think hard-coded filters are bad (I prefer to move policy to
userspace), and SCM_RIGHTS without a ioctl is out of question, really.

> But, I'd really like to hear what other guys are thinking.  Jens?
> Jens? Jens? Jens? Jens? Jens? Jens? Jens? Jens? Jens? Jens? Jens? :P

:P

Paolo

