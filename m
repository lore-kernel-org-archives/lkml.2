Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab1E3GRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 02:17:08 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.98]:40339 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab1E3GRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 02:17:06 -0400
From: Michael Bauer <michael@m-bauer.org>
To: linux-input@vger.kernel.org
Subject: Re: [PATCH] hid: Fix Logitech Driving Force Pro wheel
Date: Mon, 30 May 2011 08:17:15 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39-logitech; KDE/4.6.3; x86_64; ; )
Cc: simon@mungewell.org, linux-kernel@vger.kernel.org,
        "Jiri Kosina" <jkosina@suse.cz>
References: <201105282037.22888.michael@m-bauer.org> <201105290846.59531.michael@m-bauer.org> <a49670b80c887da1f9224080e9e62f32.squirrel@host171.canaca.com>
In-Reply-To: <a49670b80c887da1f9224080e9e62f32.squirrel@host171.canaca.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105300817.15986.michael@m-bauer.org>
X-Df-Sender: michael@m-bauer.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

> Fair enough, I played a little trying to massage the original descriptor
> but could not find a sensible solution - so I guess we'll have to provide
> a full replacement.
Yes, i also spent some time but it does not seem to be possible in a sensible 
way.
 
> I don't see the need to comment the original/replacement blocks, so
> probably a simple 'hex block' would be good.
Fine for me, i will remove it in the next patch.

> Regarding the replacement, you appear to have a lot of unnecessary code
> there. You could try with something like:
> --
> ...
> +0x09, 0x39,         /*          Usage (Hat Switch),             */
> +0x81, 0x42,         /*          Input (Variable),               */
> +0x75, 0x08,         /*          Report Size (8),                */
> +0x95, 0x08,         /*          Report Count (1),               */
> +0x65, 0x00,         /*          Unit,                           */
> +0x06, 0x00, 0xFF,   /*          Usage Page (FF00h),             */
> +0x26, 0xFF, 0x00,   /*          Logical Maximum (255),          */
> +0x46, 0xFF, 0x00,   /*          Physical Maximum (255),         */
> +0x09, 0x01,         /*          Usage (01h),                    */
> +0x81, 0x02,         /*          Input (Variable),               */
> +0xA4,               /*          Push,                           */
> +0x05, 0x01,         /*          Usage Page (Desktop),           */
> +0x95, 0x01,         /*          Report Count (2),               */
> +0x09, 0x31,         /*          Usage (Y),                      */
> +0x09, 0x35,         /*          Usage (Rz),                     */
> +0x81, 0x02,         /*          Input (Variable),               */
> +0xB4,               /*          Pop,                            */
> +0x81, 0x02,         /*          Input (Variable),               */
> +0xC0,               /*      End Collection,                     */
> ...
> --

Good point - didn't think of the Push/Pop commands... 

I will create an updated patch and submit it here again.

Thanks and regards
Michael
