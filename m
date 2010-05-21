Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab0EULfP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 07:35:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058Ab0EULfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 07:35:12 -0400
Date: Fri, 21 May 2010 12:34:49 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "David S. Miller" <davem@davemloft.net>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Chris Mason <chris.mason@oracle.com>,
       Alasdair G Kergon <agk@redhat.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Ian Kent <raven@themaw.net>
Subject: Re: add devname module aliases to allow module on-demand
	auto-loading
Message-ID: <20100521113449.GM3991@agk-dp.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	Kay Sievers <kay.sievers@vrfy.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	"David S. Miller" <davem@davemloft.net>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Chris Mason <chris.mason@oracle.com>,
	Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
	Ian Kent <raven@themaw.net>
References: <1274371640.302.5.camel@yio.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274371640.302.5.camel@yio.site>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 06:07:20PM +0200, Kay Sievers wrote:
> This adds:
>   alias: devname:<name>
> to some common kernel modules, which will allow the on-demand loading
> of the kernel module when the device node is accessed.

I don't see any need for this for device-mapper: please leave dm out of this.
 
> Ideally all these modules would be compiled-in, 

Why do you think that?  Currently that's a matter for the user/distro to
decide!  IMHO It's really not for the kernel to force a policy like this on its
users.  If that's what you think, why does your patch instead not go the whole
way and refuse to allow these items even to be compiled as modules?

> but distros seems too
> much in love with their modularization that we need to cover the common
> cases with this new facility. It will allow us to remove a bunch of pretty
> useless init scripts and modprobes from init scripts.

Again, I don't see why this needs any kernel changes.  If this was 
important, any distro could deal with it itself trivially without needing
a kernel patch.
 
Nack for the dm part of this from my point of view as it removes flexibility
with a 'one size fits all' approach that introduces a fixed minor number
into a dynamic world.

Alasdair

