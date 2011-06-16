Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab1FPMCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 08:02:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55505 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab1FPMCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 08:02:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=HXwnoc3BD1mr3aIlxllRRgKF5HAB/u6C9KxAY4LZ0gAKzjqjyruhu0LwleSMV39bRm
         GvIUuSC6S0kK3X01kfch8SMUK1ejUBA7Ke3cm8qAokCeRS11FDiVcDzYIoXvByv/AMv8
         9hWSe8jdSN9FiJuqzuTzZPP8efXhMUmgDe0K4=
Date: Thu, 16 Jun 2011 14:02:44 +0200
From: Tejun Heo <tj@kernel.org>
To: =?iso-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, "Girdwood, Liam" <lrg@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Lopez Cruz, Misael" <misael.lopez@ti.com>
Subject: Re: Re: Re: Re: Re: Re: [PATCH v4 11/18] input: Add initial support
 for TWL6040 vibrator
Message-ID: <20110616120244.GA2611@htj.dyndns.org>
References: <1307706876-4768-1-git-send-email-peter.ujfalusi@ti.com>
 <20110615081858.GM8141@htj.dyndns.org>
 <20110615082301.GN8141@htj.dyndns.org>
 <5476342.2jZLF0UGcI@barack>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5476342.2jZLF0UGcI@barack>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jun 16, 2011 at 02:13:59PM +0300, Péter Ujfalusi wrote:
> On Wednesday 15 June 2011 10:23:01 Tejun Heo wrote:
> > On Wed, Jun 15, 2011 at 10:18:58AM +0200, Tejun Heo wrote:
> > > No human being can feel 120usec difference and I can't see how using
> > > HIGHPRI is justified here (which is what the code is doing
> > > _accidentally_ by using singlethread_workqueue).
> > 
> > Ooh, one more thing, and even if you insist on using HIGHPRI (please
> > don't), you don't need to create workqueue for each device.  You can
> > just create one for the whole driver in init and destroy it from exit.
> > What matters is the HIGHPRI attribute of the workqueue.  The number of
> > workqueues is completely irrelevant.
> 
> Fair enough.
> I'll move to create_workqueue.

I suppose you meant alloc_workqueue()? :)

Sorry about the confusing names, I'm still in the (slow) process of
deprecating older APIs.

Thanks.

-- 
tejun
