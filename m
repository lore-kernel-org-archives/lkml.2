Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab0C3XDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:03:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753276Ab0C3XDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:03:16 -0400
Date: Tue, 30 Mar 2010 16:02:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: InKi Dae <daeinki@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kyungmin.park@samsung.com
Subject: Re: [PATCH] added S6E63M0 AMOLED LCD Panel driver.
Message-Id: <20100330160257.e5f978a9.akpm@linux-foundation.org>
In-Reply-To: <90b950fc1003252024i5ba8989bg95f0a81e8e5e708e@mail.gmail.com>
References: <90b950fc1003252024i5ba8989bg95f0a81e8e5e708e@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Mar 2010 12:24:24 +0900
InKi Dae <daeinki@gmail.com> wrote:

> +static int s6e63m0_ldi_init(struct s6e63m0 *lcd)
> +{
> +	int ret;
> +
> +	ret = s6e63m0_panel_send_sequence(lcd, SEQ_PANEL_CONDITION_SET);
> +	ret |= s6e63m0_panel_send_sequence(lcd, SEQ_DISPLAY_CONDITION_SET);
> +	ret |= s6e63m0_panel_send_sequence(lcd, SEQ_GAMMA_SETTING);
> +	ret |= s6e63m0_panel_send_sequence(lcd, SEQ_ETC_CONDITION_SET);
> +	ret |= s6e63m0_panel_send_sequence(lcd, SEQ_ACL_ON);
> +	ret |= s6e63m0_panel_send_sequence(lcd, SEQ_ELVSS_ON);
> +
> +	return ret;
> +}

Well.  If one call to s6e63m0_panel_send_sequence() returns -ENOMEM and
another call returns -EIO (for example), this function will return some
other, incorrect errno.

Which is a rather minor problem, unless some caller is explicitly
looking for some particular error code, which doesn't happen often.
