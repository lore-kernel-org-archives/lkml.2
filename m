Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834Ab0FBRLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 13:11:35 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51951 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932538Ab0FBRLd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 13:11:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CyHuwx54DeuQ26bALPIF1YgZo+1vkCRNVnEwede2eSny+yjdy70wuHdd5wrmuw4bCk
         o9ysWip4RO5WNakZ4WadSyQAUyw2ttQhH2OncBQM5ub+n/UVuQuk6/D5MiFspJxsg9yf
         2ZdttseBMtensWQVFxm6tZ1Fs+2vdxwnFe/VY=
MIME-Version: 1.0
In-Reply-To: <4C068BAA.4030004@oracle.com>
References: <AANLkTikC61Y9g-WbqwgGDghDSy2XtgraFSRoZYkHRGTG@mail.gmail.com>
	<AANLkTilEYHVHJrj_KgF48OYCSEUcsKLi57Q_Y73d9va-@mail.gmail.com>
	<20100602085748.6771e025.randy.dunlap@oracle.com>
	<AANLkTilpzeYVExQfLgpVmS3bPvb_h3kmWaatidekI-0r@mail.gmail.com>
	<4C068BAA.4030004@oracle.com>
Date: Wed, 2 Jun 2010 22:41:32 +0530
Message-ID: <AANLkTimGeOsW5Zt5wR7t4uIUoju3wDXSqSFcIiemdsNU@mail.gmail.com>
Subject: Re: [TEMP PATCH] Re: make ARM=arm menuconfig problem in mainline
From: Nobin Mathew <nobin.mathew@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-kbuild@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 2, 2010 at 10:19 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On 06/02/10 09:08, Nobin Mathew wrote:
>>
>> On Wed, Jun 2, 2010 at 9:27 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>> On Wed, 2 Jun 2010 20:04:28 +0530 Nobin Mathew wrote:
>>>
>>>> adding linux-arm-kernel@lists.infradead.org
>>>>
>>>> Hi,
>>>>
>>>> The following entry creates problem in ARM System type menu. I am
>>>> using a Fedora 12 system.
>>>
>>> What kind of problem does it create?
>>> It seems to work for me (on f11, not f12).
>>> Does it have something to do with F12 specifically?
>>>
>>>
>>>> Length of bool "Samsung S3C2410, S3C2412, S3C2413, S3C2416, S3C2440,
>>>> S3C2442, S3C2443, S3C2450" is the problem. How can I fix it.
>>>
>>> Describe the problem, please.
>
> [please don't top-post]
Sorry I forgot. I rarely send mails to this list.
>
>> Sorry if attachments are not allowed, when I go to select ARM system
>> type(OMAP, Davinci etc), I am not seeing any entries there in the pop
>> up window. When I remove  bool "Samsung S3C2410, S3C2412, S3C2413,
>> S3C2416, S3C2440,
>>>> S3C2442, S3C2443, S3C2450"  it is working fine. I feel it is something to do with length of that string.
>>
>> Thanks
>> Nobin
>
>
> OK, I see that now.  Well, it is some kind of problem.
> Adding cc to linux-kbuild mailing list.
>
>
> The patch below fixes the problem temporarily, but the bool string length does
> seem to be a problem.
>
> Thanks for your report.
>
> --
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> The bool "long string" causes the choices not to be displayed,
> so temporarily change it to a shorter string until a real fix
> is found.
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Reported-by: Nobin Mathew <nobin.mathew@gmail.com>
> Cc: Ben Dooks <ben-linux@fluff.org>
> ---
>  arch/arm/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- linux-next-20100602.orig/arch/arm/Kconfig
> +++ linux-next-20100602/arch/arm/Kconfig
> @@ -629,7 +629,7 @@ config ARCH_SA1100
>          Support for StrongARM 11x0 based boards.
>
>  config ARCH_S3C2410
> -       bool "Samsung S3C2410, S3C2412, S3C2413, S3C2416, S3C2440, S3C2442, S3C2443, S3C2450"
> +       bool "Samsung S3C24xx"
>        select GENERIC_GPIO
>        select ARCH_HAS_CPUFREQ
>        select HAVE_CLK
>
