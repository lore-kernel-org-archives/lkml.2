Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab2AWVFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 16:05:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46514 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947Ab2AWVFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 16:05:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH 3.3-rc1] PM / Sleep: Fix read_unlock_usermodehelper() call.
Date: Mon, 23 Jan 2012 22:09:18 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc1+; KDE/4.6.0; x86_64; ; )
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <201201230449.q0N4npAa029457@www262.sakura.ne.jp> <4F1CF4DE.5090207@linux.vnet.ibm.com>
In-Reply-To: <4F1CF4DE.5090207@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Message-Id: <201201232209.18700.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 23, 2012, Srivatsa S. Bhat wrote:
> On 01/23/2012 10:19 AM, Tetsuo Handa wrote:
> 
> > Commit b298d289
> >  "PM / Sleep: Fix freezer failures due to racy usermodehelper_is_disabled()"
> > added read_unlock_usermodehelper() but read_unlock_usermodehelper() is called
> > without read_lock_usermodehelper() when kmalloc() failed.
> > 
> > Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > -----
> 
> 
> Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Applied.

Thanks,
Rafael


> > diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> > index 26ab358..6c9387d 100644
> > --- a/drivers/base/firmware_class.c
> > +++ b/drivers/base/firmware_class.c
> > @@ -525,8 +525,7 @@ static int _request_firmware(const struct firmware **firmware_p,
> >  	if (!firmware) {
> >  		dev_err(device, "%s: kmalloc(struct firmware) failed\n",
> >  			__func__);
> > -		retval = -ENOMEM;
> > -		goto out;
> > +		return -ENOMEM;
> >  	}
> > 
> >  	if (fw_get_builtin_firmware(firmware, name)) {
> > 
> 
> 
> 

