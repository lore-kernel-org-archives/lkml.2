Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab1LEOhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 09:37:35 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:65159 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215Ab1LEOhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 09:37:34 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ming Lei <ming.lei@canonical.com>
Subject: Re: [RFC PATCH v1 5/7] media: v4l2: introduce two IOCTLs for face detection
Date: Mon, 5 Dec 2011 14:37:27 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tony Lindgren <tony@atomide.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, Sylwester Nawrocki <snjw23@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-omap@vger.kernel.org
References: <1322817178-8931-1-git-send-email-ming.lei@canonical.com> <42689146.OPtqLboC2m@wuerfel> <CACVXFVO5Bu8vTfLN_WFsEkHW6JhQFmWPmEyNnrvTsDhoF-WVeA@mail.gmail.com>
In-Reply-To: <CACVXFVO5Bu8vTfLN_WFsEkHW6JhQFmWPmEyNnrvTsDhoF-WVeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112051437.27538.arnd@arndb.de>
X-Provags-ID: V02:K0:EyMmfB1wFAf1DsWO9+7eJp9XlQCgW1cPKxnekfKnZ3m
 kXoZz27I/TLFCxL40zrUe8T0kVghiT43aE23QtUnqdzELTuBwh
 D04AzLipld8pabHbfvFCXBz6TBTiMQ4X9QoHKa+KqGcE++zEjN
 5kobtFR8QgivHIkECjOGGNluHekoZKiKKn4t/vq2PLCavVrtjg
 r1EbBZBwrk0mb0LXLTX9dy8+gFBTa3MFUHMBlfjWSRGdKy5pxl
 mW/ldjEsAr6EfUuqvDO/pT9NsBYputBC4eYHMMk/5Zrsjopnlj
 NXy65eJ0SD1LDjXflFC/nps/TqamJHSJ7NLkuLS8toqBwESVFW
 K3q9YyTJZPpDQknYIqrY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 December 2011, Ming Lei wrote:
> >
> > This data structure is not 32/64 bit safe: running a 64 bit kernel with 32 bit
> > user space will see an incompatible layout.
> 
> I agree that this is not 32/64 bit safe, but I understand lib32 can handle
> this correctly, otherwise many 32bit applications can't run on current
> 64bit kernel
> since many kernel structures used by user space contained pointer,
> such as struct v4l2_buffer, struct v4l2_ext_controls in v4l2 ABI.

The other ones you mentioned are handled in the kernel in
drivers/media/video/v4l2-compat-ioctl32.c. For new ioctl commands,
it's better to define the data structure in a compatible way
so you do not need a wrapper like that.

	Arnd
