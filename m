Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab0GILTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 07:19:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:44239 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab0GILTK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 07:19:10 -0400
Date: Fri, 9 Jul 2010 04:22:56 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pm: Add runtime PM statistics to sysfs
Message-ID: <20100709042256.56e4b82f@infradead.org>
In-Reply-To: <AANLkTinJSHiDbAZJ6ga3AGNoZEFzyVPSrHkEocxa8M6N@mail.gmail.com>
References: <20100708224837.6a18995b@infradead.org>
	<AANLkTinJSHiDbAZJ6ga3AGNoZEFzyVPSrHkEocxa8M6N@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jul 2010 15:04:59 +0800
Ming Lei <tom.leiming@gmail.com> wrote:

> 2010/7/9 Arjan van de Ven <arjan@infradead.org>:
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > diff --git a/include/linux/pm.h b/include/linux/pm.h
> > index 8e258c7..dca597f 100644
> > --- a/include/linux/pm.h
> > +++ b/include/linux/pm.h
> > @@ -476,9 +476,15 @@ struct dev_pm_info {
> >        enum rpm_request        request;
> >        enum rpm_status         runtime_status;
> >        int                     runtime_error;
> > +       unsigned long           active_jiffies;
> > +       unsigned long           suspended_jiffies;
> > +       unsigned long           accounting_timestamp;
> >  #endif
> >  };
> 
> USB subsystem has implemented the function already, and only two
> variables are enough to do the statistics. Suggest you to make a
> reference to usb implementation, maybe sizeof(unsigned long) bytes
> per device can be saved.
> 

I did look at the USB implementation, and it is very clever. But it's
more complex at the same time, because you no longer can just read out
the time stamps, you need to look at the current device state each time
to either subtract jiffies or not. 

by having the timestamp as a separate variable all the code gets
a lot simpler..... sometimes simple over clever is the right thing to
do.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
