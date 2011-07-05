Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab1GEFaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 01:30:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57535 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157Ab1GEFau convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 01:30:50 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: "Grosen, Mark" <mgrosen@ti.com>, Sergei Shtylyov <sshtylyov@mvista.com>
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
Date: Tue, 5 Jul 2011 10:59:46 +0530
Subject: RE: [RFC 5/8] remoteproc: add davinci implementation
Thread-Topic: [RFC 5/8] remoteproc: add davinci implementation
Thread-Index: AQHML+P0Hfr3a08OpEW7Q/TK8TF6jpTLaEUAgAB6tVCAARO0AIAACGCAgASPneCAC7mBkA==
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024D91A2BE@dbde02.ent.ti.com>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
	<1308640714-17961-6-git-send-email-ohad@wizery.com>
	<4E035B78.3080200@mvista.com>
	<FFF198FBBF957F4393BA834040FEFFA202D66E@DFLE35.ent.ti.com>
 <4E04A9AE.3030801@mvista.com>
 <B85A65D85D7EB246BE421B3FB0FBB593024D6C2F29@dbde02.ent.ti.com>
 <FFF198FBBF957F4393BA834040FEFFA202EC99@DFLE35.ent.ti.com>
In-Reply-To: <FFF198FBBF957F4393BA834040FEFFA202EC99@DFLE35.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Jun 28, 2011 at 00:01:41, Grosen, Mark wrote:
> > From: Nori, Sekhar
> > Sent: Friday, June 24, 2011 8:44 AM

> > To assert/de-assert local reset when enabling or disabling PSC,
> > you could use a flag in the clock structure to indicate the need
> > for this. This way, if there is any other module needing a local
> > reset, it can just define the same flag. Similarly, if the DSP
> > does not need a local reset on a particular platform, that
> > platform can simply skip the flag.
> > 
> > This can be done in a manner similar to how the support for
> > a forced transition PSC was added here:
> > 
> > https://patchwork.kernel.org/patch/662941/
> 
> Yes, I like this idea - much cleaner. For example, the start() method
> becomes (pseudo-code):
> 
> start()
> {
>     /* bootaddrreg derived from platform data */
>     bootaddrreg = boot_address;
> 
>     clk_enable();
> }
> 
> Referring to your patch above, would it be better to just pass
> the flags into the davinci_psc_config() function rather than breaking out more
> arguments for each flag?

I did dwell on this quite a bit while writing that
patch, but finally decided on passing an argument
instead since I was not sure if there are going
to be more modifiers required.

Now that you have the need for one more flag, I
think we should go ahead and pass the flags directly
to davinci_psc_config(). My original patch is not
upstream yet. I will re-spin it and you can build
on top of it.

Thanks,
Sekhar

