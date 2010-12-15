Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab0LOXXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 18:23:20 -0500
Received: from mail-iw0-f180.google.com ([209.85.214.180]:63823 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab0LOXXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 18:23:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=thL5Pjfgp0RXY/wDErav6GTdt5OwGpBAj7hdUi1nX753Idc+vHQXQ7RYUBJaxYRMyt
         VL5oEy0gtHhNZs8jUwR1TecBPr5uF/9z/i0Y1NIh8N+3MQnaKlkmRI0DcnIMfutA1cmI
         I1vg37YUdWw2u6cGWCyVga6lObYfTVPps24ww=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: Synaptics touchpad on Dell Vostro V13
Date: Wed, 15 Dec 2010 15:23:09 -0800
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5+; KDE/4.5.3; x86_64; ; )
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <alpine.LNX.2.00.1012141547570.15140@pobox.suse.cz> <20101214170027.GA11318@core.coreip.homeip.net> <alpine.LNX.2.00.1012152348440.16569@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1012152348440.16569@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012151523.09476.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 15, 2010 02:51:01 pm Jiri Kosina wrote:
> On Tue, 14 Dec 2010, Dmitry Torokhov wrote:
> > > I have a bugreport about Synaptics touchpad not working as proper
> > > Synaptics, but only being detected as standard PS/2.
> > > 
> > > Looking at the i8042.debug output, the device is clearly buggy, as it
> > > 
> > > doesn't identify itself by 0x47 when queried:
> > > 	91 -> i8042 (command) [58]
> > > 	e8 -> i8042 (parameter) [58]
> > > 	fa <- i8042 (interrupt, 3, 12) [59]
> > > 	91 -> i8042 (command) [59]
> > > 	00 -> i8042 (parameter) [59]
> > > 	fa <- i8042 (interrupt, 3, 12) [59]
> > > 	91 -> i8042 (command) [59]
> > > 	e8 -> i8042 (parameter) [59]
> > > 	fa <- i8042 (interrupt, 3, 12) [60]
> > > 	91 -> i8042 (command) [60]
> > > 	00 -> i8042 (parameter) [60]
> > > 	fa <- i8042 (interrupt, 3, 12) [61]
> > > 	91 -> i8042 (command) [61]
> > > 	e8 -> i8042 (parameter) [61]
> > > 	fa <- i8042 (interrupt, 3, 12) [61]
> > > 	91 -> i8042 (command) [61]
> > > 	00 -> i8042 (parameter) [61]
> > > 	fa <- i8042 (interrupt, 3, 12) [62]
> > > 	91 -> i8042 (command) [62]
> > > 	e8 -> i8042 (parameter) [62]
> > > 	fa <- i8042 (interrupt, 3, 12) [63]
> > > 	91 -> i8042 (command) [63]
> > > 	00 -> i8042 (parameter) [63]
> > > 	fa <- i8042 (interrupt, 3, 12) [64]
> > > 	91 -> i8042 (command) [64]
> > > 	e9 -> i8042 (parameter) [64]
> > > 	fa <- i8042 (interrupt, 3, 12) [64]
> > > 
> > > ... and here we time out after approximately 0.5s. nomux doesn't really
> > > fix it, we start getting a lot of timeouts on i8042 with that.
> > > 
> > > Apparently the device works with Synaptics driver in Other OS(TM)
> > > though. Do you have any idea what they might be doing differently so
> > > that they make the touchpad identify itself properly?
> > 
> > Hi Jiri,
> > 
> > Do you have the device in your possession? If so can you check if the
> > driver installed in Other OS uses active multiplexing? I think you can
> > infer whether it does or not by looking at the pointer properties - I
> > think it would "Synaptics Blah at port X" or something like that...
> 
> Unfortunately I don't have the hardware myself, it's only bugreport that
> reached me. I will check this, thanks.
> 
> > Also you could try combining nomux with reset and see if it makes any
> > sense...
> 
> Yes, I have already had the reporter to do this, but that's even better --
> a lot of commands time out, as you can see below
> 
>  20 -> i8042 (command) [0]
>  47 <- i8042 (return) [0]
>  20 -> i8042 (command) [0]
>  47 <- i8042 (return) [0]
>  60 -> i8042 (command) [0]
>  56 -> i8042 (parameter) [0]
>  d3 -> i8042 (command) [0]
>  5a -> i8042 (parameter) [0]
>  5a <- i8042 (return) [0]
>  a7 -> i8042 (command) [0]
>  20 -> i8042 (command) [0]
>  76 <- i8042 (return) [0]
>  a8 -> i8042 (command) [0]
>  20 -> i8042 (command) [0]
>  56 <- i8042 (return) [0]
>  60 -> i8042 (command) [0]
>  56 -> i8042 (parameter) [0]
>  d3 -> i8042 (command) [0]
>  a5 -> i8042 (parameter) [0]
>  a5 <- i8042 (aux_test_irq, aux) [1]
>  60 -> i8042 (command) [1]
>  74 -> i8042 (parameter) [1]
>  60 -> i8042 (command) [1]
>  56 -> i8042 (parameter) [1]
>  60 -> i8042 (command) [1]
>  47 -> i8042 (parameter) [1]
> serio: i8042 KBD port at 0x60,0x64 irq 1
> serio: i8042 AUX port at 0x60,0x64 irq 12
> mice: PS/2 mouse device common for all mice
>  f2 -> i8042 (kbd-data) [1]
>  fa <- i8042 (interrupt, 0, 1, timeout) [1]
>  ab <- i8042 (interrupt, 0, 1, timeout) [1]
>  83 <- i8042 (interrupt, 0, 1, timeout) [1]
>  ed -> i8042 (kbd-data) [1]
>  fa <- i8042 (interrupt, 0, 1, timeout) [1]
>  00 -> i8042 (kbd-data) [1]
>  fa <- i8042 (interrupt, 0, 1, timeout) [1]
>  f3 -> i8042 (kbd-data) [1]
>  fa <- i8042 (interrupt, 0, 1, timeout) [1]
>  00 -> i8042 (kbd-data) [1]
>  fa <- i8042 (interrupt, 0, 1, timeout) [1]
>  f4 -> i8042 (kbd-data) [1]
>  fa <- i8042 (interrupt, 0, 1, timeout) [1]
> input: AT Translated Set 2 keyboard as
> /devices/platform/i8042/serio0/input/input0 d4 -> i8042 (command) [2]
>  f2 -> i8042 (parameter) [2]
>  fa <- i8042 (interrupt, 1, 12, timeout) [2]
>  00 <- i8042 (interrupt, 1, 12, timeout) [3]
>  60 -> i8042 (command) [3]
>  45 -> i8042 (parameter) [3]
>  60 -> i8042 (command) [3]
>  47 -> i8042 (parameter) [3]
>  d4 -> i8042 (command) [3]
>  f2 -> i8042 (parameter) [3]
>  fa <- i8042 (interrupt, 1, 12, timeout) [4]
>  60 -> i8042 (command) [4]
>  45 -> i8042 (parameter) [4]
>  60 -> i8042 (command) [4]
>  47 -> i8042 (parameter) [4]
>  00 <- i8042 (interrupt, 1, 12, timeout) [5]
> 
> ...
> 
>  f3 -> i8042 (kbd-data) [6323]
>  fa <- i8042 (interrupt, 0, 1, timeout) [6323]
>  20 -> i8042 (kbd-data) [6323]
>  fa <- i8042 (interrupt, 0, 1, timeout) [6323]
>  2d <- i8042 (interrupt, 0, 1, timeout) [10631]
>  10 <- i8042 (interrupt, 0, 1, timeout) [10669]
>  ad <- i8042 (interrupt, 0, 1, timeout) [10674]
>  90 <- i8042 (interrupt, 0, 1, timeout) [10692]
>  2f <- i8042 (interrupt, 0, 1, timeout) [10737]
>  af <- i8042 (interrupt, 0, 1, timeout) [10760]
>  17 <- i8042 (interrupt, 0, 1, timeout) [10922]
>  97 <- i8042 (interrupt, 0, 1, timeout) [10945]
>  12 <- i8042 (interrupt, 0, 1, timeout) [10998]
>  92 <- i8042 (interrupt, 0, 1, timeout) [11025]
>  13 <- i8042 (interrupt, 0, 1, timeout) [11317]
>  93 <- i8042 (interrupt, 0, 1, timeout) [11345]
>  1c <- i8042 (interrupt, 0, 1, timeout) [11422]
>  9c <- i8042 (interrupt, 0, 1, timeout) [11449]
>  31 <- i8042 (interrupt, 0, 1, timeout) [11672]
>  b1 <- i8042 (interrupt, 0, 1, timeout) [11697]
>  18 <- i8042 (interrupt, 0, 1, timeout) [11704]
>  98 <- i8042 (interrupt, 0, 1, timeout) [11729]
>  2f <- i8042 (interrupt, 0, 1, timeout) [11800]
>  af <- i8042 (interrupt, 0, 1, timeout) [11821]
>  12 <- i8042 (interrupt, 0, 1, timeout) [11842]
>  92 <- i8042 (interrupt, 0, 1, timeout) [11866]
>  27 <- i8042 (interrupt, 0, 1, timeout) [11951]
>  a7 <- i8042 (interrupt, 0, 1, timeout) [11969]
>  0e <- i8042 (interrupt, 0, 1, timeout) [12061]
>  8e <- i8042 (interrupt, 0, 1, timeout) [12089]
>  26 <- i8042 (interrupt, 0, 1, timeout) [12169]
>  a6 <- i8042 (interrupt, 0, 1, timeout) [12187]
>  26 <- i8042 (interrupt, 0, 1, timeout) [12207]
>  a6 <- i8042 (interrupt, 0, 1, timeout) [12227]
>  1c <- i8042 (interrupt, 0, 1, timeout) [12428]
>  9c <- i8042 (interrupt, 0, 1, timeout) [12456]
> 
> ... and a lot of other timeouts.

Hmm, and what happens if you force dfl = 0 in i8042_interrupt()? It looks
like controller FW screwed up...

> 
> If the device wouldn't work with Synaptics driver in other OS, I'd just
> claim the device to be broken behind hope and be done with this, but this
> makes me really wonder what they do differently.
> 
> Are you aware of any means of i8042 debugging/sniffing facility in the
> other OS that could be used? :)

KVM + serio_raw but someone needs to write the glue...

-- 
Dmitry
