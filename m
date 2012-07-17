Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab2GQIy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 04:54:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989Ab2GQIy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 04:54:57 -0400
Message-ID: <5005285E.8060706@redhat.com>
Date: Tue, 17 Jul 2012 10:54:54 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] sd: do not set changed flag on all unit attention conditions
References: <1342454772-9018-1-git-send-email-pbonzini@redhat.com>   <1342455503.3176.42.camel@dabdike.int.hansenpartnership.com>   <50044D56.6000400@redhat.com>  <1342511100.3039.9.camel@dabdike.int.hansenpartnership.com>  <50052390.7030908@redhat.com> <1342514444.3039.23.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1342514444.3039.23.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/07/2012 10:40, James Bottomley ha scritto:
>> > 
>> > It's not specific to virtio-scsi, in fact I expect that virtio-scsi will
>> > be almost always used with non-removable disks.
>> > 
>> > However, QEMU's SCSI target is not used just for virtio-scsi (for
>> > example it can be used for USB storage), and it lets you mark a disk as
>> > removable---why? because there exists real hardware that presents itself
>> > as an SBC removable disk.  The only thing that is specific to
>> > virtualization, is support for online resizing (which generates a unit
>> > attention condition CAPACITY DATA HAS CHANGED).
> So what's the problem?  If you're doing pass through of a physical disk,
> we pick up removable from its inquiry string ... a physical removable
> device doesn't get resized.  If you have a virtual disk you want to
> resize, you don't set the removable flag in the inquiry data.

In practice people will do what you said, and it's not a problem.

However, there's nothing that prevents you from running qemu with a
removable SCSI disk, and then resizing it.  I would like this to work,
because SBC allows it and there's no reason why it shouldn't.

Paolo
