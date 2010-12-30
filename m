Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814Ab0L3Gc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 01:32:58 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40996 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab0L3Gc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 01:32:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=bULLoOCu6G8R2ODIZI/ywnykqs8lZhsCyqSt1F3oW8V7jDm7KX34SHZW+1O+hDD32l
         8O/VlhBwAkM0ZD3JMYFT7Z0OcbLqb8Ke9iQPI7Xa2KMsAqjMWIbN5iZxK6ZZG5ihSgpg
         QJErymC5BR8IxFBtT7dWVk2huU6lFXzlXQivk=
MIME-Version: 1.0
In-Reply-To: <4D1C0CFE.5010008@codeaurora.org>
References: <4D1C0CFE.5010008@codeaurora.org>
Date: Thu, 30 Dec 2010 12:02:53 +0530
X-Google-Sender-Auth: tdbjYPVKe24FcvaIiwhv3Fu7vCU
Message-ID: <AANLkTinqqgNwgFCMVL-2T83zKnNLGLF007atJ4-EDEW5@mail.gmail.com>
Subject: Re: i2c runtime suspend and system wide suspend
From: Rabin Vincent <rabin@rab.in>
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jean Delvare <khali@linux-fr.org>, Rajendra Nayak <rnayak@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Vishwanath BS <vishwanath.bs@ti.com>, Partha Basak <p-basak2@ti.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 30, 2010 at 10:09 AM, Abhijeet Dharmapurikar
<adharmap@codeaurora.org> wrote:
> The i2c-core driver mixes runtime suspend and system wide suspend, in that,
> during a system wide suspend, it skips calling ->suspend if the device is
> runtime suspended.
>
> I have an interrupt controller running over the i2c bus and that driver is
> oblivious of the runtime pm framework, IOW, it doesn't do any runtime pm
> calls. CONFIG_RUNTIME_PM is enabled however (for some other bus drivers).
> The issue I am facing is that all such i2c devices are assumed runtime
> suspended and the ->suspend for these devices is not invoked during
> systemwide suspend.

This was discussed on linux-pm recently.  Rafael had a fix, I'm don't know
whether it's applied yet:

https://lists.linux-foundation.org/pipermail/linux-pm/2010-December/029567.html
https://lists.linux-foundation.org/pipermail/linux-pm/2010-December/029596.html

Also relevant:

https://lists.linux-foundation.org/pipermail/linux-pm/2010-December/029600.html
https://lists.linux-foundation.org/pipermail/linux-pm/2010-December/029658.html
