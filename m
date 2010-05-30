Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab0E3ULa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 16:11:30 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:55526 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab0E3UL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 16:11:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gI7fsbCyYR4Cu+sKDT1ZVPdvEoHZrEuFTW53bnqKycmCtGWUWfV9uLH6k7drjZq88A
         vPVpSB4n5+nDUI75xfji9Gm4Hw4W0nQlzxMY/6FEZAzdw4aO+yDnIe6/jnMvrdSibnrl
         dPOwf/zG30qVxSnQRQEYgnmHtoUOuC2KI5Nm8=
Date: Sun, 30 May 2010 13:11:42 -0700
From: mark gross <640e9920@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nigel Cunningham <ncunningham@crca.org.au>, markgross@thegnar.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [patch] complain when users abuse the pm_qos API
Message-ID: <20100530201142.GC25545@gvim.org>
Reply-To: markgross@thegnar.org
References: <20100529045027.GE11600@gvim.org>
 <201005292208.04309.rjw@sisk.pl>
 <4C019D36.8070405@crca.org.au>
 <201005302150.01452.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005302150.01452.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 30, 2010 at 09:50:01PM +0200, Rafael J. Wysocki wrote:
> On Sunday 30 May 2010, Nigel Cunningham wrote:
> > Hi.
> > 
> > On 30/05/10 06:08, Rafael J. Wysocki wrote:
> > > On Saturday 29 May 2010, mark gross wrote:
> > >> The following patch is to help clean up API abusers of pm_qos where
> > >> they call update_request before registering a request.
> > >>
> > >> --mgross
> > >>
> > >> --Signed-off-by: markgross<markgross@thegnar.org>
> > >
> > > Will there be a big issue if I push this during the next merge window?
> > 
> > What's the point to the patch? That is: why is calling update_request 
> > before registering a request such a big problem that it demands a WARN() 
> > and dump stack?
> 
> It is an API violation if I understand that correctly.

Yeah, it is, but now that I'm thinking clearly perhaps a better fix
would be to change the prototype of pm_qos_update_request to return
something so callers can check for success.

Lets fix the API rather than use this patch.  Please dopt apply it.

--mgross
 
