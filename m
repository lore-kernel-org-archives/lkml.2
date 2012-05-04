Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601Ab2EDNGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 09:06:13 -0400
Received: from ironport-out.teksavvy.com ([206.248.143.162]:44206 "EHLO
	ironport-out.teksavvy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146Ab2EDNGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 09:06:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuEBACxOgk8Y9geI/2dsb2JhbAANNoVzsCSGLAEBAQEDI1UBEAsOCgICBRYLAgIJAwIBAgFFBg0BBwEBtCSKGIEvjhOBGASpJQ
X-IronPort-AV: E=Sophos;i="4.75,391,1330923600"; 
   d="scan'208";a="178322660"
Message-ID: <4FA3D442.9050801@teksavvy.com>
Date: Fri, 04 May 2012 09:06:10 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>,
        James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to partition
References: <1335953452-10460-1-git-send-email-jack@suse.cz> <4FA1092E.9090603@redhat.com> <20120502115447.7dcc3a54@pyramind.ukuu.org.uk> <4FA11454.2010103@redhat.com> <20120502121208.3c19a9bc@pyramind.ukuu.org.uk> <4FA11963.3040007@redhat.com> <4FA18D33.3060607@teksavvy.com> <4FA23809.2090905@redhat.com> <4FA27CDB.2080103@teksavvy.com> <4FA27E7C.6070802@redhat.com> <4FA2C205.3030801@teksavvy.com> <4FA3799A.6010908@redhat.com>
In-Reply-To: <4FA3799A.6010908@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-05-04 02:39 AM, Paolo Bonzini wrote:
> Il 03/05/2012 19:36, Mark Lord ha scritto:
>
>>>>>> Dunno which flags, I'm just ignoring them and waiting
>>>>>> for the noise message to get reverted.
> 
> I said which ioctls, not which options.  I.e. cut-and-paste from dmesg.

Here are some:


messages.1:Apr 28 14:08:09 zbox5 kernel: [  268.800536] hdparm: sending ioctl 330 to a partition!
messages.1:Apr 28 14:08:09 zbox5 kernel: [  268.800547] hdparm: sending ioctl 330 to a partition!
messages.1:Apr 28 14:08:57 zbox5 kernel: [  316.413944] hdparm: sending ioctl 330 to a partition!
messages.1:Apr 28 14:08:57 zbox5 kernel: [  316.413951] hdparm: sending ioctl 330 to a partition!
messages.1:Apr 28 14:20:10 zbox5 kernel: [  989.525085] hdparm: sending ioctl 330 to a partition!
messages.1:Apr 28 14:20:10 zbox5 kernel: [  989.525093] hdparm: sending ioctl 330 to a partition!

The in <linux/hdreg.h> say this about 330:

...
/* 0x330 is reserved - used to be HDIO_GETGEO_BIG */
...

So it's HDIO_GETGEO_BIG, which doesn't exist in newer kernels.
I wonder when that got removed?  Minor userspace breakage there.

hdparm issues it first as a backward-compatibility thing,
before falling back to the even-more obsolete HDIO_GETGEO,
which curiously enough is still in modern kernels.

Cheers
