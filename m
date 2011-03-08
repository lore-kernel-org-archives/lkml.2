Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab1CHNYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 08:24:25 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:58127 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab1CHNYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 08:24:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v9 1/1] PRUSS UIO driver support
Date: Tue, 8 Mar 2011 14:24:00 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37; KDE/4.5.1; x86_64; ; )
Cc: "TK, Pratheesh Gangadhar" <pratheesh@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hjk@hansjkoch.de" <hjk@hansjkoch.de>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "sshtylyov@mvista.com" <sshtylyov@mvista.com>,
        "Chatterjee, Amit" <amit.chatterjee@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1299175677-17859-1-git-send-email-pratheesh@ti.com> <B85A65D85D7EB246BE421B3FB0FBB593024C008B02@dbde02.ent.ti.com> <alpine.LFD.2.00.1103081133510.2787@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1103081133510.2787@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103081424.01476.arnd@arndb.de>
X-Provags-ID: V02:K0:MUM5NERALH9QYwA7tnkuI97Ex+24i5HHdVBRxo+AnTz
 hhS4brockCKhax57jVnK6eYHvE01MLx6BogYv8/KMSVwqV9Y44
 cInn1Z8ZVM3wr0JOf6bdeuv6CrTinNtB1+Tjq8hbegkDalwayN
 92N6E5Wp8s9LllO+IX2YmYNvy9/O4P43W956jkkQW0PgWqGmKL
 5qURcbSz52MVVKg2NwNhQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 March 2011, Thomas Gleixner wrote:
> > 
> > +static irqreturn_t pruss_handler(int irq, struct uio_info *info) {
> > +     struct pruss_priv *priv = info->priv;
> > +     struct uio_pruss_dev *gdev = priv->pupdev;
> > 
> > Note that info is a pointer to array supporting 8 interrupts. This allows to
> > redirect to driver structure via info->priv quickly.
> 
> struct uio_pruss_dev *dev = container_of(info, struct uio_pruss_dev, info);
> 
> Perhaps ?

That would require having the same number of uio_info structs as uio_pruss_dev
instances. Right now, one platform device has one uio_pruss_dev instance, which
has 8 uio_info instances, so the container_of() trick doesn't work.

	Arnd
