Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab2GZJ1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 05:27:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350Ab2GZJ1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 05:27:43 -0400
Message-ID: <50110D8C.8060802@redhat.com>
Date: Thu, 26 Jul 2012 11:27:40 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/2] virtio-scsi: fix parsing of hotplug/hot-unplug LUN
 number
References: <1342454751-8950-1-git-send-email-pbonzini@redhat.com>   <1342454751-8950-2-git-send-email-pbonzini@redhat.com>  <1343292731.3115.17.camel@dabdike> <50110820.4040403@redhat.com> <1343294472.3115.22.camel@dabdike>
In-Reply-To: <1343294472.3115.22.camel@dabdike>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 26/07/2012 11:21, James Bottomley ha scritto:
>> > Because scsilun_to_int does not do the AND, so it would have exactly the
>> > same bug I'm fixing.
> It's not a bug ... it's the encoding.  All the other devices use this
> too.  Ideally we should have switched to 64 bit lun numbers for the
> encoding to be exact, but nothing so far has gone over 32 bits.  If we
> don't encode the Address method as part of the lun number, we don't get
> the reverse transform right and the addressing often fails.

But virtio-scsi gets it right even if you use method=0 and method=1
interchangeably.

ibmvscsi (see function lun_from_dev) does something similar to
virtio-scsi, except here I need both directions.

> That does mean that arrays that use address method=1 in REPORT LUNS have
> their lun numbers start at 16384.

That is ugly.  I can see how it may be needed on buggy hardware, but
here we know it's not.

Paolo

