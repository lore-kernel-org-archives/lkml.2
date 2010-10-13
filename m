Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab0JMXuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 19:50:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753427Ab0JMXuM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 19:50:12 -0400
MIME-Version: 1.0
In-Reply-To: <1286977551.2969.22.camel@mulgrave.site>
References: <1286977551.2969.22.camel@mulgrave.site>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 13 Oct 2010 16:49:22 -0700
Message-ID: <AANLkTimUT37LfmnU8Rc0+K8r+owCp9e_VyriDHRyuuhr@mail.gmail.com>
Subject: Re: [GIT PULL] SCSI bug fixes for 2.6.36-rc7
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 6:45 AM, James Bottomley
<James.Bottomley@suse.de> wrote:
> This patch set fixes a couple of longstanding bugs in SCSI.  The VPD
> patch fix a possible buffer overrun in the VPD code (only tripped if the
> device has a huge number of VPD pages).  The other is where the status
> return code on our BSG interface is wrongly right shifted one place.

Umm. That other patch seems to be utter crap.

> -       hdr->device_status = status_byte(rq->errors);
> +       hdr->device_status = rq->errors && 0xff;

That's pure shit. Please look at it for one second, and don't send me
crap like this.

                        Linus "grumpy" Torvalds
