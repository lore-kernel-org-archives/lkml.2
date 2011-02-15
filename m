Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab1BOR34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 12:29:56 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:63628 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703Ab1BOR3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 12:29:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MqUYoy7Ln60RD9qA7qDXx6ZUQHRNOeJrLqyss7Do86gLrxyt7jBYIPLXoNtE0iWaGX
         ua0hXJVQqJbD85FJC6Y//RPtOXqZCXZ35/+xOMb8235udTaSJE/UmJdw2fA83JSJQdkl
         94reJdqxfQUybs/X6doedCfhoWLbyrYZjjgl0=
Date: Tue, 15 Feb 2011 18:29:41 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Mike Frysinger <vapier@gentoo.org>, Paul Mackerras <paulus@samba.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH V10 12/15] ptp: Added a brand new class driver for ptp
 clocks.
Message-ID: <20110215172941.GA21150@riccoc20.at.omicron.at>
References: <cover.1296124770.git.richard.cochran@omicron.at>
 <ada07b1d09b1e8eb717c5203e64856d2eaad7456.1296124770.git.richard.cochran@omicron.at>
 <1296612031.3336.201.camel@work-vm>
 <20110211081524.GA12270@riccoc20.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110211081524.GA12270@riccoc20.at.omicron.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 09:15:24AM +0100, Richard Cochran wrote:
> On Tue, Feb 01, 2011 at 06:00:31PM -0800, John Stultz wrote:
> > So what is serializing access to the timestamp_event_queue here? I don't
> > see any usage of tsevq_mux by the callers. Am I missing it? It looks
> > like its called from interrupt context, so do you really need a spinlock
> > and not a mutex here?
> 
> The external timestamp FIFO is written only from interrupt context.

Oops, I lied. After reworking the phyter driver, I find that I want to
enqueue time stamps from non-interrupt contexts, too.

So, you are right. This will need a spin lock...

Thanks,

Richard
