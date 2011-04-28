Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799Ab1D1OsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 10:48:07 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65526 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab1D1OsF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 10:48:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gIKt1U/ypdpuKeESidUPS0cWrAYsfVXr7NL7It0DgRh+N/oshDkoyb1xGOajeTNc3y
         x1Zut6qRmA3o/a5+9Z36adLwu++XH00pgvcewZjn67zVM2OlYbKdn1/n7wogF7DzgtsN
         xSG9LQWDqvNc5aCYg+6d+7PVl87GzSF824RtA=
MIME-Version: 1.0
In-Reply-To: <20110428143724.GQ17290@n2100.arm.linux.org.uk>
References: <1303963358-4652-1-git-send-email-haojian.zhuang@gmail.com>
	<20110428102212.2d8d607c@endymion.delvare>
	<BANLkTin6jguQue_0Y74jGPnmhCcvWLBjHg@mail.gmail.com>
	<20110428161625.5eaacb85@endymion.delvare>
	<20110428143724.GQ17290@n2100.arm.linux.org.uk>
Date: Thu, 28 Apr 2011 22:48:02 +0800
Message-ID: <BANLkTi=YeqxF_eu2Q=cy6oAFfyTrzAH6VA@mail.gmail.com>
Subject: Re: [PATCH 1/3] i2c: append hardware lock with bus lock
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jean Delvare <khali@linux-fr.org>, Eric Miao <eric.y.miao@gmail.com>,
        linux-arm-kernel@lists.infradead.org, ben-linux@fluff.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 10:37 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, Apr 28, 2011 at 04:16:25PM +0200, Jean Delvare wrote:
>> Are you suggesting that the hardware lock wouldn't mind being taken
>> twice by the AP side? If it is the case, then indeed the software mutex
>> is still needed to prevent it from happening.
>>
>> That being said... I guess that avoiding a priority inversion is a good
>> enough reason to always take the rt_mutex, regardless of the hardware
>> lock implementation.
>>
>> So, this patch is
>>
>> Acked-by: Jean Delvare <khali@linux-fr.org>
>>
>> I guess it makes more sense for me to let Ben apply it, as the other
>> two patches in the series are for him too. This will avoid a dependency
>> between our trees.
>
> Only change I'd suggest is passing adapter to the hardware_lock/unlock
> methods.  Having no arguments what so ever in generic code for this kind
> of stuff looks rather strange and limiting.
>

OK. I'll update it.
