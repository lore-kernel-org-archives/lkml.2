Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353Ab2EHVYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 17:24:05 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:59976 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755270Ab2EHVYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 17:24:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Minho Ban <mhban@samsung.com>
Subject: Re: [RFC/PATCH] PM / Hibernate : Add wait for disk detection if resume_file is MAJOR:MINOR style
Date: Tue, 8 May 2012 23:28:53 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <4FA78724.5000401@samsung.com> <201205072139.20129.rjw@sisk.pl> <4FA8612F.70207@samsung.com>
In-Reply-To: <4FA8612F.70207@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205082328.54057.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 08, 2012, Minho Ban wrote:
> On 05/08/2012 04:39 AM, Rafael J. Wysocki wrote:
> >> +	/* name_to_dev_t is ineffective if resume_file comes in major:minor
> >> +	 * format */
> >> +	if (isdigit(resume_file[0]) && resume_wait) {
> > 
> > The check here is too late.  It should be done before name_to_dev_t() is
> > used on resume_file for the first time.
> > 
> 
> Thanks for comment, I'll pull it up.
> 
> >> +		int partno;
> >> +		while (!get_gendisk(swsusp_resume_device, &partno))
> >> +			msleep(10);
> >> +	}
> >> +
> >>   Check_image:
> >>  	pr_debug("PM: Hibernation image partition %d:%d present\n",
> >>  		MAJOR(swsusp_resume_device), MINOR(swsusp_resume_device));
> > 
> > Besides, I'd like the documentation to be updated to reflect this change too.
> 
> Do you mean resumewait is needed to be updated in kernel-parameters.txt?

No, but it should be decumented what exactly is to be passed in
the resume= command line option (in kernel-parameters.txt).  Please do that
when you're at it.

Thanks,
Rafael
