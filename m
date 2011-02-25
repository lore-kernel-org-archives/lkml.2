Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab1BYP5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 10:57:42 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50144 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932476Ab1BYP5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 10:57:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=p5t4/dPtuRFiRywhcIePey5DRW6N9YcgyZkztQvOTE6ImKofV7QlHnNRYWPS6X4Ow2
         mIRSCzHV3nNt/HtZOc9R96PRK+LmcbLqdAS+O4ZKgZ7c86PgXFwaKqrCxXey6ZSib6vL
         G7GmAnzxdEXGBEXczDMt1NoQ9dg/YpMaIBizc=
Date: Fri, 25 Feb 2011 18:57:35 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Ben Hutchings <bhutchings@solarflare.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <kees.cook@canonical.com>,
        Eugene Teo <eugene@redhat.com>,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: module loading with CAP_NET_ADMIN
Message-ID: <20110225155735.GA3724@albatros>
References: <20110224151238.GA16916@albatros>
 <1298565265.2613.16.camel@bwh-desktop>
 <20110225123023.GA8776@albatros>
 <4D67CAD7.7060408@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D67CAD7.7060408@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 18:29 +0300, Michael Tokarev wrote:
> 25.02.2011 15:30, Vasiliy Kulikov wrote:
> > On Thu, Feb 24, 2011 at 16:34 +0000, Ben Hutchings wrote:
> >> On Thu, 2011-02-24 at 18:12 +0300, Vasiliy Kulikov wrote:
> >>> My proposal is changing request_module("%s", name) to something like
> >>> request_module("netdev-%s", name) inside of dev_load() and adding
> >>> aliases to related drivers.
> 
> It is not the kernel patching which we should worry about, kernel
> part is trivial.
> 
> What is not trivial is to patch all the systems out there who
> autoloads network drivers based on /etc/modprobe.d/network-aliases.conf
> (some local file), ie, numerous working setups which already
> uses this mechanism since stone age.  And patching these is
> not trivial at all, unfortunately.
> 
> Somewhat weird setups (one can load the modules explicitly, and
> nowadays this all is handled by udev anyway), but this change
> will break some working systems.
> 
> Maybe the cost (some pain for some users) isn't large enough
> but the outcome is good, and I think it _is_ good, but it needs
> some wider discussion first, imho.
> 
> I can't think of a way to handle this without breaking stuff.

Currently Linux slowly moves in the direction of rootless systems.  This
definitely need proper restrictions of CAP_* power.  Network admin does
nothing with general modules.  It _has_ to break something one day
because old assumptions about permission stuff don't conform CAP_*
things: old assumptions are very closely connected with just everything.

I'm not sure how this particular CAP_NET_ADMIN misuse should be fixed,
maybe distributions should supply script to upgrade modprobe configs.
Also note that change s/CAP_SYS_MODULE/CAP_NET_ADMIN/ was made in
2.6.32, so there is a possibility that the set of affected distributions
(that doesn't use udev stuff) is very small.


Thanks for your input,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
