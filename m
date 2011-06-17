Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758876Ab1FQJnn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 05:43:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50222 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab1FQJnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 05:43:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=i5gzR4qckTAfD5XkAAhGge5mNvoekaJHSL2IRJ0TdbxC92gUPvErhDt3MI+Dwv5HUg
         qJlDec5ZDUrY5koeGgqCIW3v2TX0woMfVHCm1PzTvxSBgz7CDxcntGIRoK3CYUinNDb4
         mXi5yIkTV+w7kwa3NZlOnDd9ORMDoIdZb07ug=
Date: Fri, 17 Jun 2011 11:43:32 +0200
From: Tejun Heo <tj@kernel.org>
To: =?iso-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
Cc: alsa-devel@alsa-project.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "Lopez Cruz, Misael" <misael.lopez@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Girdwood, Liam" <lrg@ti.com>
Subject: Re: Re: [alsa-devel] [PATCH v4 11/18] input: Add initial support for
 TWL6040 vibrator
Message-ID: <20110617094332.GE2611@htj.dyndns.org>
References: <1307706876-4768-1-git-send-email-peter.ujfalusi@ti.com>
 <20110616120244.GA2611@htj.dyndns.org>
 <4306005.scnJ1lQX4P@barack>
 <5740779.B2nyl9oMW4@barack>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5740779.B2nyl9oMW4@barack>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Péter.

On Fri, Jun 17, 2011 at 12:39:57PM +0300, Péter Ujfalusi wrote:
> Just avoid another series...
> I have looked at the alloc_workqueue, and I'm not really sure what parameters 
> should I use.
> #define create_singlethread_workqueue(name)			\
> 	alloc_workqueue((name), WQ_UNBOUND | WQ_MEM_RECLAIM, 1)
> 
> I would use something like this instead of create_singlethread_workqueue:
> 
> alloc_workqueue("twl6040-vibra", WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_HIGHPRI, 1);

Just use the default params

	alloc_workqueue("twl6040-vibra", 0, 0);

Thanks.

-- 
tejun
