Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab2DPSBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 14:01:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36097 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab2DPSBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 14:01:34 -0400
Message-ID: <4F8C5E7A.9090705@wwwdotorg.org>
Date: Mon, 16 Apr 2012 12:01:30 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: Sascha Hauer <s.hauer@pengutronix.de>, Dong Aisheng <dongas86@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com
Subject: Re: [PATCH 1/3] pinctrl: pinctrl-imx: add imx pinctrl core driver
References: <1334333915-1174-1-git-send-email-b29396@freescale.com> <20120414134814.GA3852@pengutronix.de> <CAA+hA=T0FAfuGKcW0vAKO+OWyFdM-6vQqVo53xKf8y28m7gPOQ@mail.gmail.com> <20120415141736.GG24997@S2101-09.ap.freescale.net> <20120415172958.GG20478@pengutronix.de> <20120416014720.GH24997@S2101-09.ap.freescale.net>
In-Reply-To: <20120416014720.GH24997@S2101-09.ap.freescale.net>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2012 07:47 PM, Shawn Guo wrote:
> On Sun, Apr 15, 2012 at 07:29:58PM +0200, Sascha Hauer wrote:
> ...
>> How far are we away from getting macro support? Do we already agree that we
>> want to have such a feature? I remember I saw someone mentioning it,
>> maybe even by piping the devicetree though CPP, but I didn't follow the
>> further discussion.
>>
> My understanding is we agree that we want to have this feature, and
> are approaching it slowly, but I do not have the exact status.
> Stephen may want to give an update, please?

The status is:

* I proposed a "/define/ var 5" syntax to dtc.

* It was at least temporarily rejected because it wasn't clear whether
that syntax would fit into whatever future expression/language/...
support dtc might acquire in the future.

* However, there has been a long-standing impasse on defining what the
future expression/language/... support in dtc will look like.

* In an attempt to move that forward, I took one of David Gibson's old
integer expressions patches (that allows math within cells in
properties), updated that to ToT, and now it's checked in. This only
allows match with literals, not variables/symbols/..., but is hopefully
a step in the right direction.

* The next step is to revisit my /define/ patch on top of the integer
expressions patch. Perhaps the presence of integer expressions is enough
to know whether /define/ is a reasonable syntax, perhaps not. We'll have
to see when I update and repost it.

In summary: There is some progress, but it's slow. I wouldn't rely on
seeing /define/ or similar support in dtc in any particular near-term
timescale.
