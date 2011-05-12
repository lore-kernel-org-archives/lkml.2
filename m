Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab1ELIbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 04:31:40 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:40381 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab1ELIbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 04:31:39 -0400
Subject: Re: [PATCH v2] net: rfkill: add generic gpio rfkill driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Rhyland Klein <rklein@nvidia.com>
Cc: olof@lixom.net, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1305159661-11982-1-git-send-email-rklein@nvidia.com>
References: <1305159661-11982-1-git-send-email-rklein@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 10:31:32 +0200
Message-ID: <1305189092.3461.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 17:21 -0700, Rhyland Klein wrote:

> +enum rfkill_gpio_clk_state {
> +	UNSPECIFIED = 0,
> +	PWR_ENABLED,
> +	PWR_DISABLED

Are you sure starting out with UNSPECIFIED works? Then you'll always
change, but if the clock was enabled already you still enable it on the
first set_block() from rfkill, which still has the refcount problem, no?
It seems to me that the original state has to be passed in from the
platform?

johannes

