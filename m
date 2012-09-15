Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab2IOQPW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 12:15:22 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64453 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab2IOQPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 12:15:20 -0400
Date: Sat, 15 Sep 2012 18:15:18 +0200
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>, Bryan Wu <bryan.wu@canonical.com>
Subject: Re: [PATCH] leds: add led_trigger_rename function
Message-ID: <20120915161518.GA1687@gmail.com>
References: <1347204474-1694-1-git-send-email-fabio.baltieri@gmail.com>
 <20120910135535.GA2405@vandijck-laurijssen.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120910135535.GA2405@vandijck-laurijssen.be>
X-Operating-System: Linux balto-eee 3.6.0-rc3-balto-eee-00471-g4379212-dirty
 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kurt,

On Mon, Sep 10, 2012 at 03:55:35PM +0200, Kurt Van Dijck wrote:
> > 
> > This also implies that "name" in "struct led_trigger" is not const
> > anymore.
> IMHO, this is wrong. This forces all other led_triggers
> to put their name in non-const storage.

I had a second check on the patch and now I see your point.

> I see 2 options here:
> * let 'name' be a 'const char *', and do a typecast.
>   This works as long as led_trigger_rename is called only on led_triggers
>   with non-const 'name' storage.
> * put the storage of trigger name inside struct led_trigger conditionally
>   (like can_dev does with their echo_skb), and when calling
>   led_trigger_rename(), test if 'name' points to that storage.
> 
> Maybe there are other possibilities.

Modifying other driver would involve some useless kstrdup on constant
strigs or another unsafe casting, so I prefer to cast here in that case.

I'll send a v2 with the first solution you proposed, but I don't see a
really clean implementation here.

Any better idea?

Fabio

-- 
Fabio Baltieri
