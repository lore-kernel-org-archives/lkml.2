Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917Ab1GTWEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 18:04:44 -0400
Received: from mail.perches.com ([173.55.12.10]:4207 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536Ab1GTWEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 18:04:43 -0400
Subject: Re: [PATCH] rtlwifi: Convert printks to pr_<level>
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4E27048F.9090004@lwfinger.net>
References: <b57f00fc1d0947443aa1830c11c288e78924af44.1311177059.git.joe@perches.com>
	 <4E27048F.9090004@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jul 2011 15:04:42 -0700
Message-ID: <1311199482.1663.13.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-20 at 11:38 -0500, Larry Finger wrote:
> On 07/20/2011 10:51 AM, Joe Perches wrote:
> > Use the current logging styles.
> > Add pr_fmt where appropriate.
> > Remove now unnecessary prefixes from printks.
> > Convert hard coded prefix to __func__.
> > Add a missing "\n" to a format.
[]
> In general these look good, but why not define pr_fmt in rtlwifi/wifi.h. That 
> header is used by every source file, and you only need the define once.

Because that's not the first #include in every file.

The #define pr_fmt has to be before anything that
includes kernel.h so it's safest/best to have it
be the first thing in the file.

At some point in the next year or so, all of the
uses of:

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

should be removed and that should become the default.

cheers, Joe

