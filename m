Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644Ab0GIFdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 01:33:11 -0400
Received: from claw.goop.org ([74.207.240.146]:59941 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815Ab0GIFdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 01:33:09 -0400
Message-ID: <4C36B494.6060801@goop.org>
Date: Thu, 08 Jul 2010 22:33:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Lightning/1.0b2pre Thunderbird/3.0.5
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Matthew Wilcox <matthew@wil.cx>, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       macro@linux-mips.org, kamezawa.hiroyu@jp.fujitsu.com,
       eike-kernel@sf-tec.de
Subject: Re: [PATCH 1/2] x86: ioremap: fix wrong physical address handling
References: <4C197A49.6020400@jp.fujitsu.com> <4C197A9E.5040509@jp.fujitsu.com> <20100617025052.GH9298@parisc-linux.org> <4C19A2EE.2010203@zytor.com> <4C19AABA.8000706@jp.fujitsu.com> <4C19BA9A.4010300@zytor.com> <4C19EC57.3000409@goop.org> <20100709042421.GB2951@verge.net.au>
In-Reply-To: <20100709042421.GB2951@verge.net.au>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2010 09:24 PM, Simon Horman wrote:
>> I think it would be a pretty large change.  From the Xen's perspective,
>> any machine even approximately approaching the 2^44 limit will be
>> capable of running Xen guests in hvm mode, so PV isn't really a concern.
>>     
> Hi Jeremy,
>
> Is the implication of that statement that HVM is preferred where
> supported by HW?
>   

I wouldn't go that far; the PV vs HVM choice is pretty complex, and
depends on what your workload is and what hardware you have available. 
All I meant was what I said: that if you're running on a machine with a
large amount of memory, then you should run your 32-bit domains as HVM
rather than PV.  Though Xen could easily keep domains limited to memory
that they can actually use (it already does this, in fact).

    J
