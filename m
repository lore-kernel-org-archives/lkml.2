Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab1IWX1H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 19:27:07 -0400
Received: from smtp-out.google.com ([216.239.44.51]:24151 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab1IWX1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 19:27:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=Fh8AGUogKOXHT/qku1c5706w3Z2kQ+pKhQAtqrtU8IuFPy26rLWK+9aZ2W0azlJKT
	mwtniolgPrsX8gY6w2fBQ==
Date: Fri, 23 Sep 2011 16:26:43 -0700
From: Andrew Morton <akpm@google.com>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: rpurdie@rpsys.net, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] leds: set LEDS_TRIGGERS as tristate
Message-Id: <20110923162643.d3505bf7.akpm@google.com>
In-Reply-To: <1315259762-9034-1-git-send-email-bryan.wu@canonical.com>
References: <1315259762-9034-1-git-send-email-bryan.wu@canonical.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  6 Sep 2011 05:56:02 +0800
Bryan Wu <bryan.wu@canonical.com> wrote:

> LEDS_TRIGGERS is depends on LEDS_CLASSS, which should be tristate. So
> set it as tristate too and update header files as well.
> 

Another allmodconfig failure:

drivers/built-in.o: In function `led_trigger_blink':
(.text+0x119206): undefined reference to `led_blink_set'
drivers/built-in.o: In function `led_trigger_set':
(.text+0x119389): undefined reference to `led_brightness_set'

I *think* it will be caused by this patch.  I'll drop it and see :(
