Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab2KNCAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 21:00:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12432 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139Ab2KNCAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 21:00:41 -0500
X-Authority-Analysis: v=2.0 cv=RoZH3VaK c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=LmWu7n8Vm5kA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=c4Q_C9-CEacA:10 a=3ZRmdFY4J84Ixj8lyboA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1352858437.18025.47.camel@gandalf.local.home>
Subject: Re: [RFC PATCH 0/2] kvm/vmx: Output TSC offset
From: Steven Rostedt <rostedt@goodmis.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
        David Sharp <dhsharp@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 13 Nov 2012 21:00:37 -0500
In-Reply-To: <20121114013611.5338.15086.stgit@yunodevel>
References: <20121114013611.5338.15086.stgit@yunodevel>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-14 at 10:36 +0900, Yoshihiro YUNOMAE wrote:

> To merge the data like previous pattern, we apply this patch set. Then, we can
> get TSC offset of the guest as follows:
> 
> $ dmesg | grep kvm
> [   57.717180] kvm: (2687) write TSC offset 18446743360465545001, now clock ##
>                      ^^^^                   ^^^^^^^^^^^^^^^^^^^^            |
>                      PID                         TSC offset                 |
>                                                            HOST TSC value --+	
> 

Using printk to export something like this is IMO a nasty hack.

Can't we create a /sys or /proc file to export the same thing?

-- Steve


