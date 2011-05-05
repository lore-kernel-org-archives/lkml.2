Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab1EECRp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 22:17:45 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56910 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab1EECRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 22:17:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=YlozK4B77HzLp7FtjR2vzUEIbtUr07KpuW00RSQYB03aD6Y+e3V6bNhxt5ywiVWp+Y
         AnpxTHxlpDxVcmv7OJ4Riw3TbmQ7Lg6JFlMGo9UHmt2SwRwOWHV7K6vPoRNkh0LFYjGA
         haTxFKF4DRf5lX9UC2zbDoR619gY87rYU6TLE=
Message-ID: <4DC208C3.7070902@pobox.com>
Date: Wed, 04 May 2011 22:17:39 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: shaohua.li@intel.com
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        jaxboe@fusionio.com, htejun@gmail.com, hch@infradead.org,
        djwong@us.ibm.com, sshtylyov@mvista.com
Subject: Re: [patch v3 1/3] block: add a non-queueable flush flag
References: <20110505015932.306763905@sli10-conroe.sh.intel.com> <20110505020417.586891398@sli10-conroe.sh.intel.com>
In-Reply-To: <20110505020417.586891398@sli10-conroe.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2011 09:59 PM, shaohua.li@intel.com wrote:
> flush request isn't queueable in some drives. Add a flag to let driver
> notify block layer about this. We can optimize flush performance with the
> knowledge.
>
> Signed-off-by: Shaohua Li<shaohua.li@intel.com>
> ---
>   block/blk-settings.c   |    6 ++++++
>   include/linux/blkdev.h |    7 +++++++
>   2 files changed, 13 insertions(+)

hmmm.

This assumes that flush on new hardware, by default, is queueable.

I think the sense should be reversed:  don't enable the optimization, 
unless we know the optimization works.

That seems safer than always enabling the optimization, unless we know 
it does not work.  That is not a fail-safe mode of operation.

	Jeff




