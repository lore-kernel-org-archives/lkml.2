Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab1COI5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 04:57:12 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:35477 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab1COI5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 04:57:10 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.07 with qID p2F8uvgD026320, This message is released by code: ctaloc0852
X-BOX-Message-Id: p2F8uvgD026320
Message-ID: <4D7F29C6.7060404@realsil.com.cn>
Date: Tue, 15 Mar 2011 16:56:38 +0800
From: wwang <wei_wang@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110304 Lanikai/3.1.9
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, <gregkh@suse.de>,
        <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] staging: rts_pstor: set lun_mode in a differentplace
References: <1300177336-4486-1-git-send-email-wei_wang@realsil.com.cn> <20110315084625.GU2008@bicker>
In-Reply-To: <20110315084625.GU2008@bicker>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年03月15日 16:46, Dan Carpenter 写道:
> Hm...  The auto detect code is never run because chip->use_hw_setting is
> always 0.  Are you sure the right fix isn't to set chip->use_hw_setting
> to 1?
>
> regards,
> dan carpenter
>
Yes, setting chip->use_hw_setting is not a wise choice.
Normally, if chip->use_hw_setting is set to 1, more configurations will
be turned on, such as auto_delink_en.
auto_delink_en can only work well when pcie hotplug is configured and
pciehp.pciehp_force is set to 1. This condition can't be met in default
kernel config by now.
So, I have to choose to set lun_mode detection code in a different place.

Best regards,
wwang
