Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab1KIIbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 03:31:37 -0500
Received: from t111.niisi.ras.ru ([193.232.173.111]:53562 "EHLO
	t111.niisi.ras.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab1KIIbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 03:31:36 -0500
X-Greylist: delayed 3610 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Nov 2011 03:31:35 EST
Message-ID: <4EBA2E65.3010009@niisi.msk.ru>
Date: Wed, 09 Nov 2011 11:40:21 +0400
From: "Gleb O. Raiko" <raiko@niisi.msk.ru>
Organization: NIISI RAN
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: Al Cooper <alcooperx@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: Kernel hangs occasionally during boot.
References: <y> <1320764341-4275-1-git-send-email-alcooperx@gmail.com> <20111108175532.GA15493@linux-mips.org>
In-Reply-To: <20111108175532.GA15493@linux-mips.org>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: Dr.Web (R) for Mail Servers on t111.niisi.ras.ru host
X-Antivirus-Code: 100000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.11.2011 21:55, Ralf Baechle wrote:
> but we may need another hazard barrier to
> replace back_to_back_c0_hazard().
Urgently. We need some ticks to wait until counter state machine has 
been updated. The amount of ticks may occasionally be the same as in 
case of back_to_back_hazard for some cpus. It's completely different for 
others, I sure. Original compare_change_hazard waits up to 12 ticks for 
r4k. While I don't think this amount should depend on irq_disable_hazard 
as old code assumes, we may still need 12 or so ticks for old cpus.

> Author: Al Cooper <alcooperx@gmail.com> Tue Nov 8 09:59:01 2011 -0500
> Comitter: Ralf Baechle <ralf@linux-mips.org> Tue Nov 8 16:52:51 2011 +0000
> Commit: 9121470d99c029493bd55daa11607b398fe9aea3
> Gitweb: http://git.linux-mips.org/g/linux/9121470d
Could you fix those links, it's broken after you moved git repo in?

Regards,
Gleb.
