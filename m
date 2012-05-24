Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab2EXLom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 07:44:42 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51472 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab2EXLok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 07:44:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAJd=RBBSn7WfYgUPdDY8eTd2cy-R6uR_YKV39z4rLvu0-BkCfQ@mail.gmail.com>
References: <CAJd=RBBSn7WfYgUPdDY8eTd2cy-R6uR_YKV39z4rLvu0-BkCfQ@mail.gmail.com>
Date: Thu, 24 May 2012 19:44:39 +0800
Message-ID: <CAJd=RBB1R5a_rtgFXMASX47_cD=4kKinX5WjAfYr1K_EDe=LEw@mail.gmail.com>
Subject: Re: [patch] BFS 420: fix clear_sticky when breaking sole affinity
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q4OBikYe031142

On Wed, May 23, 2012 at 8:55 PM, Hillf Danton <dhillf@gmail.com> wrote:
> The sticky bit is cleared after checking the task with the bit set for
> given CPU.
>
> --- a/kernel/sched/bfs.c Â  Â  Â  Â Mon May 14 20:50:38 2012
> +++ b/kernel/sched/bfs.c Â  Â  Â  Â Wed May 23 20:16:18 2012
> @@ -5153,7 +5153,8 @@ static void break_sole_affinity(int src_
> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  task_pid_nr(p), p->comm, src_cpu);
> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â }
> Â  Â  Â  Â  Â  Â  Â  Â }
> - Â  Â  Â  Â  Â  Â  Â  clear_sticky(p);
> + Â  Â  Â  Â  Â  Â  Â  if (task_sticky(p) && task_cpu(p) == src_cpu)
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  clear_sticky(p);
> Â  Â  Â  Â } while_each_thread(t, p);
> Â }
>
> --
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
