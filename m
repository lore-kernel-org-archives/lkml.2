Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab0KKFTE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 00:19:04 -0500
Received: from [120.204.251.227] ([120.204.251.227]:45670 "EHLO
	LC-SHMAIL-01.SHANGHAI.LEADCORETECH.COM" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751461Ab0KKFTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 00:19:02 -0500
Message-ID: <4CDB7CC9.9040203@leadcoretech.com>
Date: Thu, 11 Nov 2010 13:19:05 +0800
From: "Figo.zhang" <zhangtianfei@leadcoretech.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; zh-CN; rv:1.9.2.12) Gecko/20101028 Lightning/1.0b2 Lanikai/3.1.6
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] oom: create a resource limit for oom_adj
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Nov 2010 05:18:58.0358 (UTC) FILETIME=[F17D2D60:01CB815F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>   	if (oom_adjust<  task->signal->oom_adj&&  !capable(CAP_SYS_RESOURCE)) {
> -		err = -EACCES;
> -		goto err_sighand;
> +		/* convert oom_adj [15,-17] to rlimit style value [1,33] */
> +		long oom_rlim = OOM_ADJUST_MAX + 1 - oom_adjust;
> +
> +		if (oom_rlim>  task->signal->rlim[RLIMIT_OOMADJ].rlim_cur) {
> +			unlock_task_sighand(task,&flags);
> +			put_task_struct(task);
> +			err = -EACCES;
> +			goto err_sighand;
> +		}
>   	}

=> Label "err_sighand" have do that, why are you do that on here?

+			err = -EACCES;
+			goto err_sighand;
+		}
 	}


