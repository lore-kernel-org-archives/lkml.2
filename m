Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab2GQBKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 21:10:48 -0400
Received: from mail.active-venture.com ([67.228.131.205]:49893 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab2GQBKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 21:10:47 -0400
X-Originating-IP: 108.223.40.66
Date: Mon, 16 Jul 2012 18:10:51 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH 1/2] hwmon: (applesmc) Allow negative
 temperature values
Message-ID: <20120717011051.GA22234@roeck-us.net>
References: <1342423091-330-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342423091-330-1-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 09:18:10AM +0200, Henrik Rydberg wrote:
> There are many userland reports of sensors with unreasonably small and
> large temperatures. There seem to be several reasons for this:
> 
> Firstly, the major sensor type (sp78) is actually a signed number.
> This explains why some sensors show very small or large values - they
> are in fact all small, but of different sign.
> 
> Secondly, the other sensor type (1-hex) is not properly understood; it
> may be that it is not a temperature after all.
> 
> Thirdly, some sensors are differential in nature, showing changes over
> time rather than absolute numbers.  This explains why those values are
> small and of varying sign.
> 
> This patch interprets the sp78 type as signed short, but keeps the
> original scaling. For other types, -EINVAL is returned, since the
> nature of those sensors is unknown.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---

Applied to -next.

Thanks,
Guenter
