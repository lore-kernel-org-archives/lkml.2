Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab1HFVi0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 17:38:26 -0400
Received: from sirokuusama.dnainternet.net ([83.102.40.133]:56701 "EHLO
	sirokuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755378Ab1HFViY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 17:38:24 -0400
X-Greylist: delayed 393 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Aug 2011 17:38:24 EDT
X-Spam-Flag: NO
X-Spam-Score: -1
Message-ID: <4E3DB2C2.7040104@iki.fi>
Date: Sun, 07 Aug 2011 00:31:46 +0300
From: Anssi Hannula <anssi.hannula@iki.fi>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110626 Mageia/3.1.11-2.mga2 (2) Thunderbird/3.1.11
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Input: ati_remote - extend keytable for medion remotes
References: <20110418104108.GA4876@atlantis.wh2.tu-dresden.de.de> <20110418104547.GB4876@atlantis.wh2.tu-dresden.de.de> <20110525163204.GD22517@core.coreip.homeip.net>
In-Reply-To: <20110525163204.GD22517@core.coreip.homeip.net>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.05.2011 19:32, Dmitry Torokhov wrote:
> Hi Jan,
> 
> On Mon, Apr 18, 2011 at 12:45:47PM +0200, Jan Losinski wrote:
>> This extends the ati_remote to support multiple keytables. The table
>> will be selected with the productId of the device.
>>
>> It also provides a table for the medion rf remote control that enables
>> all buttons on it.
>>
> 
> I am not a big fan of static keymaps in kernel drivers and would much
> more prefer driver supporting adjusting keymaps via EVIOCSKEYCODE
> ioctls. Unfortunately ati_remote key handling code is kind of involved
> and I am not sure what is the best way of wiring it up.
> 
> I believe Anssi Hannula (CCed) mentioned that he has a version of
> ati_remove ported to rc-core infrastructure that supports such
> remapping. Anssi, could you tell me what is the status of that driver?
> Is it usable with rc-core?

Sorry, it seems for some reason I didn't receive your message via CC and
only now saw it while looking at linux-input@ messages.

Indeed I have a patchset that makes it work with rc-core which I didn't
get around to posting yet (sorry about that).

I'll try to look over it now and do some more testing, and then post the
set.

Some notes about the patchset:
- The mouse handling is left as-is, and it now appears as a separate
  input device (that part of the keymap is the same for all remotes
  with mouse). The mouse device is created regardless of receiver,
  in case another type of remote is used with the receiver.
- The driver sends rc_keyup immediately after every rc_keydown, as that
  is what the driver has always done for input events as well. Doing
  otherwise would cause a regression as ghost repeats would appear
  with this driver while they didn't before.

-- 
Anssi Hannula
