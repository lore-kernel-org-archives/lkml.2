Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab0IWUsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 16:48:16 -0400
Received: from mx2.compro.net ([12.186.155.4]:57420 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755358Ab0IWUsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 16:48:15 -0400
X-IronPort-AV: E=Sophos;i="4.57,225,1283745600"; 
   d="scan'208";a="5849777"
Message-ID: <4C9BBD0E.4010804@compro.net>
Date: Thu, 23 Sep 2010 16:48:14 -0400
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: line BRK detection on ttyS0
References: <4C9A5AD0.5070804@compro.net> <20100923010329.0a66546c@lxorguk.ukuu.org.uk>
In-Reply-To: <20100923010329.0a66546c@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2010 08:03 PM, Alan Cox wrote:
> On Wed, 22 Sep 2010 15:36:48 -0400
> Mark Hounschell <markh@compro.net> wrote:
> 
>> Does the kernel support sending a SIGINT from a line BRK on ttyS0 to a thread of a process
>> where the process has a controlling terminal that is NOT ttyS0 and the thread is using ttyS0
>> in a cfmakeraw mode? I see doc that implies that ttyS0 must be the controlling terminal but
>> can my thread have a controlling terminal while my main process has it's own ?
> 
> If they have two different ttys open then yes at least as far as Linux is
> concerned. I don't know how glibc handles it as it can do signal groups
> and the like and delivery of signals to process not threads etc.
> 
> You can see parity anyway. In PARMRK mode you get \377 \0 [whatever] for
> parity/break etc but \377 is also doubled for a real one - ie \377 \377
> 

\377 \0  or  [whatever] just looks like valid data to my thread though.
So you're saying it's gonna be a glibc thing and not a kernel thing that
prevents my thread from getting a signal?

Thanks
Mark




