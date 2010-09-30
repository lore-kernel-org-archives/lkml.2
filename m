Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab0I3NLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 09:11:21 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47100 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab0I3NLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 09:11:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:mime-version
         :content-type;
        b=Vzf8iKvKfU3AR/CXoKS6JrwkERt1OELMiiWMgvlKdKKSsGZW95k67bwZl2X6apBJlF
         isH9xi/WXKWxIDgkLq3dH5xNeNgdG3Ceuh/OujltEt/e55mL63koF/k/4PIp4+t2C0pP
         u+riNFoR4tg5E6teCSIS47P1nmi21yMnhhMys=
Date: Thu, 30 Sep 2010 21:11:07 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: Wu Fengguang <fengguang.wu@intel.com>, Takashi Iwai <tiwai@suse.de>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org
Subject: Re: Microphone not working on PCI ID 8086:3b56
Message-ID: <Pine.LNX.4.64.1009302047410.25061@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, Sep 28, 2010 at 9:42 PM, Takashi Iwai <tiwai@suse.de> wrote:
> Enable all CONFIG_SND_HDA_*.

Done that. Still no mic.


On Tue, Sep 28, 2010 at 9:42 PM, Wu Fengguang <fengguang.wu@intel.com> 
wrote:
> It's easier to enable all of them. They are small modules.

Tried just about everything, still no mic. Sounds works in all cases.


I found that with SND_HDA_CODEC_INTELHDMI selected, SND_DYNAMIC_MINORS 
will be enabled by default which won't work in my case as I'm not using 
udev. Here's a patch to take away the default so non-udev will still 
works.

Do I really need udev to get mic to work?

Thanks,
Jeff




--- lx/sound/pci/hda/Kconfig.org	2010-09-14 16:34:52.000000000 +0800
+++ lx/sound/pci/hda/Kconfig	2010-09-14 16:35:09.000000000 +0800
@@ -145,7 +145,6 @@

  config SND_HDA_CODEC_INTELHDMI
  	bool "Build INTEL HDMI HD-audio codec support"
-	select SND_DYNAMIC_MINORS
  	default y
  	help
  	  Say Y here to include INTEL HDMI HD-audio codec support in

