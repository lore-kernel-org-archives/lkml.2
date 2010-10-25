Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab0JYK5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 06:57:31 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:61682 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab0JYK53 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 06:57:29 -0400
X-AuditID: b753bd60-a84dbba000000a18-db-4cc562139e4d
Message-ID: <4CC56206.8080700@hitachi.com>
Date: Mon, 25 Oct 2010 19:55:02 +0900
From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>, greg@kroah.com
Cc: James.Bottomley@suse.de, rwheeler@redhat.com, linux-kernel@vger.kernel.org,
        linux-hotplug@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        Matt_Domsch@dell.com
Subject: Re: [RFD] Device Renaming Mechanism
References: <4CAEAAD4.2080504@hitachi.com> <20101008204802.GA21542@kroah.com> <4CBC32CC.6010506@hitachi.com> <AANLkTi=HzjWZbz7J92h9LCQijG8Zsv1YptFzN7d_G7eG@mail.gmail.com>
In-Reply-To: <AANLkTi=HzjWZbz7J92h9LCQijG8Zsv1YptFzN7d_G7eG@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(2010/10/18 21:33), Kay Sievers wrote:
> 
> In short: it's a complete nightmare from the view of reliability, and
> I strongly suggest not even to think about to try that model on any
> other subsystem.

I see. I understood that network interface and block device are different.


> Device-mapper could maybe make the dm UUID mandatory, and use it as
> the device name. It will break a bunch of tools, which match on device
> names, but I guess it *could* be made working (if it does not involve
> any later renaming).

Indeed, device-mapper can provide a fixed name. However, still there is
mismatch between the dm device name and the troubling device name in kernel
log. That is the reason why I'm still sticking around the device renaming method.

In addition, using of device-mapper is worry about the performance and
management cost.

I think the method of using the intermediate device is the simplest solution.
Furthermore that method is compatible with old applications which are hard to
modify.


> I wouldn't even try. Besides the mentioned device mapper
> mandatory/non-changeable UUID==device-name approach which could work,
> I don't think that renaming of sd devices can be made working, without
> rewriting half of all existing userspace. :)

Even though, if it is only way to solve log-mismatch problem, I'd rather try to
rewrite a half of those tools. :-)


> 
> Kay
> 
> 

Thank you for your advice.
Best Regards,

-- 
Nao NISHIJIMA
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
Email： nao.nishijima.xt@hitachi.com
