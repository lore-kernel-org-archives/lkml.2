Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743Ab2HVH5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 03:57:12 -0400
Received: from webbox1416.server-home.net ([77.236.96.61]:57346 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757490Ab2HVH5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 03:57:10 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Feng Tang <feng.tang@intel.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: Re: i2c-eg20t: regression since i2c_add_numbered_adapter change
Date: Wed, 22 Aug 2012 09:57:07 +0200
Message-ID: <3514180.RWySLZuOJm@ws-stein>
User-Agent: KMail/4.8.5 (Linux/3.3.8-gentoo; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20120822152918.3e59616e@feng-i7>
References: <4401854.hVfHzgeqjT@ws-stein> <20120822152918.3e59616e@feng-i7>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wednesday 22 August 2012 15:29:18, Feng Tang wrote:
> On Wed, 22 Aug 2012 08:30:35 +0200
> Alexander Stein <alexander.stein@systec-electronic.com> wrote:
> 
> > Hello,
> > 
> > I just noticed the 3.4 linux kernel fails to sucessfully probe the i2c-eg20t 
> > driver. I returns with EBUSY error. It worked on the 3.0 kernel. To my view it 
> > is caused the commit 07e8a51ff68353e01d795cceafbac9f54c49132b ( i2c-eg20t: use 
> > i2c_add_numbered_adapter to get a fixed bus number).
> > The reason it actually fails is that the i2c-isch driver is registered 
> > beforehand which gets bus number 0. But this one is the bus number the eg20t 
> > driver wants to register.
> 
> Make sense.
> 
> > A possibility is that if i2c_add_numbered_adapter failed with EBUSY just use 
> > i2c_add_adapter to get at least the driver working, but with a non-fixed bus 
> > number. Opinions?
> 
> Or can we give it a fixed offset, like let the i2c_eg20t controller bus number
> start with 4? I don't expect there will be more than 4 other i2c controllers 
> on EG20T compatible platforms.

Why use a fixed one? Give the driver (and maybe every i2c bus driver) a parameter which sets the base bus number it should use.
E.g. i2c-eg20t.base-bus-num=2 so it will register the bus numbers starting from 2. If this parameter is unset. It would use the first free one, thus simply using i2c_add_adapter.

Regards,
Alexander
