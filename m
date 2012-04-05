Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab2DEOgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 10:36:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60218 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab2DEOgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 10:36:52 -0400
Message-ID: <4F7DAE00.6010101@gmail.com>
Date: Thu, 05 Apr 2012 23:36:48 +0900
From: Akio Idehara <zbe64533@gmail.com>
MIME-Version: 1.0
To: seth.forshee@canonical.com
CC: mjg59@srcf.ucam.org, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] toshiba_acpi: Add support for transflective LCD
References: <1333551646-4575-1-git-send-email-zbe64533@gmail.com> <20120404183758.GA17327@thinkpad-t410>
In-Reply-To: <20120404183758.GA17327@thinkpad-t410>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seth Forshee wrote:

> I'm still not crazy about the name. And really I think if
> get_tr_backlight_status() is going to return an error code, when it
> fails the return value should be propogated (even if it's the same in
> this case). How about this?


Thank you for your suggestion.  I agree with you.  I'll try to make a
new patch again.

>>  static const struct backlight_ops toshiba_backlight_data = {
>> +	.options	= BL_CORE_SUSPENDRESUME,
> 
> What's the reason for adding this? I don't see that it's useful unless
> we're handling BL_CORE_SUSPENDED, which toshiba_acpi is not doing.


The reason is to restore transflective status, which is always disabled
after resuming.  If BL_CORE_SUSPENDRESUME is added,
set_lcd_state_status() is called from backlight_update_status() with
stored brightness. So, when its brightness is 0, transflective status is
enabled after resuming.


Best Regards,
Akio
