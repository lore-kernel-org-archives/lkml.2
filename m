Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab2FLRNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 13:13:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411Ab2FLRNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 13:13:53 -0400
Message-ID: <4FD778BA.8040201@redhat.com>
Date: Tue, 12 Jun 2012 19:13:30 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: John Stoffel <john@stoffel.org>
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-scsi@vger.kernel.org,
        jbottomley@parallels.com
Subject: Re: [PATCH] scsi: allow persistent reservations without CAP_SYS_RAWIO
References: <1339517312-18134-1-git-send-email-pbonzini@redhat.com> <20439.30634.460606.215696@quad.stoffel.home>
In-Reply-To: <20439.30634.460606.215696@quad.stoffel.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 12/06/2012 19:08, John Stoffel ha scritto:
> Paolo> Persistent reservations commands cannot be issued right now
> Paolo> without giving CAP_SYS_RAWIO to the process who wishes to send
> Paolo> them.  This is a bit heavy-handed, allow these two commands.
> 
> This seems like a bad idea, now anyone can just put in a SCSI
> reservation on a system and then you have to hunt around trying to
> figure it out.  

What's the difference from anyone destroying data on a disk?  You still
need write access to the block device node.  Also, you could already do
the same if you have root permissions on your _local_ machine.

(BTW, please reply to these objections where I already stated them, in
the answer to James Bottomley).

> What's the motivation here?  What's the use case this solves?  

I would like to give access to persistent reservations to VMs, without
having to run qemu as root.  One alternative is to run a userspace iSCSI
initiator, but of course that would only work with iSCSI.

Paolo
