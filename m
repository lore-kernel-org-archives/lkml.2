Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab1F0ScE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 14:32:04 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47799 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab1F0Sb7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 14:31:59 -0400
From: "Grosen, Mark" <mgrosen@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>, Sergei Shtylyov <sshtylyov@mvista.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Arnd Bergmann <arnd@arndb.de>, Brian Swetland <swetland@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [RFC 5/8] remoteproc: add davinci implementation
Thread-Topic: [RFC 5/8] remoteproc: add davinci implementation
Thread-Index: AQHML+P0Hfr3a08OpEW7Q/TK8TF6jpTLaEUAgAB6tVCAARO0AIAACGCAgASPneA=
Date: Mon, 27 Jun 2011 18:31:41 +0000
Message-ID: <FFF198FBBF957F4393BA834040FEFFA202EC99@DFLE35.ent.ti.com>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
	<1308640714-17961-6-git-send-email-ohad@wizery.com>
	<4E035B78.3080200@mvista.com>
	<FFF198FBBF957F4393BA834040FEFFA202D66E@DFLE35.ent.ti.com>
 <4E04A9AE.3030801@mvista.com>
 <B85A65D85D7EB246BE421B3FB0FBB593024D6C2F29@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024D6C2F29@dbde02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Nori, Sekhar
> Sent: Friday, June 24, 2011 8:44 AM
> 
> Hi Mark,

Sekhar, thanks for your feedback and ideas. Comments below.

Mark

> Since procedure to set the boot address varies across DaVinci
> platforms, you could have a callback populated in platform data
> which will be implemented differently for original DaVinci and
> DA8xx devices.

I looked at DM6467 and it's the same as OMAPL13x, except at a different
address. Rather than a callback, it could be just an address in the
platform data.

> 
> Also, all PSC accesses are better off going through clock
> framework to ensure proper locking and modularity.
> 
> To assert/de-assert local reset when enabling or disabling PSC,
> you could use a flag in the clock structure to indicate the need
> for this. This way, if there is any other module needing a local
> reset, it can just define the same flag. Similarly, if the DSP
> does not need a local reset on a particular platform, that
> platform can simply skip the flag.
> 
> This can be done in a manner similar to how the support for
> a forced transition PSC was added here:
> 
> https://patchwork.kernel.org/patch/662941/

Yes, I like this idea - much cleaner. For example, the start() method
becomes (pseudo-code):

start()
{
    /* bootaddrreg derived from platform data */
    bootaddrreg = boot_address;

    clk_enable();
}

Referring to your patch above, would it be better to just pass
the flags into the davinci_psc_config() function rather than breaking out more
arguments for each flag?

Mark
