Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab2HBQ4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 12:56:22 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50988 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab2HBQ4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 12:56:21 -0400
Date: Thu, 2 Aug 2012 18:56:30 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Ortwin =?utf-8?B?R2zDvGNr?= <odi@odi.ch>
Cc: linux-kernel@vger.kernel.org, bskeggs@redhat.com,
        dri-devel@lists.freedesktop.org, airlied@redhat.com
Subject: Re: drm/nouveau: crash regression in 3.5
Message-ID: <20120802165630.GA3058@joi.lan>
References: <500ED9EC.5040309@odi.ch>
 <20120724205746.GA8707@joi.lan>
 <500FB279.1020904@odi.ch>
 <20120725184205.GA3119@joi.lan>
 <50113E76.9090706@odi.ch>
 <20120729201532.GA3566@joi.lan>
 <50166D15.7090305@odi.ch>
 <20120730171629.GA3271@joi.lan>
 <50194F7B.7040401@odi.ch>
 <501A63FF.8030503@odi.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <501A63FF.8030503@odi.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 01:26:55PM +0200, Ortwin Glück wrote:
> I have managed to turn the crash into a WARN_ON, by adding this to the 
> begin of nouveau_software_vblank():
> 
>          if (!psw) {
>                  WARN_ON(1);
>                  return;
>          }

Yes, I know about it, but this change fixes only a symptom. We should not get
into this code at all without enabling vblank.

> And I have also managed to load the module manually instead by udev. So 
> I am happy to attach a full log of what's going on here. See also my 
> added printk's starting with XXX that mark some interesting points in 
> the initialization.
> 
> This should give you enough information to track down the cause of the 
> problem. To my non-expert eyes it looks like "noaccel" prevents 
> registration of NVOBJ_ENGINE_SW or at least delays it too much.

Yes, that's what I wrote in my last patch - with noaccel it's not registered,
which leads to NULL pointer derefence.

I'm currently out of ideas why my patch does not work. But I have some ideas
how to debug it. Can you come to nouveau IRC channel at freenode and do some
additional tests? My nick is "joi" and I'm available on IRC between 6pm and
11pm CEST.

Marcin
