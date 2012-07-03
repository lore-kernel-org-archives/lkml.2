Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459Ab2GCKlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 06:41:44 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:44525 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab2GCKln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 06:41:43 -0400
Date: Tue, 3 Jul 2012 12:41:35 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: X86-ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH -v2 1/2] x86, microcode: Sanitize per-cpu microcode
 reloading interface
Message-ID: <20120703104135.GA12820@aftab.osrc.amd.com>
References: <1340280437-7718-1-git-send-email-bp@amd64.org>
 <1340280437-7718-2-git-send-email-bp@amd64.org>
 <1340380019.18025.82.camel@twins>
 <20120626194043.GB28495@aftab.osrc.amd.com>
 <1340747178.21991.105.camel@twins>
 <20120703043717.GB8860@aftab.osrc.amd.com>
 <1341307568.23484.54.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341307568.23484.54.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 11:26:08AM +0200, Peter Zijlstra wrote:
> On Tue, 2012-07-03 at 06:37 +0200, Borislav Petkov wrote:
> > In thinking about this a bit more, perf callback is only run from the
> > reload_store interface but we don't run it on module init time. 
> 
> @@ -557,7 +560,8 @@ static int __init microcode_init(void)
>         mutex_lock(&microcode_mutex);
> 
>         error = subsys_interface_register(&mc_cpu_interface);
> -
> +       if (!error)
> +               perf_check_microcode();
>         mutex_unlock(&microcode_mutex);
>         put_online_cpus();
> 
> 
> I thought that was init time?

Doh, I'm blind, sorry :-/

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
