Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab0LFBx7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 20:53:59 -0500
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:47971 "HELO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751732Ab0LFBx6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 20:53:58 -0500
From: Philip Rakity <prakity@marvell.com>
To: Chris Ball <cjb@laptop.org>
CC: Takashi Iwai <tiwai@suse.de>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Aries Lee <arieslee@jmicron.com>
Date: Sun, 5 Dec 2010 17:53:49 -0800
Subject: Re: [PATCH 2/2] mmc: Test bus-width for old MMC devices
Thread-Topic: [PATCH 2/2] mmc: Test bus-width for old MMC devices
Thread-Index: AcuU6G3bOmnn+ovjTAuuMpfnK2VFig==
Message-ID: <D8F224E6-5973-4CCB-97BC-0CE6102B4F6F@marvell.com>
References: <1290579674-4616-1-git-send-email-tiwai@suse.de>
 <1290579674-4616-3-git-send-email-tiwai@suse.de>
 <20101205040221.GA24547@void.printf.net> <s5h1v5wv6gv.wl%tiwai@suse.de>
 <20101205184031.GA30957@void.printf.net>
In-Reply-To: <20101205184031.GA30957@void.printf.net>
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


Chris,

One other difference I have been told between the patches but NOT verified is

a) Takasi code was not tested with Dual Data Rate

b) Performance is not an issue since we are dealing with uSeconds and the code is called once
when mmc is detected.  

c)  I will adapt my code to what Takahi did over the next few days and post changes to the CAP

d) The work was independent and done at the same time !! (amazing)


On Dec 5, 2010, at 10:40 AM, Chris Ball wrote:

> Hi Takashi, Philip,
> 
> On Sun, Dec 05, 2010 at 11:50:40AM +0100, Takashi Iwai wrote:
>>> I'm planning on taking Takashi's since it looks a little cleaner; Philip,
>>> please could you take a look at Takashi's patch and add anything you
>>> think should be present from your own patch as a new incremental patch?
>> 
>> One missing thing in my (originally Aries') patch is the quirk bit to
>> enable/disable the bus-width test.  In Philip's latest patch, the
>> default is off.
>> 
>> I'm also not sure whether this bus-width test should be enabled as
>> default.  I guess it's better for performance, so I'd vote for turning
>> on as default.  But, having a quirk for turning off would be safer for
>> working around old hardware problems, of course.
> 
> Sounds good, although we're trying hard not to add new quirk bits.
> I don't see a way around doing that here, though.
> 
> We've got plenty of time until the .38 release -- let's turn it on by
> default and test during .38-rc, and we can revisit whether to leave it
> on closer to the release.  It's not as simple as "turning it on could
> cause problems so let's not do that", because we're *already* seeing
> problems from things like enabling 8-bit width on setups that don't
> support it.
> 
> Thanks!
> 
> -- 
> Chris Ball   <cjb@laptop.org>   <http://printf.net/>
> One Laptop Per Child

