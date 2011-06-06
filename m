Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab1FFEnO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 00:43:14 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33542 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570Ab1FFEnK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 00:43:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PUk9svuhk7pGhfyVhrhEIvy98o3oCR70Cx0cm0l4tdwDox4hq6cWvyE+eDPidw+NbR
         LPgj8lFoCRuRf4ul0GzEp1PpjEGAOq2dE+5rVHhfiypj3RFAJvmVJZRjlCCDhY/xFeNW
         lgxOsMINBmcq1qcXEaRAcqQfdBenAjQg4uBwA=
MIME-Version: 1.0
In-Reply-To: <20110605201042.21c86763@sf>
References: <20110605201042.21c86763@sf>
Date: Mon, 6 Jun 2011 10:13:08 +0530
Message-ID: <BANLkTimLXr1+OLtGGXE2kzccRRG5T-G2mw@mail.gmail.com>
Subject: Re: 3.0.0-rc1: dmesg shows 'wlan%d' instead of 'wlan0'
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Sergei Trofimovich <slyich@gmail.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 5, 2011 at 10:40 PM, Sergei Trofimovich <slyich@gmail.com> wrote:
> Recently I've noticed small discrepancy in dmesg:
>
> $ { zcat messages.2.gz messages.1.gz; cat messages; } | egrep "(deauthen|Linux version)"
> ...
> May 21 22:01:31 sf kernel: [    0.000000] Linux version 2.6.39-00004-g29c77fa (slyfox@sf) (gcc version 4.4.5 (Gentoo 4.4.5 p1.2, pie-0.4.5) ) #116 SMP PREEMPT Thu May 19 22:46:16 EEST 2011
> May 24 05:37:54 sf kernel: [81845.885094] wlan0: deauthenticated from ...
>
> Jun  1 22:38:38 sf kernel: [    0.000000] Linux version 3.0.0-rc1-00035-g79f3f61 (slyfox@sf) (gcc version 4.4.5 (Gentoo 4.4.5 p1.2, pie-0.4.5) ) #118 SMP PREEMPT Wed Jun 1 22:14:46 EEST 2011
> Jun  1 23:41:23 sf kernel: [ 3877.773727] wlan%d: deauthenticating from ...
>
> Jun  1 23:42:16 sf kernel: [    0.000000] Linux version 3.0.0-rc1-00035-g79f3f61-dirty (slyfox@sf) (gcc version 4.4.5 (Gentoo 4.4.5 p1.2, pie-0.4.5) ) #119 SMP PREEMPT Wed Jun 1 23:35:43 EEST 2011
> Jun  2 07:35:10 sf kernel: [ 5972.879970] wlan%d: deauthenticated from ...
>
> Here we see 'wlan0' -> 'wlan%d' switch. I presume those lines go from firmware
> (and not from userspace).
>
> The card is an iwl4965
>
> 10:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or AGN [Kedron] Network Connection (rev 61)


this seems to be fixed by the following commit which was recently
merged in wireless-testing

commit 59e7e7078d6c2c6294caf454c6e3695f9d3e46a2
Author: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Date:   Thu Jun 2 17:28:37 2011 -0300

    mac80211: call dev_alloc_name before copying name to sdata

    This partially reverts 1c5cae815d19ffe02bdfda1260949ef2b1806171, because
    the netdev name is copied into sdata->name, which is used for debugging
    messages, for example. Otherwise, we get messages like this:

    wlan%d: authenticated

    Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
    Cc: Jiri Pirko <jpirko@redhat.com>
    Cc: David S. Miller <davem@davemloft.net>
    Cc: Johannes Berg <johannes@sipsolutions.net>
    Cc: "John W. Linville" <linville@tuxdriver.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>


are we still getting it?

>
> --
>
>  Sergei
>



-- 
shafi
