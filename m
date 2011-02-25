Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205Ab1BYMai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 07:30:38 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65305 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab1BYMah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 07:30:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cGQ40gfHguhvop/qiRPtNq2saLZkiUuqvgQKvoLubQwU1/fKPO8Mk0EDWTqV2xkbm9
         MC1IQQjg7AdwK54XIML7LtiCHc3J6h+3qzAo8+4fQlI5lgbAvxr180mflsOxxRMQrZ6O
         ZEfoxg4i1rDTzU5TTk+pydoF5qmPESr8V6E2U=
Date: Fri, 25 Feb 2011 15:30:23 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <kees.cook@canonical.com>, Eugene Teo <eugene@redhat.com>,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: module loading with CAP_NET_ADMIN
Message-ID: <20110225123023.GA8776@albatros>
References: <20110224151238.GA16916@albatros>
 <1298565265.2613.16.camel@bwh-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298565265.2613.16.camel@bwh-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 16:34 +0000, Ben Hutchings wrote:
> On Thu, 2011-02-24 at 18:12 +0300, Vasiliy Kulikov wrote:
> > My proposal is changing request_module("%s", name) to something like
> > request_module("netdev-%s", name) inside of dev_load() and adding
> > aliases to related drivers.
> 
> AFAIK these interface-name aliases are usually defined by distribution
> configuration files rather than within the modules themselves.  And that
> behaviour is pretty much obsolete now that we have hotplug and udev.
> 
> > This would allow to load only netdev
> > modules via these ioctls.  I'm not sure what modules should be patches -
> > at least real physical netdevices have names different from drivers'
> > names, so they don't need patching.  I suppose the list is not big.
> 
> The only modules I can see that declare aliases like this are:
> 
> net/ipv4/ip_gre.c:MODULE_ALIAS("gre0");
> net/ipv4/ipip.c:MODULE_ALIAS("tunl0");
> net/ipv6/sit.c:MODULE_ALIAS("sit0");

Thank you!  These are not handled via udev or anything, it is usefull to
load it via "ifconfig sit0 up", so they do require patching.

I didn't find any modules requiring autoloading except these three.
Good candidate should be "isatap0" as it is seen in ip help, but there
is no such alias.

$ ip tunnel add help 2>&1 | grep mode
          [ mode { ipip | gre | sit | isatap } ] [ remote ADDR ] [ local ADDR ]


I'll send the patch for request_module() and three drivers.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
