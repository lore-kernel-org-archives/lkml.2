Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965Ab1JIW7x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 18:59:53 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50581 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab1JIW7w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 18:59:52 -0400
MIME-Version: 1.0
In-Reply-To: <20111008001237.GA30551@kroah.com>
References: <1317963790-29426-1-git-send-email-manjugk@ti.com>
 <1317963790-29426-2-git-send-email-manjugk@ti.com> <20111007064349.GD27508@kroah.com>
 <CACxGe6uOmrLwJSPw4JHuOmt5B2wsukdDgVUr01pryq5Z9BFadw@mail.gmail.com>
 <32004.1318030113@turing-police.cc.vt.edu> <20111008001237.GA30551@kroah.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 9 Oct 2011 16:59:31 -0600
X-Google-Sender-Auth: 6rTAfbVir8iTEcaGaARezYFcHB0
Message-ID: <CACxGe6t+PfnNGniYUj3pbK22uqjqkbh2+D=7qvvd_-Yd4yR0dw@mail.gmail.com>
Subject: Re: [PATCH 1/5] drivercore: add new error value for deferred probe
To: Greg KH <greg@kroah.com>
Cc: Valdis.Kletnieks@vt.edu, "G, Manjunath Kondaiah" <manjugk@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dilan Lee <dilee@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 7, 2011 at 6:12 PM, Greg KH <greg@kroah.com> wrote:
> On Fri, Oct 07, 2011 at 07:28:33PM -0400, Valdis.Kletnieks@vt.edu wrote:
>> On Fri, 07 Oct 2011 16:12:45 MDT, Grant Likely said:
>> > On Fri, Oct 7, 2011 at 12:43 AM, Greg KH <greg@kroah.com> wrote:
>> > > On Fri, Oct 07, 2011 at 10:33:06AM +0500, G, Manjunath Kondaiah wrote:
>>
>> > >> +#define EPROBE_DEFER 517     /* restart probe again after some time */
>> > >
>> > > Can we really do this?
>>
>> > According to Arnd, yes this is okay.
>>
>> > >  Isn't this some user/kernel api here?
>>
>> > > What's wrong with just "overloading" on top of an existing error code?
>> > > Surely one of the other 516 types could be used here, right?
>>
>> > overloading makes it really hard to find the users at a later date.
>>
>> Would proposing '#define EPROBE_DEFER EAGAIN' be acceptable to everybody? That
>> would allow overloading EAGAIN, but still make it easy to tell the usages apart
>> if we need to separate them later...
>
> Yes, please do that, it is what USB does for it's internal error code
> handling.

Really?  When we've only currently used approximately 2^9 of a 2^31
numberspace?  I'm fine with making sure that the number doesn't show
up in the userspace headers, but it makes no sense to overload the
#defines.  Particularly so in this case where it isn't feasible to
audit every driver to figure out what probe might possibly return.  It
is well within the realm of possibility that existing drivers are
already returning -EAGAIN.

Besides; linux/errno.h *already* has linux-internal error codes that
do not get exported out to userspace.  There is an #ifdef __KERNEL__
block around ERESTARTSYS through EIOCBRETRY which is filtered out when
exporting headers.  I can't see any possible reason why we wouldn't
add Linux internal error codes here.

g.



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
