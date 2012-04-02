Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab2DBUcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 16:32:17 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33389 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887Ab2DBUcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 16:32:15 -0400
Date: Mon, 2 Apr 2012 22:32:11 +0200
From: Borislav Petkov <bp@alien8.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>
Subject: Re: CONFIG_RTLWIFI_DEBUG default y
Message-ID: <20120402203211.GA27889@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Joe Perches <joe@perches.com>
References: <20120402164920.GA13264@x1.osrc.amd.com>
 <1333385618.15422.17.camel@joe2Laptop>
 <20120402171733.GB13264@x1.osrc.amd.com>
 <4F79E5A5.9000004@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4F79E5A5.9000004@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 12:45:09PM -0500, Larry Finger wrote:
> The current situation is fine with me. Any user with an embedded
> system can save a lot of memory by setting CONFIG_RTLWIFI_DEBUG to
> n. If a normal distro chooses to do that, then when some user of
> that distro reports a problem and is unable to run with the module
> parameter "debug=X", I get to say "Sorry, I cannot help you." :)
> 
> Of course, if you want to go through the source and convert every
> instance of "RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, ...)" to the
> equivalent "pr_err(...), then I would probably sign off on it.

I see. Well, I suppose when the driver matures, you're probably going
to remove most of the debugging code yourself because you won't need it
anymore and turn important printk statements into pr_err or pr_info or
whatever.

However, the way it is default y now, people who do 'yes "" | make
oldconfig' will be surprised to see a whole lot of debugging output
spewed from the wireless driver upon next reboot, and I don't think you
want that.

I dunno, maybe CONFIG_DYNAMIC_DEBUG could be of help. There's also a
howto: <Documentation/dynamic-debug-howto.txt>

HTH.

-- 
Regards/Gruss,
    Boris.
