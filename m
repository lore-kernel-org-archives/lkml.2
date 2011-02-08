Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab1BHDHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 22:07:32 -0500
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.185]:28162
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752762Ab1BHDHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 22:07:31 -0500
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Feb 2011 22:07:30 EST
X-SpamScore: -9
X-BigFish: VPS-9(zzbb2dK98dNzz1202hzzz2fh2a8h637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4D50AFD0.9020704@am.sony.com>
Date: Mon, 7 Feb 2011 18:52:00 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        <linux-embedded@vger.kernel.org>
Subject: Re: [PATCH] PM: Hide CONFIG_PM from users
References: <1297081335-13631-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1297081335-13631-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/11 04:22, Mark Brown wrote:
> It is very rare to find a current system which is both sufficiently
> resource constrained to want to compile out power management support
> and sufficiently power insensitive to be able to tolerate doing so.
> Since having the configuration option requires non-zero effort to
> maintain, with ifdefery in most drivers, but it is used with vanishing
> rarity it is simpler to just remove the option.

Proof by assertion that it is used with vanishing rarity.

> Begin doing so by hiding it from users - this should attract complaints
> from any active users. The option is left disabled for the IA64 Ski
> simulator which is a partial simulator for IA64 systems mostly missing
> device support. This is a very limited use case which is unlikely to
> ever want to enable most drivers.

That is not a good method of getting feedback from users.

 1) It immediately removes the ability to have CONFIG_PM undefined,
    without first giving active users a chance to provide feedback.

 2) The removal of that ability is not obvious ("make oldconfig" does
    not say anything about CONFIG_PM).  It is easy to overlook a
    config change that happens silently.

 3) The active users may not move to a newer version of the kernel
    that contains this change until after it has been decided that
    there are no users of the config option since no one complained
    in a timely manner.

Would it be appropriate to use Documentation/feature-removal-schedule.txt
if this truly will be removed?

-Frank

