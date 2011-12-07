Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab1LGITA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 03:19:00 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55431 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab1LGIS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 03:18:58 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4EDF2152.1090005@jp.fujitsu.com>
Date: Wed, 07 Dec 2011 17:18:26 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] PCI fixes
References: <20111123144417.2da5958c@jbarnes-desktop> <CA+55aFyaiJBYmgVCLfPA7q3hqtPHYh9wwsmVTCewbBoxMsDE8A@mail.gmail.com> <20111205112256.68e59434@jbarnes-desktop> <4EDDCD6D.1010907@jp.fujitsu.com> <CA+55aFwuZxGZhXyhj+cb5WLnFPDh45Dy6BwgmvEQKAM5swaM6w@mail.gmail.com> <CAE9FiQXwTcvfH21QZ87rU2vgf-xo8OT8L3f5gYwtbxJUDkDatQ@mail.gmail.com>
In-Reply-To: <CAE9FiQXwTcvfH21QZ87rU2vgf-xo8OT8L3f5gYwtbxJUDkDatQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+	/* Configuration request Retry Status */
+	if (l == 0xffff0001)
+		goto wait;

I think this works only when CRS Software Visibility is enabled,
isn't it? Currently there is no code to enable CRS Software
Visibility. And there can be root ports that doesn't support CRS
Software Visibility. We need consideration about this.

+	mdelay(100);
+	delay -= 100;
+	if (delay > 0)
+		goto again;

We must use msleep() instead of mdelay().

Regards,
Kenji Kaneshige


(2011/12/07 7:36), Yinghai Lu wrote:
> On Tue, Dec 6, 2011 at 8:14 AM, Linus Torvalds
> <torvalds@linux-foundation.org>  wrote:
>> Please try to make something like that work. Instead of always waiting
>> for one second, wait for up to one second only for failure cases. Any
>> possibility of that?
>
> i had another version that was not send out. that worked on my test setups too.
> it will try to read pci conf several times in 1s.
>
> please check refreshed version against your tree.
>
> Thanks
>
> Yinghai

