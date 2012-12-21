Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab2LUPdE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 10:33:04 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:53670 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab2LUPcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 10:32:52 -0500
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Dec 2012 10:32:51 EST
MIME-Version: 1.0
X-Originating-IP: [93.172.165.108]
In-Reply-To: <81C3A93C17462B4BBD7E272753C1057924576E5095@EXDCVYMBSTM005.EQ1STM.local>
References: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
 <1355501220-4572-8-git-send-email-sjur.brandeland@stericsson.com>
 <20121221021801.GD28692@WorkStation.localnet> <81C3A93C17462B4BBD7E272753C1057924576E500F@EXDCVYMBSTM005.EQ1STM.local>
 <20121221134051.GB22252@WorkStation.localnet> <81C3A93C17462B4BBD7E272753C1057924576E5095@EXDCVYMBSTM005.EQ1STM.local>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 21 Dec 2012 17:26:15 +0200
Message-ID: <CAK=WgbbaRmhKzibfT4NwDUthdLpCZVO3uo6TrHdJTthp9GHx0w@mail.gmail.com>
Subject: Re: [RFCv2 07/11] remoteproc: Register virtio devices after vring allocation
To: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
Cc: Ido Yariv <ido@wizery.com>, Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjur@brendeland.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Fri, Dec 21, 2012 at 3:50 PM, Sjur BRENDELAND
<sjur.brandeland@stericsson.com> wrote:
> Yes, but I think this will work if we allocate resources first,
> and then in the next step register the virtio devices.
> All the resources for all the vdevs will be allocated first
> and then rproc_boot will be called.

This sounds similar to what we had originally, before commit 6db20ea
"remoteproc: allocate vrings on demand, free when not needed". We can
revert this, but we then lose the properties 6db20ea provided.

Will Ido's suggestion to count the number of notifiyids in advance
work for you? at foresight it sounds like it could be just a few lines
of code, with no real hit on performance.

Thanks and happy holidays!
Ohad.
