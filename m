Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab2DDOqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 10:46:22 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:54513 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756354Ab2DDOqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 10:46:21 -0400
Message-ID: <4F7C5EBA.3010506@xenotime.net>
Date: Wed, 04 Apr 2012 07:46:18 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Meelis Roos <mroos@linux.ee>
CC: Clemens Ladisch <clemens@ladisch.de>, Dave Airlie <airlied@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix warnings from vgaarb.h
References: <alpine.SOC.1.00.1204040912210.26551@math.ut.ee> <4F7BEE91.1070309@ladisch.de> <alpine.SOC.1.00.1204040947170.26551@math.ut.ee>
In-Reply-To: <alpine.SOC.1.00.1204040947170.26551@math.ut.ee>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2012 12:00 AM, Meelis Roos wrote:
>> Meelis Roos wrote:
>>> in 3.4-rc1-144, I get the following warnings. Fix them by including
>>> <linux/pci.h>  to get struct pci_dev.
>>>
>>>    CC [M]  drivers/gpu/drm/i915/intel_display.o
>>> In file included from drivers/gpu/drm/i915/intel_display.c:33:0:
>>> include/linux/vgaarb.h:66:9: warning: ‘struct pci_dev’ declared inside parameter list [enabled by default]
>>
>> Or you could simply declare it:
>>
>>    struct pci_dev;
>
> Right, but any actual user of vgaarb would still need real pci_dev
> anyway. But yes, nothing in vgaarb.h uses pci_dev contents, so the
> following also compiles without warnings:
>
> -
>
> in 3.4-rc1-144, I get several warnings like this
>
>    CC [M]  drivers/gpu/drm/i915/intel_display.o
> In file included from drivers/gpu/drm/i915/intel_display.c:33:0:
> include/linux/vgaarb.h:66:9: warning: ‘struct pci_dev’ declared inside parameter list [enabled by default]
>
> Fix them by forward declaring struct pci_dev:
>
> Signed-off-by: Meelis Roos<mroos@linux.ee>
>
> diff --git a/include/linux/vgaarb.h b/include/linux/vgaarb.h
> index 9c3120d..b572f80 100644
> --- a/include/linux/vgaarb.h
> +++ b/include/linux/vgaarb.h
> @@ -47,6 +47,8 @@
>    */
>   #define VGA_DEFAULT_DEVICE     (NULL)
>
> +struct pci_dev;
> +
>   /* For use by clients */
>
>   /**
> '
>

Yes, I have sent this same patch at least 2 times, beginning on 
Jan-30-2012.  And I cc-ed dri-devel mailing list and Dave Airlie
on it also.

