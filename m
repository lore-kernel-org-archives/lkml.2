Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175Ab2ENSzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 14:55:43 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:43491 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757157Ab2ENSzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 14:55:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Minho Ban <mhban@samsung.com>
Subject: Re: [PATCH] PM / Hibernate : Use get_gendisk to verify partition if resume_file is integer format
Date: Mon, 14 May 2012 21:00:38 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-pm@vger.kernel.org
References: <4FAA4597.7060302@samsung.com> <201205122339.01696.rjw@sisk.pl> <4FB05770.3050809@samsung.com>
In-Reply-To: <4FB05770.3050809@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205142100.38738.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 14, 2012, Minho Ban wrote:
> On 05/13/2012 06:39 AM, Rafael J. Wysocki wrote:
> > On Wednesday, May 09, 2012, Minho Ban wrote:
> >>  	/* Check if the device is there */
> >>  	swsusp_resume_device = name_to_dev_t(resume_file);
> >> +
> >> +	/*
> >> +	 * name_to_dev_t is ineffective to verify parition if resume_file is in
> >> +	 * integer format. (e.g. major:minor)
> >> +	 */
> >> +	if (isdigit(resume_file[0]) && resume_wait) {
> >> +		int partno;
> >> +		while (!get_gendisk(swsusp_resume_device, &partno))
> >> +			msleep(10);
> >> +	}
> > 
> > Hmm.  Wouldn't it be better to do:
> > 
> > 	if (isdigit(resume_file[0]) && resume_wait) {
> > 		int partno;
> > 		while (!get_gendisk(swsusp_resume_device, &partno))
> > 			msleep(10);
> > 	} else {
> > 		swsusp_resume_device = name_to_dev_t(resume_file);
> > 	}
> > 
> > ?
> 
> Do you want name_to_dev_t to be called again?  If not, swsusp_resume_device parameter 
> in get_gendisk can not be used because it is not initialized yet.

Ah, OK, I didn't notice that.

I think I can take the patch for v3.5 as is.

Thanks,
Rafael
