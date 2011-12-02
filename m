Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab1LBPdk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 10:33:40 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:43632 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab1LBPdk convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Fri, 2 Dec 2011 10:33:40 -0500
Message-Id: <4ED8FDE102000078000651E5@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 02 Dec 2011 15:33:37 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Borislav Petkov" <bp@amd64.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: [PATCH] x86: fix error paths in microcode_init()
References: <4ED8E2270200007800065120@nat28.tlf.novell.com>
 <20111202143517.GA16690@gere.osrc.amd.com>
 <4ED8F46E0200007800065178@nat28.tlf.novell.com>
 <4ED8EB7D.5070802@linux.vnet.ibm.com>
 <20111202152403.GB16690@gere.osrc.amd.com>
In-Reply-To: <20111202152403.GB16690@gere.osrc.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 02.12.11 at 16:24, Borislav Petkov <bp@amd64.org> wrote:
> On Fri, Dec 02, 2011 at 08:45:09PM +0530, Srivatsa S. Bhat wrote:
>> Your patch fixes the issue more properly than mine, but adding your part
>> on top of my patch makes the code look better. For example,
>> platform_device_unregister() wouldn't need to be called twice; and we 
>> can use the quite popular way of handling error path via goto statements,
>> which makes the code flow much more comprehensible and intuitive.
> 
> Yes,
> 
> goto labels is the proper way for spelling error handling in the kernel
> so I could very well take your patch Jan, instead, if you change it to
> use goto labels for the error path as Srivatsa's patch does it. That is,
> in case Ingo hasn't pulled yet.

Sorry, no, I won't introduce new labels in functions not already using
some (I'm already feeling guilty enough each time I end up doing so
when a function already is coded that way, to limit the impact of a
particular change). This is just bad programming style in my opinion, no
matter what other developers may think on this subject.

Jan

