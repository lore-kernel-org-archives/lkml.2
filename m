Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab1E2Ouj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 10:50:39 -0400
Received: from host171.canaca.com ([67.55.55.225]:40771 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab1E2Ouh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 10:50:37 -0400
Message-ID: <a49670b80c887da1f9224080e9e62f32.squirrel@host171.canaca.com>
In-Reply-To: <201105290846.59531.michael@m-bauer.org>
References: <201105282037.22888.michael@m-bauer.org>
    <fd06492f61f15697eb1c8400e29ec7bd.squirrel@host171.canaca.com>
    <8942e3cdf4941912b0855e64939e5939.squirrel@host171.canaca.com>
    <201105290846.59531.michael@m-bauer.org>
Date: Sun, 29 May 2011 10:50:35 -0400
Subject: Re: [PATCH] hid: Fix Logitech Driving Force Pro wheel
From: simon@mungewell.org
To: "Michael Bauer" <michael@m-bauer.org>
Cc: linux-input@vger.kernel.org, simon@mungewell.org,
        linux-kernel@vger.kernel.org, "Jiri Kosina" <jkosina@suse.cz>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Often the control assignement works like this: User clicks "set axis for
> acceleration", application asks "please move the desired axis" and then
> automatically choses the "moving" axis.
> If we report both combined and separate at the same time, the application
> will
> have a hard time deciding which one to use, as they both will change their
> values.
>

Fair enough, I played a little trying to massage the original descriptor
but could not find a sensible solution - so I guess we'll have to provide
a full replacement.

I don't see the need to comment the original/replacement blocks, so
probably a simple 'hex block' would be good.

Regarding the replacement, you appear to have a lot of unnecessary code
there. You could try with something like:
--
...
+0x09, 0x39,         /*          Usage (Hat Switch),             */
+0x81, 0x42,         /*          Input (Variable),               */
+0x75, 0x08,         /*          Report Size (8),                */
+0x95, 0x08,         /*          Report Count (1),               */
+0x65, 0x00,         /*          Unit,                           */
+0x06, 0x00, 0xFF,   /*          Usage Page (FF00h),             */
+0x26, 0xFF, 0x00,   /*          Logical Maximum (255),          */
+0x46, 0xFF, 0x00,   /*          Physical Maximum (255),         */
+0x09, 0x01,         /*          Usage (01h),                    */
+0x81, 0x02,         /*          Input (Variable),               */
+0xA4,               /*          Push,                           */
+0x05, 0x01,         /*          Usage Page (Desktop),           */
+0x95, 0x01,         /*          Report Count (2),               */
+0x09, 0x31,         /*          Usage (Y),                      */
+0x09, 0x35,         /*          Usage (Rz),                     */
+0x81, 0x02,         /*          Input (Variable),               */
+0xB4,               /*          Pop,                            */
+0x81, 0x02,         /*          Input (Variable),               */
+0xC0,               /*      End Collection,                     */
...
--

Cheers,
Simon.

