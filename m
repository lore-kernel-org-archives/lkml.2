Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab2GQMb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 08:31:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159Ab2GQMbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 08:31:24 -0400
Message-ID: <50055B19.8090101@redhat.com>
Date: Tue, 17 Jul 2012 14:31:21 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] sd: do not set changed flag on all unit attention conditions
References: <1342454772-9018-1-git-send-email-pbonzini@redhat.com>     <1342455503.3176.42.camel@dabdike.int.hansenpartnership.com>     <50044D56.6000400@redhat.com>    <1342511100.3039.9.camel@dabdike.int.hansenpartnership.com>    <50052390.7030908@redhat.com>   <1342514444.3039.23.camel@dabdike.int.hansenpartnership.com>   <5005285E.8060706@redhat.com>  <1342516317.3039.35.camel@dabdike.int.hansenpartnership.com>  <5005302D.6010805@redhat.com> <1342527693.3039.64.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1342527693.3039.64.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/07/2012 14:21, James Bottomley ha scritto:
>> Yes, I realize failing only on specific sense codes as I did it in the
>> patch is not going to work.  However, the other way round is not
>> problematic (explicitly allow some sense codes, fail on all others).
> 
> Heh, I once thought that, but there's no end to the strange ideas USB
> manufacturers get.

:)

>> > Another example is "target operating conditions have changed".  QEMU
>> > cannot report such changes because scsi_error prints a warning (fine)
>> > and then passes the unit attention upwards.  With removable drives, this
>> > has the same problem as resizing.
> Why would a removable device ever use any of the codes under this ASC
> when the medium hasn't changed?  They're all for arrays (well except
> 0x10 and 0x11 ... and they're only supposed to apply to tape changers
> with autoload support declared in the control mode page).

There are also a couple of generic ones such as "reported luns have
changed".  I also considered briefly using "inquiry data has changed" to
reload the unmap parameters after live snapshot or storage migration.  I
dropped the idea, please don't put me in the same bin as the USB
manufacturers.

Paolo
