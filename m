Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762270Ab0HGM1t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 08:27:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:37012 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101Ab0HGM1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 08:27:48 -0400
Message-ID: <4C5D512A.2070103@kernel.org>
Date: Sat, 07 Aug 2010 14:27:22 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] percpu: add missing markups in kernel/workqueue.c
References: <1281119187-12640-3-git-send-email-namhyung@gmail.com>
In-Reply-To: <1281119187-12640-3-git-send-email-namhyung@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 07 Aug 2010 12:27:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2010 08:26 PM, Namhyung Kim wrote:
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  kernel/workqueue.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 327d2de..bb030e3 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -57,7 +57,7 @@ struct cpu_workqueue_struct {
>   * per-CPU workqueues:
>   */
>  struct workqueue_struct {
> -	struct cpu_workqueue_struct *cpu_wq;
> +	struct cpu_workqueue_struct __percpu *cpu_wq;
>  	struct list_head list;
>  	const char *name;
>  	int singlethread;
> @@ -821,7 +821,7 @@ int schedule_on_each_cpu(work_func_t func)
>  {
>  	int cpu;
>  	int orig = -1;
> -	struct work_struct *works;
> +	struct work_struct __percpu *works;
>  
>  	works = alloc_percpu(struct work_struct);
>  	if (!works)

Can you please redo this patch against the following git tree?

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-linus

Thanks.

-- 
tejun
