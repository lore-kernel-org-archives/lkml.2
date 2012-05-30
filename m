Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab2E3TRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 15:17:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab2E3TRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 15:17:13 -0400
Date: Wed, 30 May 2012 16:17:20 -0300
From: Luiz Capitulino <lcapitulino@redhat.com>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [Qemu-devel] [PATCH 1/3] start vm after reseting it
Message-ID: <20120530161720.7c9b88b9@doriath.home>
In-Reply-To: <4FB9E57C.5040003@cn.fujitsu.com>
References: <4FB9E4CE.8060709@cn.fujitsu.com>
	<4FB9E57C.5040003@cn.fujitsu.com>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2012 14:49:32 +0800
Wen Congyang <wency@cn.fujitsu.com> wrote:

> The guest should run after reseting it, but it does not
> run if its old state is RUN_STATE_INTERNAL_ERROR or RUN_STATE_PAUSED.
> 
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> ---
>  vl.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/vl.c b/vl.c
> index 23ab3a3..7f5fed8 100644
> --- a/vl.c
> +++ b/vl.c
> @@ -1539,6 +1539,7 @@ static bool main_loop_should_exit(void)
>          if (runstate_check(RUN_STATE_INTERNAL_ERROR) ||
>              runstate_check(RUN_STATE_SHUTDOWN)) {
>              runstate_set(RUN_STATE_PAUSED);
> +            vm_start();

Please, drop the runstate_set() call. I think you also have to
to call bdrv_iostatus_reset(), as qmp_cont() does.

>          }
>      }
>      if (qemu_powerdown_requested()) {

