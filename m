Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab2LLQfD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 11:35:03 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:1909 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab2LLQfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 11:35:00 -0500
Date: Wed, 12 Dec 2012 17:34:44 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: i2c-hid: add mutex protecting open/close race
Message-ID: <20121212173444.471d5cc6@endymion.delvare>
In-Reply-To: <1355328736-31418-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1355328736-31418-1-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

On Wed, 12 Dec 2012 17:12:16 +0100, Benjamin Tissoires wrote:
> We should not enter close function while someone else is in open.
> This mutex prevents this race.
> 
> There is also no need to override the ret value with -EIO in case of
> a failure of i2c_hid_set_power.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---

Looks good to me except that you forgot to include <linux/mutex.h> and
this could cause build failures on some architectures/configs.

Once this is fixed, you can add:

Reviewed-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
