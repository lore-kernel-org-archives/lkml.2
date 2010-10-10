Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab0JJKoQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 06:44:16 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:59824 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185Ab0JJKoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 06:44:14 -0400
Subject: Re: [PATCH 3/3] staging: brcm80211: fix to use "%pM" flag to print
 MAC address
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Nohee Ko <noheek@broadcom.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <dc990a5f703e69ed428ac2f2479779d36ef1eb3f.1286705921.git.andy.shevchenko@gmail.com>
References: <86dfcd5dfdee8ce5ca558634d4606922f05e96e1.1286705921.git.andy.shevchenko@gmail.com>
	 <dc990a5f703e69ed428ac2f2479779d36ef1eb3f.1286705921.git.andy.shevchenko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Oct 2010 12:44:10 +0200
Message-ID: <1286707450.3547.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-10 at 13:20 +0300, Andy Shevchenko wrote:

>  char *bcm_ether_ntoa(const struct ether_addr *ea, char *buf)
>  {
> -	static const char template[] = "%02x:%02x:%02x:%02x:%02x:%02x";
> -	snprintf(buf, 18, template,
> -		 ea->octet[0] & 0xff, ea->octet[1] & 0xff, ea->octet[2] & 0xff,
> -		 ea->octet[3] & 0xff, ea->octet[4] & 0xff, ea->octet[5] & 0xff);
> +	snprintf(buf, 18, "%pM", ea->octet);

That's a pretty strange use of snprintf -- just use sprintf if you don't
have a real buffer length.

johannes

