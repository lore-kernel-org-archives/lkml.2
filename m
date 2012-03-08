Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab2CHKIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 05:08:30 -0500
Received: from goliath.siemens.de ([192.35.17.28]:25508 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab2CHKI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 05:08:28 -0500
Message-ID: <4F588504.5010205@siemens.com>
Date: Thu, 08 Mar 2012 11:08:04 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 2/2 v3] deal with guest panicked event
References: <4F58664D.1070800@cn.fujitsu.com> <4F5868C4.2090509@cn.fujitsu.com>
In-Reply-To: <4F5868C4.2090509@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-03-08 09:07, Wen Congyang wrote:
> When the host knows the guest is panicked, it will set
> exit_reason to KVM_EXIT_GUEST_PANICKED. So if qemu receive
> this exit_reason, we can send a event to tell management
> application that the guest is panicked and set the guest
> status to RUN_STATE_PANICKED.
> 
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> ---
>  kvm-all.c        |    4 ++++
>  monitor.c        |    3 +++
>  monitor.h        |    1 +
>  qapi-schema.json |    2 +-
>  qmp.c            |    3 ++-
>  vl.c             |    1 +
>  6 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/kvm-all.c b/kvm-all.c
> index 77eadf6..01062af 100644
> --- a/kvm-all.c
> +++ b/kvm-all.c
> @@ -1290,6 +1290,10 @@ int kvm_cpu_exec(CPUState *env)
>                      (uint64_t)run->hw.hardware_exit_reason);
>              ret = -1;
>              break;
> +        case KVM_EXIT_GUEST_PANICKED:
> +            monitor_protocol_event(QEVENT_GUEST_PANICKED, NULL);
> +            vm_stop(RUN_STATE_PANICKED);
> +            break;

You're still lacking "ret = -1;".

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
