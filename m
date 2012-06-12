Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab2FLSDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 14:03:04 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58839 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752773Ab2FLSDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 14:03:03 -0400
Message-ID: <1339524176.3050.18.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH] scsi: allow persistent reservations without
 CAP_SYS_RAWIO
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-scsi@vger.kernel.org
Date: Tue, 12 Jun 2012 19:02:56 +0100
In-Reply-To: <4FD77B94.1030207@redhat.com>
References: <1339517312-18134-1-git-send-email-pbonzini@redhat.com>
	  <1339518069.3050.8.camel@dabdike.int.hansenpartnership.com>
	  <4FD76D57.5020709@redhat.com> <4FD77438.6090202@redhat.com>
	 <1339521657.3050.13.camel@dabdike.int.hansenpartnership.com>
	 <4FD77B94.1030207@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-12 at 19:25 +0200, Paolo Bonzini wrote:
> Il 12/06/2012 19:20, James Bottomley ha scritto:
> > But secondly, the reason we're so up in arms about SCSI-3 PR is that
> > there's a feature called reservation by transport ID.  This is used to
> > reserve multipath devices when one of the paths is down.  Effectively it
> > allows a PR-OUT command to set a reservation on any LUN with access only
> > to one of them.  It's definitely a hack in the SCSI standard, but it's
> > not one that can be controlled by a unix like permission model.  Write
> > access to *any* LUN allows you to reserve *all* luns.
> 
> Thanks for taking the time to explain---I knew about this, but I thought
> it could (perhaps should) be disabled on the SAN.  Anybody could already
> use reservation by transport ID if they had root access on the local
> machine, no?

No ... it's required for multipath to work correctly and multipath is a
usual enterprise feature.

The only way around this is either to trust your users or not to give
out root ... and most data centres choose the latter.  It causes real
pain from NPIV and SR-IOV ... you need hardware solutions like some type
of SAN volume controller to fix it.

James


