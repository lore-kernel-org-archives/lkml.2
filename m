Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab1BOQv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 11:51:29 -0500
Received: from service87.mimecast.com ([94.185.240.25]:35856 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752716Ab1BOQv1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 11:51:27 -0500
Subject: Re: [PATCH v2] ARM: vfp: Always save VFP state in vfp_pm_suspend
From: Catalin Marinas <catalin.marinas@arm.com>
To: Colin Cross <ccross@android.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <1297724147-6320-1-git-send-email-ccross@android.com>
References: <AANLkTik_Jey_PtRmr530FVckA6RXHESeX+CyoJC=ZTkR@mail.gmail.com>
	 <1297724147-6320-1-git-send-email-ccross@android.com>
Organization: ARM Limited
Date: Tue, 15 Feb 2011 16:51:19 +0000
Message-ID: <1297788679.28844.4.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 15 Feb 2011 16:51:22.0217 (UTC) FILETIME=[9336FD90:01CBCD30]
X-MC-Unique: 111021516512400501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-14 at 22:55 +0000, Colin Cross wrote:
> vfp_pm_suspend should save the VFP state any time there is
> a last_VFP_context.  If it only saves when the VFP is enabled,
> the state can get lost when, on a UP system:
>    Thread 1 uses the VFP
>    Context switch occurs to thread 2, VFP is disabled but the
>       VFP context is not saved to allow lazy save and restore
>    Thread 2 initiates suspend
>    vfp_pm_suspend is called with the VFP disabled, but the
>       context has not been saved.
> 
> Modify vfp_pm_suspend to save the VFP context whenever
> last_VFP_context is set.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Colin Cross <ccross@android.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>


