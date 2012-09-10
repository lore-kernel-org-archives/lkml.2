Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab2IJNzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 09:55:40 -0400
Received: from mx01.eia.be ([195.130.156.18]:46484 "EHLO mail.eia.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753Ab2IJNzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 09:55:39 -0400
Date: Mon, 10 Sep 2012 15:55:35 +0200
From: Kurt Van Dijck <kurt.van.dijck@eia.be>
To: Fabio Baltieri <fabio.baltieri@gmail.com>
CC: <linux-leds@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>, Bryan Wu <bryan.wu@canonical.com>
Subject: Re: [PATCH] leds: add led_trigger_rename function
Message-ID: <20120910135535.GA2405@vandijck-laurijssen.be>
Mail-Followup-To: Fabio Baltieri <fabio.baltieri@gmail.com>,
	linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
	Richard Purdie <rpurdie@rpsys.net>,
	Bryan Wu <bryan.wu@canonical.com>
References: <1347204474-1694-1-git-send-email-fabio.baltieri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1347204474-1694-1-git-send-email-fabio.baltieri@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Fabio,

On Sun, Sep 09, 2012 at 05:27:54PM +0200, Fabio Baltieri wrote:
> Implements a led_trigger_rename() function to rename a trigger with
> proper locking.
This is the way to go.
Maybe add 'default_trigger' tests? In a later phase?

> 
> This also implies that "name" in "struct led_trigger" is not const
> anymore.
IMHO, this is wrong. This forces all other led_triggers
to put their name in non-const storage.

I see 2 options here:
* let 'name' be a 'const char *', and do a typecast.
  This works as long as led_trigger_rename is called only on led_triggers
  with non-const 'name' storage.
* put the storage of trigger name inside struct led_trigger conditionally
  (like can_dev does with their echo_skb), and when calling
  led_trigger_rename(), test if 'name' points to that storage.

Maybe there are other possibilities.

The latter is the safe way to do, but takes a bit more code.
The first way is a quick one ...

Kind regards,
Kurt
