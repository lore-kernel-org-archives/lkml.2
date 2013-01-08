Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab3AHL6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 06:58:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49942 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755473Ab3AHL6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 06:58:37 -0500
From: Oliver Neukum <oneukum@suse.de>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: fangxiaozhi 00110321 <fangxiaozhi@huawei.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, zihan@huawei.com, Lin.Lei@huawei.com,
        greg@kroah.com, neil.yi@huawei.com, wangyuhua@huawei.com,
        huqiao36@huawei.com, balbi@ti.com, mdharm-usb@one-eyed-alien.net
Subject: Re: [PATCH 1/1]linux-usb:optimize to match the Huawei USB storage devices and support new switch command
Date: Tue, 08 Jan 2013 12:58:35 +0100
Message-ID: <2911670.8BWQ5fqvtm@linux-5eaq.site>
Organization: SUSE
User-Agent: KMail/4.8.5 (Linux/3.4.11-2.16-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20130108105730.GB3983@breakpoint.cc>
References: <fe8ab374645a.645afe8ab374@huawei.com> <20130108105730.GB3983@breakpoint.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 January 2013 11:57:30 Sebastian Andrzej Siewior wrote:
> > +static int usb_stor_huawei_scsi_init(struct us_data *us)
> > +{
> > +     int result = 0;
> > +     int act_len = 0;
> > +     struct bulk_cb_wrap *bcbw = (struct bulk_cb_wrap *) us->iobuf;
> > +     char rewind_cmd[] = {0x11, 0x06, 0x20, 0x00, 0x00, 0x01, 0x01, 0x00,
> > +                     0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
> > +     
> > +     memset(bcbw, 0, sizeof(struct bulk_cb_wrap));
> > +     bcbw->Signature = cpu_to_le32(US_BULK_CB_SIGN);
> > +     bcbw->Tag = 0;
> > +     bcbw->DataTransferLength = 0;
> > +     bcbw->Flags = bcbw->Lun = 0;
> > +     bcbw->Length = sizeof(rewind_cmd);
> 
> I asked earlier and I ask again: why memset to zero followed by init to zero.
> Could we stick to one thing?

We shouldn't. The compiler will do the right thing. This is for the human
reader. You tell the reader that you want.

a) a clean slate to start with
b) you issue a command with certain parameters specified. That these
parameters are zero is beside the point. The point is telling the reader
which parameters are important here.

	Regards
		Oliver

PS: What about endianness of bcbw->Length?

