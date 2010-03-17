Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab0CQMtp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 08:49:45 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:63089 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab0CQMto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 08:49:44 -0400
Subject: Re: private field in led_classdev?
From: Richard Purdie <rpurdie@rpsys.net>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, lenz@cs.wisc.edu,
       rpurdie@openedhand.com
In-Reply-To: <20100310110153.GA6838@const.bordeaux.inria.fr>
References: <20100307143112.GC5203@const.famille.thibault.fr>
	 <20100310025411.GD26642@kroah.com>
	 <20100310094452.GA5702@const.bordeaux.inria.fr>
	 <20100310110153.GA6838@const.bordeaux.inria.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Mar 2010 12:48:37 +0000
Message-ID: <1268830117.3662.15.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-10 at 12:01 +0100, Samuel Thibault wrote:
> Samuel Thibault, le Wed 10 Mar 2010 10:44:52 +0100, a écrit :
> > Greg KH, le Tue 09 Mar 2010 18:54:11 -0800, a écrit :
> > > What's wrong with using the private pointer in the struct device
> > > instead?
> > 
> > Ah, right. In my case there is a struct device corresponding to the
> > actual input device. I hadn't realized that since registering a led
> > creates a new device, I have another private pointer which I can use.
> 
> One issue, however, is that led_classdev_register() calls
> led_trigger_set_default(), which eventually calls the brightness_set
> hook, but the private field (platform_data) still hasn't been
> initialized, so the brightness_set hook has to abort setting the initial
> state. In my case, after led_classdev_register and setting
> platform_data, I can call the low level function by hand, it's just not
> very pretty...

That is a bit ugly :/.

It would probably make sense to pass that parameter to
led_classdev_register() but changing references to that function
everywhere will be a pain.

I'm tempted to make led_classdev_register() a wrapper around a
led_classdev_register_drvdata() function which takes an extra parameter.

I agree using the private pointer makes sense though.

Cheers,

Richard

