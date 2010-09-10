Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab0IJWao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 18:30:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43717 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991Ab0IJWan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 18:30:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH] PM / Wakeup: Introduce wakeup source objects and event statistics (was: Re: Wakeup-events implementation)
Date: Sat, 11 Sep 2010 00:29:31 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1009101119060.1651-100000@iolanthe.rowland.org> 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009110029.31843.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 10, 2010, Rafael J. Wysocki wrote:
> On Friday, September 10, 2010, Alan Stern wrote:
> > On Wed, 8 Sep 2010, Rafael J. Wysocki wrote:
> > 
> > > +struct wakeup_source *wakeup_source_create(const char *name)
> > > +{
> > > +	struct wakeup_source *ws;
> > > +
> > > +	ws = kzalloc(sizeof(*ws), GFP_KERNEL);
> > > +	if (!ws)
> > > +		return NULL;
> > > +
> > > +	if (name) {
> > > +		int len = strlen(name);
> > > +		char *s = kzalloc(len + 1, GFP_KERNEL);
> > > +		if (s) {
> > > +			strncpy(s, name, len);
> > > +			ws->name = s;
> > > +		}
> > > +	}
> > > +
> > > +	return ws;
> > > +}
> > 
> > Forget what I wrote earlier; it was stupid.  Just use kstrdup.

Right, I didn't know it existed. :-)

Thanks,
Rafael
