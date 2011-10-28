Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab1J1Dh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 23:37:58 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57971 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921Ab1J1Dh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 23:37:57 -0400
Message-ID: <4EAA2392.40105@pobox.com>
Date: Thu, 27 Oct 2011 23:37:54 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Lin Ming <ming.m.lin@intel.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Priyanka Gupta <ankaguptaca@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>, "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [RFC] ata port runtime pm
References: <1319772072.24236.0.camel@minggr>
In-Reply-To: <1319772072.24236.0.camel@minggr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2011 11:21 PM, Lin Ming wrote:
> @@ -3208,6 +3209,11 @@ int ata_scsi_queuecmd(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
>
>   	ap = ata_shost_to_port(shost);
>
> +	if (pm_runtime_suspended(&ap->tdev))
> +		pm_runtime_resume(&ap->tdev);
> +	pm_runtime_mark_last_busy(&ap->tdev);
> +	pm_request_autosuspend(&ap->tdev);
> +
>   	spin_lock_irqsave(ap->lock, irq_flags);
>


Putting this into the core command dispatch fast-path is rather 
disappointing.  That's at least one additional lock, plus some atomic 
instructions and tests.

	Jeff


