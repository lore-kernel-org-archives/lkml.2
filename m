Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab2GEHBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 03:01:35 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58058 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab2GEHBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 03:01:34 -0400
Message-ID: <1341471743.18786.12.camel@lappy>
Subject: Re: [PATCH] virtio-blk: allow toggling host cache between writeback
 and writethrough
From: Sasha Levin <levinsasha928@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, kvm@vger.kernel.org
Date: Thu, 05 Jul 2012 09:02:23 +0200
In-Reply-To: <4FF5388C.5010306@redhat.com>
References: <1341321577-24435-1-git-send-email-pbonzini@redhat.com>
	  <1341419217.18786.3.camel@lappy> <4FF47023.7080206@redhat.com>
	 <1341436285.18786.6.camel@lappy> <4FF5388C.5010306@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-05 at 08:47 +0200, Paolo Bonzini wrote:
> Il 04/07/2012 23:11, Sasha Levin ha scritto:
> > There are two things going on here:
> >  1. Rename VIRTIO_BLK_F_FLUSH to VIRTIO_BLK_F_WCE
> >  2. Add a new VIRTIO_BLK_F_CONFIG_WCE
> > 
> > I'm concerned that the first change is going to break compilation for
> > any code that included linux/virtio-blk.h and used VIRTIO_BLK_F_FLUSH.
> 
> That would be nlkt, right? :)

nlkt, lguest, and probably others.

linux/virtio_blk.h is a public kernel header, which is supposed to be
used from userspace - so I assume many others who implemented virtio-blk
for any reason took advantage of that header.

