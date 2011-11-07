Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122Ab1KGRyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 12:54:08 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:47648 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933138Ab1KGRyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 12:54:06 -0500
Date: Mon, 7 Nov 2011 18:54:02 +0100
From: Borislav Petkov <bp@amd64.org>
To: Dave Jones <davej@redhat.com>
Cc: x86@kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: BAD APICID ?
Message-ID: <20111107175402.GA3384@gere.osrc.amd.com>
References: <20111107173948.GA1344@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111107173948.GA1344@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 12:39:48PM -0500, Dave Jones wrote:
> We got a report from a Fedora user hitting a WARN_ON in the apic setup code.
> 
> Here..
> 
> 1230 #ifdef CONFIG_X86_32
> 1231         /*
> 1232          * APIC LDR is initialized.  If logical_apicid mapping was
> 1233          * initialized during get_smp_config(), make sure it matches the
> 1234          * actual value.
> 1235          */
> 1236         i = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
> 1237         WARN_ON(i != BAD_APICID && i != logical_smp_processor_id());
> 1238         /* always use the value from LDR */
> 1239         early_per_cpu(x86_cpu_to_logical_apicid, cpu) =
> 1240                 logical_smp_processor_id();
> 
> The full report is at https://bugzilla.redhat.com/show_bug.cgi?id=743930
> 
> Report is against our 3.0 builds, but that code look unchanged in 3.1 too,
> and even in current Linus head.
> 
> Any thoughts on what could cause this ?

Already fixed upstream: 838312be46f3abfbdc175f81c3e54a857994476d

Here's the whole thread: http://lkml.org/lkml/2011/10/14/231

HTH.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
