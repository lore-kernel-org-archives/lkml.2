Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab0KKLhM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 06:37:12 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62595 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab0KKLhL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 06:37:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=mHrno8IOluZOa1AAuaVuUaScqtwDM6KpSCnGo8dvq/Du0xPCUP8jVrzyVbefQpz2Cv
         aFMdByXbkFtgpV3O8FWzWrNPhQUQdeb2oTSlo9BVki/U6MlHedQ2U0t0wFRGDuK+Z4AQ
         EcJRray8mlRgf04RwTvN2ABT27U4NxrwfZmfw=
MIME-Version: 1.0
In-Reply-To: <1289473363-29440-6-git-send-email-tj@kernel.org>
References: <1289473363-29440-1-git-send-email-tj@kernel.org>
	<1289473363-29440-6-git-send-email-tj@kernel.org>
Date: Thu, 11 Nov 2010 13:37:10 +0200
X-Google-Sender-Auth: cy7GSQ9Hitwgl_CCp5FkhKmFKu0
Message-ID: <AANLkTikRiCPs0QNo60MFWWcxWFChdrAZTfVPMP26Efx9@mail.gmail.com>
Subject: Re: [PATCH 5/9] x86: Replace apic->apicid_to_node() with ->numa_cpu_node()
From: Pekka Enberg <penberg@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 1:02 PM, Tejun Heo <tj@kernel.org> wrote:
> apic->apicid_to_node() is 32bit specific apic operation which
> determines NUMA node for a CPU.  Depending on the APIC implementation,
> it can be easier to determine NUMA node from either physical or
> logical apicid.  Currently, ->apicid_to_node() takes @logical_apicid
> and calls hard_smp_processor_id() if the physical apicid is needed.
>
> This prevents NUMA mapping from being queried from a different CPU,
> which in turn makes it impossible to initialize NUMA mapping before
> SMP bringup.
>
> This patch replaces apic->apicid_to_node() with ->numa_cpu_node()
> which takes @cpu, from which both logical and physical apicids can
> easily be determined.  While at it, drop duplicate implementations
> from bigsmp_32 and summit_32, and use the default.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Pekka Enberg <penberg@kernel.org>
