Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab2GTNzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 09:55:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42493 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769Ab2GTNzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 09:55:14 -0400
From: Oliver Neukum <oneukum@suse.de>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC] firmware load: defer request_firmware during early boot and resume
Date: Fri, 20 Jul 2012 15:54:25 +0200
Message-ID: <4071247.4LoKycnIHi@linux-lqwf.site>
Organization: SUSE
User-Agent: KMail/4.8.4 (Linux/3.5.0-rc6-117-g918227b-1-vanilla; KDE/4.8.4; x86_64; ; )
In-Reply-To: <CACVXFVNWOcrR9tYhU1wVUSJ_DJ8x+SCk993Sn9dYDe2kzJBDuQ@mail.gmail.com>
References: <CACVXFVNWOcrR9tYhU1wVUSJ_DJ8x+SCk993Sn9dYDe2kzJBDuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 July 2012 20:33:32 Ming Lei wrote:
> The RFC patch is just for discussing if the idea of deferring
> request_firmware is doable for addressing the issue of
> request_firmware in resume path, which is caused by driver
> unbind/rebind during resume.
> 
> At least usb bus is involved in such things, one driver may be
> unbound and rebound in resume path at several situations, and
> request_firmware is often called inside probe().
> 
> Also the idea should be helpful for other hotplug buses too,
> at least there was the similar problem report on pcmcia bus.

The approach seems to me to be less comprehensive than
it ought to be. If you defer, why not the whole probe()?
Deferring only the upoad of the firmware complicates
error handling.

	Regards
		Oliver

