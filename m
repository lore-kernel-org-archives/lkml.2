Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590Ab1EQXE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 19:04:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33484 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932507Ab1EQXE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 19:04:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: Re: [linux-pm] [PATCH 1/4] export bus_kset
Date: Wed, 18 May 2011 01:04:56 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org,
        davinci-linux-open-source@linux.davincidsp.com,
        Raffaele Recalcati <lamiaposta71@gmail.com>,
        linux-kernel@vger.kernel.org
References: <1305220265-9020-1-git-send-email-lamiaposta71@gmail.com> <20110513171148.GM29259@mail.gnudd.com> <20110515141307.GC15994@mail.gnudd.com>
In-Reply-To: <20110515141307.GC15994@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105180104.56252.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, May 15, 2011, Davide Ciminaghi wrote:
> On Fri, May 13, 2011 at 07:11:48PM +0200, Davide Ciminaghi wrote:
> > On Thu, May 12, 2011 at 09:28:53PM +0200, Rafael J. Wysocki wrote:
> > 
> > hi,
> > 
> > sorry, I missed this message this morning.
> > 
> > > On Thursday, May 12, 2011, Raffaele Recalcati wrote:
> > > > From: Davide Ciminaghi <ciminaghi@gnudd.com>
> > > 
> > > Please explain why you need to export it, what the alternatives are and
> > > why you think this approach is better than the alternatives.
> > > 
> > 
> > what I needed to do was walking through the list of registered busses,
> > and invoking the bus_added()/bus_removed() callback of a newly registered
> > policy. I couldn't find any other simple way to do it.
> >
> well, I there is another way to do that: adding a function like this
> (include/linux/device.h) :
> 
> /**
>  * run a callback for each registered bus type
>  *
>  * @data : arg passed to callback
>  * @fn : pointer to callback
>  */
> int for_each_bus(void *data, int (*fn)(struct bus_type *bus, void *data));
> 
> which would be similar to the already existing bus_for_each_dev() and
> would allow to avoid exporting a global variable.

I really think you'd simply need to browse all devices, like the core PM
code in drivers/base/power/main.c.  You can use dpm_list for that just fine.

Thanks,
Rafael
