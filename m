Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790Ab2JaMwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 08:52:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45766 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756872Ab2JaMwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 08:52:37 -0400
Message-ID: <50911F0D.4030901@redhat.com>
Date: Wed, 31 Oct 2012 13:52:29 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
CC: Tejun Heo <tj@kernel.org>, Ric Wheeler <rwheeler@redhat.com>,
        Petr Matousek <pmatouse@redhat.com>, Kay Sievers <kay@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: setting up CDB filters in udev (was Re: [PATCH v2 0/3] block:
 add queue-private command filter, editable via sysfs)
References: <20121025180045.GL11442@htj.dyndns.org> <1657557410.1945557.1351190120407.JavaMail.root@redhat.com>
In-Reply-To: <1657557410.1945557.1351190120407.JavaMail.root@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

Paolo

Il 25/10/2012 20:35, Paolo Bonzini ha scritto:
>> On Thu, Oct 25, 2012 at 09:37:39AM +0200, Paolo Bonzini wrote:
>>> Il 24/10/2012 18:47, Tejun Heo ha scritto:
>>>> So, I'm still not convinced we need to go forward with full
>>>> configurability. All use cases you described can be covered with
>>>> per-class static filters + simple override switch to disable all,
>>>> which would result in a lot simpler implementation w/ much
>>>> smaller userland interface.
>>>
>>> I'm not sure the userland interface would be smaller, and it would
>>> be more complex to get right:
>>>
>>> 1) how do you override the default?  ioctl+SCM_RIGHTS or sysfs?
>>
>> Disabling filters if opened by root and tranfering via SCM_RIGHTS
>> would be the simplest interface-wise (there's no new interface at
>> all).  Would that be too dangerous security-wise?
> 
> That would be a change with respect to what we have now.  After
> transferring a root-opened (better: CAP_SYS_RAWIO-opened) file
> descriptor to an unprivileged process your SG_IO commands get
> filtered.  So a ioctl is needed if you want to rely on SCM_RIGHTS.
> 
>>> 2) do you need to override the default to "no access", "full
>>> access" and "default access", or is a binary knob (default
>>> access/full access) sufficient?
>>
>> Default / full should be enough, no?
> 
> If a ioctl has to be added, I'd rather have at least none/full/default.
> 
>>> 3) what capabilities control the setting?
>>
>> CAP_SYS_RAWIO seems to be a pretty good fit.
> 
> Yes, for a ioctl it is (for sysfs CAP_SYS_ADMIN is better IMHO).
> 
>> I guess I just feel quite reluctant to expose another rather obscure
>> userland configurable in-kernel filter and at the same time I'm not
>> sure whether this is flexible enough.  What if a device is shared by
>> multiple virtual machines which are trusted at different levels?
> 
> No, you just don't do that.  If a device is passed through to virtual
> machines, it is between similar virtual machines (for some definition
> of similar).  The only case where you have this sharing is in practice
> if either the device is read-only (my patch does give you a basic
> two-level filtering, with two separate bitmaps for RO and RW) or if you
> allow persistent reservations (which is as close to full trust as you
> can get).
> 
>> I'm not trying to block it at all cost but let's make sure we looked
>> into most possibilities before (re)adding this userland visible
>> interface.
> 
> Sure, understood. :)
> 
>> Jens, James, what do you guys think?
> 
> Paolo
> 

