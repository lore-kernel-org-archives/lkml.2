Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030327Ab2CBPk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 10:40:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20836 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757447Ab2CBPkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 10:40:55 -0500
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=iqH1YQEIiWMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=oRqBtgwPD9d6bcF6oncA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1330702854.25686.267.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH RT 7/9][RFC] [PATCH 7/9] cpu/rt: Rework cpu down for
 PREEMPT_RT
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <C.Emde@osadl.org>, John Kacur <jkacur@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>
Date: Fri, 02 Mar 2012 10:40:54 -0500
In-Reply-To: <1330702617.25686.265.camel@gandalf.stny.rr.com>
References: <20120301185527.064629423@goodmis.org>
	 <20120301190346.172835662@goodmis.org>
	 <alpine.LFD.2.02.1203021518501.2742@ionos>
	 <1330701323.25686.260.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.02.1203021618330.2742@ionos>
	 <1330702617.25686.265.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-02 at 10:36 -0500, Steven Rostedt wrote:
>  
> +#ifdef CONFIG_PREEMPT_RT_FULL
> +# define hotplug_lock() spin_lock(&cpu_hotplug.lock)
> +# define hotplug_unlock() spin_unlock(&cpu_hotplug.lock)
> +#else
> +# define hotplug_lock() mutex_lock(&cpu_hotplug.lock)
> +# define hotplug_lock() mutex_unlock(&cpu_hotplug.lock)

# define hotplug_unlock() mutex_unlock(&cpu_hotplug.lock)

Proof it doesn't comply.

-- Steve

> +#endif



