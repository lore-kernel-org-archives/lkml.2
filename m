Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab1FNOGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 10:06:48 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60581 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab1FNOGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 10:06:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=stO+JfAbnXTe+QvpvZ9xGlcyewp3OrlpCYdjIas2uP1bgvJ9IzsJD86ZrjV9wtME8P
         oliYQ88q5vd3iJL0o6CtSjIpQrtKxdlbF7vE3ZQjRIWE/rzeunBHtY0MpRrIE8fPr67B
         SJAPILEijNraksPECUCDrOuzev0WkBM8KUrSQ=
Date: Tue, 14 Jun 2011 07:06:42 -0700
From: mark gross <markgross@thegnar.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, markgross@thegnar.org,
        Raffaele Recalcati <lamiaposta71@gmail.com>,
        linux-pm@lists.linux-foundation.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] pm loss development
Message-ID: <20110614140642.GA14509@gvim.org>
Reply-To: markgross@thegnar.org
References: <1305220265-9020-1-git-send-email-lamiaposta71@gmail.com>
 <201105180107.58078.rjw@sisk.pl>
 <20110518031203.GA3640@gvim.org>
 <201105182143.13237.rjw@sisk.pl>
 <20110602222111.GA15414@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110602222111.GA15414@ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 12:21:11AM +0200, Pavel Machek wrote:
> Hi!
> 
> > > > What do you mean by safe state?
> > > >
> > > I need to get more details on this but I assume its a state where the
> > > meta data of the file system is committed to the emmc before lights go
> > > off such that when power is reapplied that the damage isn't too big. 
> > 
> > I don't think you can guarantee that the metadata won't be damaged
> > without notifying the filesystem of the event (and making it react
> > appropriately).
> 
> Journalling filesystem should survive power loss at random time, as
> long as block device behaves like a disk (i.e. writes whole sectors).
> 
> And that can be guaranteed at driver level...
> 

What if the battery falls out of the device at a bad time?  The HW will
have micro to mili seconds of time to close out whatever transaction is
in flight.

I know nothing about journalling file systems or how well they limit the
critical sections of time where the file system is exposed to corruption
from sudden power failure.  Its an interesting question though.

--mark

