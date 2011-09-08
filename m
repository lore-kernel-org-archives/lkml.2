Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814Ab1IHBfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 21:35:08 -0400
Received: from mail-vw0-f43.google.com ([209.85.212.43]:36856 "EHLO
	mail-vw0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757748Ab1IHBfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 21:35:07 -0400
Message-ID: <4E681BC9.4010901@vflare.org>
Date: Wed, 07 Sep 2011 21:35:05 -0400
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Jerome Marchand <jmarchan@redhat.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 1/2] staging: zram: fix zram locking
References: <1315314132-8436-1-git-send-email-jmarchan@redhat.com>
In-Reply-To: <1315314132-8436-1-git-send-email-jmarchan@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2011 09:02 AM, Jerome Marchand wrote:
> Currently init_lock only prevents concurrent execution of zram_init_device()
> and zram_reset_device() but not zram_make_request() nor sysfs store functions.
>

zram_make_request() initializes the device first time it is used and 
from then on no sysfs config writes are allowed till the device is reset 
-- for example, you cannot change disksize while a disk is in 
initialized state. So, I could not understand why we need to protect 
zram_make_request vs sysfs stores.

Thanks,
Nitin



