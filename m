Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab1HJUxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 16:53:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42511 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab1HJUx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 16:53:29 -0400
Message-ID: <4E42EFCB.1030005@linaro.org>
Date: Wed, 10 Aug 2011 22:53:31 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mike Turquette <mturquette@ti.com>
CC: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        gregkh@suse.de, linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH v2 1/2] cpumask: introduce cpumask for hotpluggable CPUs
References: <1313006614-28702-1-git-send-email-mturquette@ti.com> <1313006614-28702-2-git-send-email-mturquette@ti.com>
In-Reply-To: <1313006614-28702-2-git-send-email-mturquette@ti.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 08/10/2011 10:03 PM, Mike Turquette wrote:
> On some platforms it is possible to have some CPUs which support CPU
> hotplug and some which do not.  Currently the prescence of an 'online'
> sysfs entry in userspace is adequate for applications to know that a CPU
> supports hotplug, but there is no convenient way to make the same
> determination in the kernel.
> 
> To better model this relationship this patch introduces a new cpumask to
> track CPUs that support CPU hotplug operations.
> 
> This new cpumask is populated at boot-time and remains static for the
> life of the machine.  Bits set in the mask indicate a CPU which supports
> hotplug, but make no guarantees about whether that CPU is currently
> online or not.  Likewise a cleared bit in the mask indicates either a
> CPU which cannot hotplug or a lack of a populated CPU.
> 
> The purpose of this new cpumask is to aid kernel code which uses CPU to
> take CPUs online and offline.  Possible uses are as a thermal event
> mitigation technique or as a power capping mechanism.
> 
> Signed-off-by: Mike Turquette <mturquette@ti.com>

Reviewed-by: Daniel Lezcano <daniel.lezcano@linaro.org>

- -- 
 <http://www.linaro.org/> Linaro.org ? Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJOQu/KAAoJEAKBbMCpUGYAxnoH/0+WtrRGq0oOjkU8jIxzAEUP
OW6S7EQT13v97YapaEwUZpHOzrdeEa9bV5sVI3uc3H9n6dnQbh25eMuhiH/dTwF6
LHV1Tdv7/+ghiSc4NJunpXjAsObezUgTV9n2Zoip3kAfhMdV5DntJu0Izkdb5lkA
AD5CqV6oHqC0spa2/nMMeOYsdp3hLP3hA5wCyE8a2rxvbytxl2jRVommXOpF3AnI
s3OS7oyVFLpdvxVdAio1cXvM6vILtJFArAqw88AJUBsUsuehRxeOYVvTR3/z4RZD
LNEH72IkGY/8OVYp9/VoixWgWTUhXUR5BZwAjCP7a+xQk/1qK1LAM+/CXimwND0=
=90gJ
-----END PGP SIGNATURE-----
