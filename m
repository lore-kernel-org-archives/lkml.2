Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab1AGWYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:24:21 -0500
Received: from smtp-out.google.com ([74.125.121.67]:44623 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab1AGWYT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:24:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=hE+KLajnEjt/2fxoXNPhXPdgzfmva7XAkgw32aqU5DJPm5hXOsz1Nh4+OoZU28k4xV
         9rQ6wkeBSOmyEbw8Pg2A==
MIME-Version: 1.0
In-Reply-To: <20110107082355.GD3801@infomag.iguana.be>
References: <1288054685-29107-1-git-send-email-mikew@google.com>
 <AANLkTik=eNbQoGaDLS_-8kZLFojK9P1Ge0QAEFc_cPtG@mail.gmail.com> <20110107082355.GD3801@infomag.iguana.be>
From: Mike Waychison <mikew@google.com>
Date: Fri, 7 Jan 2011 14:23:55 -0800
Message-ID: <AANLkTin_xvms=Md_F0Uj0X=Exj61-bPALwABGFMX27bu@mail.gmail.com>
Subject: Re: [PATCH 1/2] watchdog: Add support for sp5100 chipset TCO
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Priyanka Gupta <priyankag@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 7, 2011 at 12:23 AM, Wim Van Sebroeck <wim@iguana.be> wrote:
> Hi Mike,
>
>> Do you have any interest in picking these patches up?  I'd like to get
>> this hardware functionality mainlined as it would allow us to get
>> closer to testing upstream kernels on our hardware.
>
> I allready cleaned both drivers up, but I had to send the feedback still.
> Basically for both drivers, I did the following:
> * Change reboot_notifier by a platform shutdown
> * remove CONFIG_WATCHDOG_NOWAYOUT ifdef-ery (since that exists allready in watchdog.h)
> * return -ENOTTY as default ioctl err-code
> * make watchdog_info a static const struct
> * some small cleanups
>
> This gives below code. Could you please review it?

Hi Wim,

Thanks for the quick response :)

Both drivers look great.  I read over the changes, they look good.  I
also applied them to 2.6.37 and tested them on our machines without
any problems.

The cleanups above seem fine to me.  What did you mean by "Change
reboot_notifier by a platform shutdown" though?  I see that you
removed the reboot_notifier, which is fine for our purposes.  Was this
a suggestion to have this stuff get called from platform code if
needed?  Am I missing something?

Mike Waychison
