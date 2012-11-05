Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab2KENBA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:01:00 -0500
Received: from service87.mimecast.com ([91.220.42.44]:55028 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab2KENA7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:00:59 -0500
Message-ID: <1352120454.10947.5.camel@hornet>
Subject: Re: [PATCH 6/9] virtio_mmio: Cast &resources[1].start to
 =?UTF-8?Q?=E2=80=98unsigned?= int =?UTF-8?Q?*=E2=80=99?= to rid compiler
 warning
From: Pawel Moll <pawel.moll@arm.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Date: Mon, 05 Nov 2012 13:00:54 +0000
In-Reply-To: <20121105082116.GB2699@gmail.com>
References: <1351980150-24145-1-git-send-email-lee.jones@linaro.org>
	 <1351980150-24145-7-git-send-email-lee.jones@linaro.org>
	 <87k3u0ydry.fsf@rustcorp.com.au> <20121105082116.GB2699@gmail.com>
X-Mailer: Evolution 3.6.0-0ubuntu3
Mime-Version: 1.0
X-OriginalArrivalTime: 05 Nov 2012 13:00:54.0761 (UTC) FILETIME=[973D6590:01CDBB55]
X-MC-Unique: 112110513005602701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-05 at 08:21 +0000, Lee Jones wrote:
> > >  	processed = sscanf(str, "@%lli:%u%n:%d%n",
> > > -			&base, &resources[1].start, &consumed,
> > > +			&base, (unsigned int *)&resources[1].start, &consumed,
> > >  			&vm_cmdline_id, &consumed);
> > 
> > This suppresses a valid warning, leaving our code no less wrong than
> > before.  But now it's silently wrong!
> > 
> > Do you want to try again?
> 
> For sure I'll try again.
> 
> How does `s/%u/%p/` suit?

sscanf doesn't do "%p"... The only reasonable way of fixing this is a
intermediate local variable - will post a patch in a second.

Thanks for spotting this!

Paweł


