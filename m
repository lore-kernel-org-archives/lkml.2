Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909Ab1JGWNJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 18:13:09 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44047 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716Ab1JGWNG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 18:13:06 -0400
MIME-Version: 1.0
In-Reply-To: <20111007064349.GD27508@kroah.com>
References: <1317963790-29426-1-git-send-email-manjugk@ti.com>
 <1317963790-29426-2-git-send-email-manjugk@ti.com> <20111007064349.GD27508@kroah.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 7 Oct 2011 16:12:45 -0600
X-Google-Sender-Auth: MElMmGyW3xfF86eRoxYOOnlhXFE
Message-ID: <CACxGe6uOmrLwJSPw4JHuOmt5B2wsukdDgVUr01pryq5Z9BFadw@mail.gmail.com>
Subject: Re: [PATCH 1/5] drivercore: add new error value for deferred probe
To: Greg KH <greg@kroah.com>
Cc: "G, Manjunath Kondaiah" <manjugk@ti.com>,
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

On Fri, Oct 7, 2011 at 12:43 AM, Greg KH <greg@kroah.com> wrote:
> On Fri, Oct 07, 2011 at 10:33:06AM +0500, G, Manjunath Kondaiah wrote:
>>
>> Add new error value so that drivers can request deferred probe
>> from drivercore.
>>
>> Signed-off-by: G, Manjunath Kondaiah <manjugk@ti.com>
>> Reported-by: Grant Likely <grant.likely@secretlab.ca>
>> ---
>> Cc: linux-omap@vger.kernel.org
>> Cc: linux-mmc@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: Grant Likely <grant.likely@secretlab.ca>
>> Cc: Greg Kroah-Hartman <greg@kroah.com>
>> Cc: Dilan Lee <dilee@nvidia.com>
>> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
>> Cc: Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>>
>>  include/linux/errno.h |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/errno.h b/include/linux/errno.h
>> index 4668583..83d8fcf 100644
>> --- a/include/linux/errno.h
>> +++ b/include/linux/errno.h
>> @@ -16,6 +16,7 @@
>>  #define ERESTARTNOHAND       514     /* restart if no handler.. */
>>  #define ENOIOCTLCMD  515     /* No ioctl command */
>>  #define ERESTART_RESTARTBLOCK 516 /* restart by calling sys_restart_syscall */
>> +#define EPROBE_DEFER 517     /* restart probe again after some time */
>
> Can we really do this?

According to Arnd, yes this is okay.

>  Isn't this some user/kernel api here?
>
> What's wrong with just "overloading" on top of an existing error code?
> Surely one of the other 516 types could be used here, right?

overloading makes it really hard to find the users at a later date.

g.
