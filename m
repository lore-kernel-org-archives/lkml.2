Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab2FLR0B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 13:26:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437Ab2FLRZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 13:25:59 -0400
Message-ID: <4FD77B94.1030207@redhat.com>
Date: Tue, 12 Jun 2012 19:25:40 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: allow persistent reservations without CAP_SYS_RAWIO
References: <1339517312-18134-1-git-send-email-pbonzini@redhat.com>  <1339518069.3050.8.camel@dabdike.int.hansenpartnership.com>  <4FD76D57.5020709@redhat.com> <4FD77438.6090202@redhat.com> <1339521657.3050.13.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1339521657.3050.13.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 12/06/2012 19:20, James Bottomley ha scritto:
> I don't think you understand how persistent reservations work.
> 
> The first thing I'll say is I agree with Alan.  Unless you can justify
> why you want to relax permissions I'm not going to do it.

See my answer to John.  The reason is that I want to let VMs use
persistent reservations without running them as root.

> But secondly, the reason we're so up in arms about SCSI-3 PR is that
> there's a feature called reservation by transport ID.  This is used to
> reserve multipath devices when one of the paths is down.  Effectively it
> allows a PR-OUT command to set a reservation on any LUN with access only
> to one of them.  It's definitely a hack in the SCSI standard, but it's
> not one that can be controlled by a unix like permission model.  Write
> access to *any* LUN allows you to reserve *all* luns.

Thanks for taking the time to explain---I knew about this, but I thought
it could (perhaps should) be disabled on the SAN.  Anybody could already
use reservation by transport ID if they had root access on the local
machine, no?

Paolo
