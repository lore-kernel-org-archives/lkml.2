Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049Ab1EOOOP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 10:14:15 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:62787 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754052Ab1EOOON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 10:14:13 -0400
Date: Sun, 15 May 2011 16:13:07 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org,
        davinci-linux-open-source@linux.davincidsp.com,
        Raffaele Recalcati <lamiaposta71@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [PATCH 1/4] export bus_kset
Message-ID: <20110515141307.GC15994@mail.gnudd.com>
References: <1305220265-9020-1-git-send-email-lamiaposta71@gmail.com> <1305220265-9020-2-git-send-email-lamiaposta71@gmail.com> <201105122128.54172.rjw@sisk.pl> <20110513171148.GM29259@mail.gnudd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110513171148.GM29259@mail.gnudd.com>
X-Face: #Q;A)@_4.#>0+_%y]7aBr:c"ndLp&#+2?]J;lkse\^)FP^Lr5@O0{)J;'nny4%74.fM'n)M
	>ISCj.KmsL/HTxz!:Ju'pnj'Gz&.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 07:11:48PM +0200, Davide Ciminaghi wrote:
> On Thu, May 12, 2011 at 09:28:53PM +0200, Rafael J. Wysocki wrote:
> 
> hi,
> 
> sorry, I missed this message this morning.
> 
> > On Thursday, May 12, 2011, Raffaele Recalcati wrote:
> > > From: Davide Ciminaghi <ciminaghi@gnudd.com>
> > 
> > Please explain why you need to export it, what the alternatives are and
> > why you think this approach is better than the alternatives.
> > 
> 
> what I needed to do was walking through the list of registered busses,
> and invoking the bus_added()/bus_removed() callback of a newly registered
> policy. I couldn't find any other simple way to do it.
>
well, I there is another way to do that: adding a function like this
(include/linux/device.h) :

/**
 * run a callback for each registered bus type
 *
 * @data : arg passed to callback
 * @fn : pointer to callback
 */
int for_each_bus(void *data, int (*fn)(struct bus_type *bus, void *data));

which would be similar to the already existing bus_for_each_dev() and
would allow to avoid exporting a global variable.


Regards
Davide
