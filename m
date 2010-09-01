Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab0IAJ5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 05:57:20 -0400
Received: from smtp.witbe.net ([81.88.96.48]:60584 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767Ab0IAJ5T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 05:57:19 -0400
Date: Wed, 1 Sep 2010 11:55:07 +0200
From: Paul Rolland <rol@as2917.net>
To: Pekka Enberg <penberg@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Dave Airlie <airlied@linux.ie>
Subject: Re: 2.6.36-rc2 : slabtop report 10170292 size-32 objects...
Message-ID: <20100901115507.705fe5e4@tux.DEF.witbe.net>
In-Reply-To: <AANLkTimnBG1qcLwZoEkr_iDkwE4zygLdjFJHVk9S3+wZ@mail.gmail.com>
References: <20100901113525.04b356c5@tux.DEF.witbe.net>
	<AANLkTimnBG1qcLwZoEkr_iDkwE4zygLdjFJHVk9S3+wZ@mail.gmail.com>
Organization: AS2917.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

On Wed, 1 Sep 2010 12:41:59 +0300
Pekka Enberg <penberg@kernel.org> wrote:

> On Wed, Sep 1, 2010 at 12:35 PM, Paul Rolland <rol@as2917.net> wrote:
> > I was surprised to see my machine using so much swap when I couldn't
> > find where all the memory was gone, and I checked quickly what slabtop
> > had to say, and found that one :
> >
> >  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
> > 10172288 10171996  99%    0.03K  90824      112    363296K size-32
> >
> 
> Might be related to this:
> 
> http://kerneltrap.org/mailarchive/linux-kernel/2010/8/25/4611329
 
Yes, considering that lspci also confirms my machine has some common points 
with Matt's one :

[root@tux Archives]# lspci
...
00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)

and

[root@tux Archives]# dmesg | grep drm
[drm] Initialized drm 1.1.0 20060810
[drm] set up 31M of stolen space
fbcon: inteldrmfb (fb0) is primary device
fb0: inteldrmfb frame buffer device
drm: registered panic notifier
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU idle, missed IRQ.
[drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU idle, missed IRQ.
[drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU idle, missed IRQ.
[drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 51
[drm:drm_edid_block_valid] *ERROR* Raw EDID:
[drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU idle, missed IRQ.
[drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU idle, missed IRQ.
[drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU idle, missed IRQ.
[drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU idle, missed IRQ.

Paul
