Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab0JNAZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 20:25:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:33107 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545Ab0JNAZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 20:25:11 -0400
Subject: Re: [GIT PULL] SCSI bug fixes for 2.6.36-rc7
From: James Bottomley <James.Bottomley@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTimUT37LfmnU8Rc0+K8r+owCp9e_VyriDHRyuuhr@mail.gmail.com>
References: <1286977551.2969.22.camel@mulgrave.site>
	 <AANLkTimUT37LfmnU8Rc0+K8r+owCp9e_VyriDHRyuuhr@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Oct 2010 20:24:59 -0400
Message-ID: <1287015899.10264.394.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-13 at 16:49 -0700, Linus Torvalds wrote:
> On Wed, Oct 13, 2010 at 6:45 AM, James Bottomley
> <James.Bottomley@suse.de> wrote:
> > This patch set fixes a couple of longstanding bugs in SCSI.  The VPD
> > patch fix a possible buffer overrun in the VPD code (only tripped if the
> > device has a huge number of VPD pages).  The other is where the status
> > return code on our BSG interface is wrongly right shifted one place.
> 
> Umm. That other patch seems to be utter crap.
> 
> > -       hdr->device_status = status_byte(rq->errors);
> > +       hdr->device_status = rq->errors && 0xff;
> 
> That's pure shit. Please look at it for one second, and don't send me
> crap like this.

What's wrong with it? device_status() is an ancient SCSI-1 macro that
dates from the time the status was left shifted by 1, which makes the
value wrong according to the sg interface spec.  We should really remove
it, but there's still a few ancient drivers using it.  the SG interface
requires the full status byte, which is what the bottom most byte of
req_errors is ... hence the change.

James


