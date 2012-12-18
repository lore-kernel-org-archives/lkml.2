Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751096Ab2LRFC6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 00:02:58 -0500
Received: from intranet.asianux.com ([58.214.24.6]:28703 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab2LRFC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 00:02:57 -0500
X-Spam-Score: -100.7
Message-ID: <50CFF937.3020101@asianux.com>
Date: Tue, 18 Dec 2012 13:03:51 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Omar Ramirez Luna <omar.ramirez@copitl.com>
CC: "l >> \"linux-kernel@vger.kernel.org\"" 
	<linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] drivers/staging/tidspbridge:  strcpy and strncpy,
  src length checking issue.
References: <50CFD786.5010101@asianux.com>
In-Reply-To: <50CFD786.5010101@asianux.com>
X-Forwarded-Message-Id: <50CFD786.5010101@asianux.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Omar Ramirez Luna:

  excuse me to bother you (maybe you are busy in these days).
  please help checking this suggestion when you have free time.

  my suggestion may be not valid (I already have at least 9 fault which
I made)
  for example of my fault:
    A) net/atm:  "%pM means format this pointer as a mac address", thank
Chas Williams
    B) net/tipc: "TIPC_MAX_IF_NAME is not TIPC_MAX_LINK_NAME", thank Xue
Ying
    C) net/core: "not see 'if (PAGE_SIZE - len < 3)' ", find by myself
    D) MAINTAINER: "tty != serial",  thank Jiri Slaby and Joe Perches
    E) drvers/staging/telephony: "torvalds' tree is different with next
tree", thank devendra.aaru
    F) drivers/staging/telephony: "we should probably fix it for older
kernels", thank Dan Carpenter
    G) drivers/usb/core: "doing DMA on the stack violates the DMA
rules", thank Oliver Neukum
    H) arch/blackfin/kernel: "%8s is used to take up the same space",
thank Mike Frysinger and Steven Miao
    I) drivers/usb/host: "usb_hcd_giveback_urb set urb->hcpriv to NULL",
thank Alan Stern

  finding and solving issues is a way (not a goal) to provide
contributes to Open Source.
  so I hope:
    When you have free time, also can provide your contributes to Open
Source, too.

  thanks.


By the way:
  this week, I need work for 2 patches which relative with usb sub-system.
  if still get no reply for tidspbridge until next week.
    I should work for it, it is my duty (since I have provided
'suggestion' to it).
    "work for it" means:
       if tidspbridge is still useful
         I need construct relative environments for unit test.
         then provide relative patches.
       else (useless)
         I need delete it from Open Source.
         (since it can not pass compiling, and no response from
*@ti.com, it almost means useless)
         (at least, fix the 2 compiling issues which I have suggested,
can pass compiling)


  welcome any other members to giving suggestions and completions
(especially from *@ti.com)


  Regards

gchen.


于 2012年12月14日 11:50, Chen Gang 写道:
> Hello Omar Ramirez Luna:
> 
>   in drivers/staging/tidspbridge/rmgr/proc.c:
> 
>     if strlen(drv_datap->base_img) == size, will pass checking (line 397)
>     the size is the full length of exec_file (line 382, line 468..469)
>     strcpy causes issue: src len is strlen(drv_datap->base_img) + '\0'. (line 400)
> 
>     strncpy seems also has issue: need use size instead of strlen(iva_img) + 1. (line 402..403)
> 
>   please help to check, thanks.
> 
> gchen.
> 
> 
>  380 static int get_exec_file(struct cfg_devnode *dev_node_obj,
>  381                                 struct dev_object *hdev_obj,
>  382                                 u32 size, char *exec_file)
>  383 {
>  384         u8 dev_type;
>  385         s32 len;
>  386         struct drv_data *drv_datap = dev_get_drvdata(bridge);
>  387 
>  388         dev_get_dev_type(hdev_obj, (u8 *) &dev_type);
>  389 
>  390         if (!exec_file)
>  391                 return -EFAULT;
>  392 
>  393         if (dev_type == DSP_UNIT) {
>  394                 if (!drv_datap || !drv_datap->base_img)
>  395                         return -EFAULT;
>  396 
>  397                 if (strlen(drv_datap->base_img) > size)
>  398                         return -EINVAL;
>  399 
>  400                 strcpy(exec_file, drv_datap->base_img);
>  401         } else if (dev_type == IVA_UNIT && iva_img) {
>  402                 len = strlen(iva_img);
>  403                 strncpy(exec_file, iva_img, len + 1);
>  404         } else {
>  405                 return -ENOENT;
>  406         }
>  407 
>  408         return 0;
>  409 }
>  410 
>  ...
> 
>  465         /* Get the default executable for this board... */
>  466         dev_get_dev_type(hdev_obj, (u8 *) &dev_type);
>  467         p_proc_object->processor_id = dev_type;
>  468         status = get_exec_file(dev_node_obj, hdev_obj, sizeof(sz_exec_file),
>  469                                sz_exec_file);
> 


-- 
Chen Gang

Asianux Corporation


