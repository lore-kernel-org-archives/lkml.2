Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab2GTJtr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 05:49:47 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:49416 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905Ab2GTJto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 05:49:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Todd Poynor <toddpoynor@google.com>
Subject: Re: [PATCH] PM / Sleep: Print name of wakeup source that aborts suspend
Date: Fri, 20 Jul 2012 11:55:24 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, arve@android.com
References: <1342637519-22355-1-git-send-email-toddpoynor@google.com> <201207182147.34750.rjw@sisk.pl> <20120720010019.GA15701@google.com>
In-Reply-To: <20120720010019.GA15701@google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207201155.24730.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 20, 2012, Todd Poynor wrote:
> On Wed, Jul 18, 2012 at 09:47:34PM +0200, Rafael J. Wysocki wrote:
> > On Wednesday, July 18, 2012, Todd Poynor wrote:
> ...
> > > +{
> > > +	struct wakeup_source *ws;
> > > +	int active = 0;
> > > +	struct wakeup_source *last_activity_ws = NULL;
> > > +
> > > +	rcu_read_lock();
> > > +	list_for_each_entry_rcu(ws, &wakeup_sources, entry) {
> > > +		if (ws->active) {
> > > +			pr_info("active wakeup source: %s\n", ws->name);
> > > +			active = 1;
> > 
> > Can we do a break here?  Or do we want to get all of them?
> 
> I haven't seen more than 3 activated during suspend entry at a time, but
> could just list one.  I haven't made that change yet but will if it's
> preferred.

That depend on what your needs are.  For debugging purposes it probably is
better to print them all.

Thanks,
Rafael
