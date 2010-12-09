Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab0LIQS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 11:18:58 -0500
Received: from freeflow.nu ([178.79.134.28]:34899 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057Ab0LIQS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 11:18:57 -0500
Subject: Re: [PATCH UPDATED#3 04/16] x86: setup_local_APIC() must always be
 called with preemption disabled
From: Pekka Enberg <penberg@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org, brgerst@gmail.com, gorcunov@gmail.com
In-Reply-To: <4D00B3B9.7060702@kernel.org>
References: <1290871325-3055-1-git-send-email-tj@kernel.org>
	 <1290871325-3055-5-git-send-email-tj@kernel.org>
	 <4D00B3B9.7060702@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 09 Dec 2010 18:18:54 +0200
Message-ID: <1291911534.29040.0.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-09 at 11:47 +0100, Tejun Heo wrote:
> setup_local_APIC() is used to setup local APIC early during CPU
> initialization and already assumes that preemption is disabled on
> entry.  However, The function unnecessarily disables and enables
> preemption and uses smp_processor_id() multiple times in and out of
> the nested preemption disabled section.  This gives the wrong
> impression that the function might be able to handle being called with
> preemption enabled and/or migrated to another processor in the middle.
> 
> Make it clear that the function is always called with preemption
> disabled, drop the confusing preemption disable block and call
> smp_processor_id() once at the beginning of the function.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Cyrill Gorcunov <gorcunov@gmail.com>
> Cc: Pekka Enberg <penberg@kernel.org>

Reviewed-by: Pekka Enberg <penberg@kernel.org>

