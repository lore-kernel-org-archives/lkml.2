Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab2FLQZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 12:25:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473Ab2FLQZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 12:25:19 -0400
Message-ID: <4FD76D57.5020709@redhat.com>
Date: Tue, 12 Jun 2012 18:24:55 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: allow persistent reservations without CAP_SYS_RAWIO
References: <1339517312-18134-1-git-send-email-pbonzini@redhat.com> <1339518069.3050.8.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1339518069.3050.8.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 12/06/2012 18:21, James Bottomley ha scritto:
>> > Persistent reservations commands cannot be issued right now without
>> > giving CAP_SYS_RAWIO to the process who wishes to send them.  This
>> > is a bit heavy-handed, allow these two commands.
>
> Why is this heavy handed?  If you remove CAP_SYS_RAWIO, any userspace
> process can send these, which would allow any user to completely disrupt
> a SAN by injecting spurious reservations ... that doesn't look to be
> terribly safe for an operating system running in a data centre.

It is heavy-handed because:

1) there are still other protections such as DAC (both Unix permissions
and ACLs) and SELinux; CAP_SYS_RAWIO is effectively the same as root.

2) if any user could disrupt the SAN by injecting spurious reservations
just by having his laptop's root password, that data centre wouldn't be
terribly safe to begin with.

Paolo
