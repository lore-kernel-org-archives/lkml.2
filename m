Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab2GEQEF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 12:04:05 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55447 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab2GEQEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 12:04:02 -0400
Message-ID: <4FF5BAEE.3020403@wwwdotorg.org>
Date: Thu, 05 Jul 2012 10:03:58 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Alex Courbot <acourbot@nvidia.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] pwm-backlight: add regulator and GPIO support
References: <20120704104840.GJ24458@pengutronix.de> <4FF43692.2040805@nvidia.com> <20120704130056.GC30009@pengutronix.de> <4FF45DDF.9000306@nvidia.com> <20120704152451.GA7333@sirena.org.uk> <4FF4FDC0.8020405@nvidia.com> <20120705062011.GI30009@pengutronix.de> <4FF53368.6090805@nvidia.com> <20120705064742.GL30009@pengutronix.de> <4FF5459F.5090201@nvidia.com> <20120705075714.GA26428@avionic-0098.mockup.avionic-design.de> <4FF54C6C.1060700@nvidia.com>
In-Reply-To: <4FF54C6C.1060700@nvidia.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2012 02:12 AM, Alex Courbot wrote:
> On 07/05/2012 04:57 PM, Thierry Reding wrote:
>> I agree. Non-DT platforms have always used the callbacks to execute this
>> kind of code. As you've said before there are situations where it isn't
>> just about setting a GPIO or enabling a regulator but it also requires a
>> specific timing. Representing this in the platform data would become
>> tedious.
> 
> That will settle the whole issue then.
> 
>> So I think for the DT case you can parse the power-on and power-off
>> sequences directly and execute code based on it, while in non-DT cases
>> the init and exit callbacks should be used instead. I think it even
>> makes sense to reuse the platform data's init and exit functions in the
>> DT case and implement the parser/interpreter within those.
> 
> It totally makes sense indeed.

I don't agree here. It'd be best if non-DT and DT cases worked as
similarly as possible. Relying on callbacks in one case and
data-parsed-from-DT in the other isn't consistent with that. After all,
in the DT case, you parse some data out of the DT and into some data
structure. In the non-DT case, you can have that data structure passed
in directly using platform data. Now, there's certainly a need to
continue to support callbacks for backwards compatibility, at the very
least temporarily before all clients are converted to the new model, but
requiring different models rather than simply allowing it seems like a
bad idea to me.


