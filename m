Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab2C0Vre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 17:47:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38463 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196Ab2C0Vrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 17:47:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH 2/6] firmware_class: Split _request_firmware() into three functions
Date: Tue, 27 Mar 2012 23:51:50 +0200
User-Agent: KMail/1.13.6 (Linux/3.3.0+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <201203032122.36745.chunkeey@googlemail.com> <201203262236.59126.rjw@sisk.pl> <4F7232B3.7020504@codeaurora.org>
In-Reply-To: <4F7232B3.7020504@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203272351.50486.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 27, 2012, Stephen Boyd wrote:
> On 03/26/12 13:36, Rafael J. Wysocki wrote:
> > On Monday, March 26, 2012, Stephen Boyd wrote:
> >> On 03/25/12 15:01, Rafael J. Wysocki wrote:
> >>> @@ -639,8 +655,15 @@ static int request_firmware_work_func(vo
> >>>  		return 0;
> >>>  	}
> >>>  
> >>> -	ret = _request_firmware(&fw, fw_work->name, fw_work->device,
> >>> +	ret = _request_firmware_prepare(&fw, fw_work->name, fw_work->device);
> >>> +	if (ret <= 0)
> >>> +		return ret;
> >> This needs to jump to the cont function so that users know loading
> >> failed or that the firmware was builtin.
> > You're right, sorry.  That should have been
> >
> > 	if (ret > 0) {
> > 		ret = _request_firmware(fw, fw_work->name, fw_work->device,
> > 			fw_work->uevent, true);
> > 		if (ret)
> > 			_request_firmware_cleanup(&fw);
> > 	}
> >
> > but actually using a jump makes the next patch look better.
> >
> > Updated patch is appended.
> > ---
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > Subject: firmware_class: Split _request_firmware() into three functions, v2
> >
> > Split _request_firmware() into three functions,
> > _request_firmware_prepare() doing preparatory work that need not be
> > done under umhelper_sem, _request_firmware_cleanup() doing the
> > post-error cleanup and _request_firmware() carrying out the remaining
> > operations.
> >
> > This change is requisite for moving the acquisition of umhelper_sem
> > from _request_firmware() to the callers, which is going to be done
> > subsequently.
> 
> Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

Thanks!

Rafael
