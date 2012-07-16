Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab2GPSQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 14:16:19 -0400
Received: from fias.uni-frankfurt.de ([141.2.248.1]:35252 "EHLO
	fias.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab2GPSQP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 14:16:15 -0400
Message-ID: <1342462572.17531.18.camel@blech>
Subject: Re: UIO: missing resource mapping
From: Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, Andreas Schallenberg <embedded@gmx.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org
Date: Mon, 16 Jul 2012 20:16:12 +0200
In-Reply-To: <20120713181953.GA11527@redhat.com>
References: <4FFE7C1F.7080702@gmx.net> <20120712194432.GA2592@local>
	 <20120712231632.GC9317@redhat.com> <1342166955.6607.5.camel@blech>
	 <20120713132223.GA10959@redhat.com> <1342190571.6607.36.camel@blech>
	 <20120713181953.GA11527@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 13.07.2012, 21:19 +0300 schrieb Michael S. Tsirkin:
> 
> UIO has the same property, doesn't it? Multiple users can
> access device memory through sysfs. 


Indeed, that's a similar problem. I haven't tried it (yet), but this
particular problem can maybe circumvented by using mmap with the
MAP_PRIVATE flag. Doing so is the responsibility of the driver
programmer (like Hans already said). Even if that mmap trick does not
work, it is pretty much sure that a BAR is already used by another
program, if a related kernel driver is loaded. In that case the kernel
has a chance to avoid such BAR race conditions by not giving the
possibility to map them to the userspace.

Nevertheless, I'm pretty sure that the possibility via sysfs to access
BARs, which are already managed by a kernel driver, opens the door for
denial of service attacks.

On the other hand, I'm quite a newbie on this topic and maybe I don't
see the big picture here. Therefore it is up to you guys to make the
right decision (if needed). 

-- 
Gruß
  Dominic

