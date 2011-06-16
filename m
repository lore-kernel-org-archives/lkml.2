Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab1FPJUB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 05:20:01 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34954 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756611Ab1FPJT7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 05:19:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hj/7io7PkCJ/tPxt88xBsZPVjN7O6I5CUOPLt5Uf7PLN83w9o6KGVKXqA+VCcooxYb
         e2xhYYIGe3JzyUR6csjuJr1bRMP1lGrT4tmSbKH8mCYoKRjRDYpCfhbOqJA1oSMPAKdL
         zngyQQzRd2Y+5QyN7mb2C1TZkgzcy1eQa0PME=
MIME-Version: 1.0
In-Reply-To: <20110616110256.0890dd37@susi.home.s3e.de>
References: <20110616110256.0890dd37@susi.home.s3e.de>
Date: Thu, 16 Jun 2011 11:19:57 +0200
Message-ID: <BANLkTinfNKKeyC9RB-uvFSVq5OeNXiw95Q@mail.gmail.com>
Subject: Re: 3.0-rc2: mei breaks suspend
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
To: Stefan Seyfried <stefan.seyfried@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

2011/6/16 Stefan Seyfried <stefan.seyfried@googlemail.com>:
> Hi,
>
> having the "mei" driver loaded, which happened automatically on my
> ThinkPad X200s, successfully prevents any suspend efforts:
>
> [39736.728116] pci_pm_suspend(): mei_pci_suspend+0x0/0xc0 [mei] returns 9999
>
> The code has not changed since 3.0-rc2, so I did not try compiling latest
> git.
>
> Jiri Slaby hinted that this code in drivers/staging/mei/wd.c is to blame:
>
> 169         ret = wait_event_interruptible_timeout(dev->wait_stop_wd,
> 170                                         dev->wd_stopped, 10 * HZ);
>
> I am, however, not familiar enough with timers and stuff to immediately
> spot the problem.
>
> Removing the module before suspend is a workaround.
>
> This could be considered a regression, as suspend worked very well before
> this driver was introduced :-)
Does changing that to wait_event_timeout work? My guess is that is
what he meant.

~Maarten
