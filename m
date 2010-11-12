Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab0KLA5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 19:57:53 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50624 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab0KLA5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 19:57:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZP6Sp/qAF4Z4gBLLgRakjo5rGEWNBMhAqdBwKc2nTOW45Do7dzDYYODJBpJZjPl7Br
         uHPss6ogMP4WZvrynNFOxjrM3mTnRPKS1vesSatF0B6wsDxyUNYi1NKKfHnxcSPd8j1Z
         +VvVpbeYZb3/OhsYEg8zgTMsZHX9U3o/y4jAk=
Date: Thu, 11 Nov 2010 16:57:41 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Trilok Soni <tsoni@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-arm-msm@vger.kernel.org
Subject: Re: [RFC v1 PATCH 4/6] input: pmic8058_pwrkey: Add support for power
 key
Message-ID: <20101112005741.GC17097@core.coreip.homeip.net>
References: <1289393281-4459-1-git-send-email-tsoni@codeaurora.org>
 <1289393281-4459-5-git-send-email-tsoni@codeaurora.org>
 <20101111072107.GA24415@core.coreip.homeip.net>
 <4CDBDAD5.90406@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CDBDAD5.90406@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 05:30:21PM +0530, Trilok Soni wrote:
> Hi Dmitry,
> 
> On 11/11/2010 12:51 PM, Dmitry Torokhov wrote:
> > Hi Trilkok,
> > 
> > On Wed, Nov 10, 2010 at 06:17:59PM +0530, Trilok Soni wrote:
> >> Add support for PMIC8058 power key driven over dedicated KYPD_PWR_N
> >> pin. It allows the user to specify the amount of time by which the
> >> power key reporting can be delayed.
> >>
> > 
> > Why do we need to delay KEY_POWER reporting? Do we need to use high
> > resolution timers or regular timers would do as well? KEY_END
> > appears to be abused (you don't want to move your cursor to the end
> > of line, do you?). Also I wonder if header file should reside in
> > linux/mfd with the rest of pmic8058 components.
> 
> Most of the time Mobile devices come with single physical key for
> POWER, which if pressed for less than 500ms (configurable) then it
> will only report KEY_END (which say locks the screen on mobile) and if
> it pressed more than 500ms then it will also report KEY_POWER event
> too, which will say display menu on your mobile for asking you to
> suspend/switch off/etc, operations.
> 

I see,. If you would have used KEY_SCREENLOCK iinstead of KEY_END I
would likely not ask this question ;)

> For the timers I can move from hrtimers to regular timers.
> 
> For the header file, I can move them to include/linux/mfd too. No
> problem on that.
> 

I am not even sure we need to keep them in separate header files, but it
is up to you.

Thanks.

-- 
Dmitry
