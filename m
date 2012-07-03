Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab2GCJ0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 05:26:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57216 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab2GCJ0b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 05:26:31 -0400
Message-ID: <1341307568.23484.54.camel@twins>
Subject: Re: [PATCH -v2 1/2] x86, microcode: Sanitize per-cpu microcode
 reloading interface
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: X86-ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Stephane Eranian <eranian@google.com>
Date: Tue, 03 Jul 2012 11:26:08 +0200
In-Reply-To: <20120703043717.GB8860@aftab.osrc.amd.com>
References: <1340280437-7718-1-git-send-email-bp@amd64.org>
	 <1340280437-7718-2-git-send-email-bp@amd64.org>
	 <1340380019.18025.82.camel@twins>
	 <20120626194043.GB28495@aftab.osrc.amd.com>
	 <1340747178.21991.105.camel@twins>
	 <20120703043717.GB8860@aftab.osrc.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-03 at 06:37 +0200, Borislav Petkov wrote:
> In thinking about this a bit more, perf callback is only run from the
> reload_store interface but we don't run it on module init time. 

@@ -557,7 +560,8 @@ static int __init microcode_init(void)
        mutex_lock(&microcode_mutex);

        error = subsys_interface_register(&mc_cpu_interface);
-
+       if (!error)
+               perf_check_microcode();
        mutex_unlock(&microcode_mutex);
        put_online_cpus();


I thought that was init time?
