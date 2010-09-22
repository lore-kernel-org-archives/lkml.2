Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab0IVQYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 12:24:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:51178 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233Ab0IVQYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 12:24:03 -0400
Subject: Re: [PATCH 04/14] memstick: core: fix device_register() error
 handling
From: James Bottomley <James.Bottomley@suse.de>
To: Greg KH <greg@kroah.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jiri Slaby <jirislaby@gmail.com>,
        linux-kernel@vger.kernel.org, Dan Carpenter <error27@gmail.com>
In-Reply-To: <20100922162006.GA27853@kroah.com>
References: <1284900889-24369-1-git-send-email-segooon@gmail.com>
	 <20100921152031.30365b3f.akpm@linux-foundation.org>
	 <20100921224947.GA20183@kroah.com>
	 <AANLkTimQWtQTBe3RBSbYd7vM4Y+SckkoBDbO8E+SwtJj@mail.gmail.com>
	 <4C99D436.700@panasas.com> <20100922154746.GB26178@kroah.com>
	 <1285170996.2993.134.camel@mulgrave.site>
	 <20100922162006.GA27853@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Sep 2010 11:23:57 -0500
Message-ID: <1285172637.2993.195.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-22 at 09:20 -0700, Greg KH wrote:
> > What other email? ... neither you nor Kay replied after either Boaz's
> > patch or the corrected one were posted.
> 
> See my other email a minute ago in response to this thread.

Can we start again?  You've been replying to a patch to do a
put_device() in device_register() which everyone agrees looks wrong.

The proposal to fix all of this is to free the kobject name and NULL it
out in device_add().  That fixes all the places you and kay broke when
you added the variable length name stuff.

James


