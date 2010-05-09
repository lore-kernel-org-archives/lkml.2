Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868Ab0EIIVM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 04:21:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59192 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab0EIIVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 04:21:11 -0400
Message-ID: <4BE6705C.3000206@zytor.com>
Date: Sun, 09 May 2010 01:20:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       greg@kroah.com, hjanssen@microsoft.com, ksrinivasan@novell.com,
       dtor@vmware.com, tglx@linutronix.de, akataria@vmware.com
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/cpu] Modify the VMware balloon driver for the new x86_hyper
 API
References: <4BE49778.6060800@zytor.com> <tip-a10a569806e43b9be5fce60b21f836b50b1010e4@git.kernel.org>
In-Reply-To: <tip-a10a569806e43b9be5fce60b21f836b50b1010e4@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2010 01:19 AM, tip-bot for H. Peter Anvin wrote:
>  
>  MODULE_AUTHOR("VMware, Inc.");
>  MODULE_DESCRIPTION("VMware Memory Control (Balloon) Driver");
> @@ -767,7 +767,7 @@ static int __init vmballoon_init(void)
>  	 * Check if we are running on VMware's hypervisor and bail out
>  	 * if we are not.
>  	 */
> -	if (!vmware_platform())
> +	if (x86_hyper != &x86_hyper_vmware)
>  		return -ENODEV;
>  
>  	vmballoon_wq = create_freezeable_workqueue("vmmemctl");

Note: I did not change the existing code, but this is an example of a
very common bug: the appropriate error code for "hardware is not
present" is ENXIO, not ENODEV.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

