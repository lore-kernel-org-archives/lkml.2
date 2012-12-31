Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab2LaD1h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 22:27:37 -0500
Received: from intranet.asianux.com ([58.214.24.6]:2295 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab2LaD1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 22:27:33 -0500
X-Spam-Score: -100.8
Message-ID: <50E10658.4000507@asianux.com>
Date: Mon, 31 Dec 2012 11:28:24 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Omar Ramirez Luna <omar.ramirez@copitl.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] drivers/staging/tidspbridge:  strcpy and strncpy,
  src length checking issue.
References: <50CAA1F2.9000003@asianux.com>
In-Reply-To: <50CAA1F2.9000003@asianux.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Omar Ramirez Luna:

Since you are really too busy.
  is it suitable to send a patch for it, by me ?

  no reply within a week, means it is suitable.

  :-)

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
