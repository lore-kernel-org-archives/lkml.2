Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab1FJD1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 23:27:16 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43814 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab1FJD1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 23:27:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DF18F03.6040304@jp.fujitsu.com>
Date: Fri, 10 Jun 2011 12:26:59 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: peterz@infradead.org
CC: dvhart@linux.intel.com, david@rgmadvisors.com, kyle@moffetthome.net,
        luto@mit.edu, eric.dumazet@gmail.com, linux-kernel@vger.kernel.org,
        sbohrer@rgmadvisors.com, zvonler@rgmadvisors.com, hughd@google.com,
        tglx@linutronix.de, mingo@elte.hu
Subject: Re: Change in functionality of futex() system call.
References: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com>	 <1307373819.3098.40.camel@edumazet-laptop>	 <1307376672.2322.167.camel@twins>	<1307376989.2322.171.camel@twins>	 <1307377349.3098.65.camel@edumazet-laptop>	 <1307377782.2322.183.camel@twins>	 <1307378564.3098.67.camel@edumazet-laptop>	 <4DED1421.5000300@linux.intel.com>	 <1307383898.3098.90.camel@edumazet-laptop>	<4DED976C.90009@linux.intel.com>	 <4DEE3944.5020005@mit.edu>	<1307462300.3091.39.camel@edumazet-laptop>	 <BANLkTinyuHUGXACJYUT241g8rzg6AzPBiA@mail.gmail.com>	 <BANLkTinHEyRnnJqB=GTwBOAb6aRaHnjQLQ@mail.gmail.com>	 <BANLkTi=uQmePFOJUx=bdTsnFuFa+ZaYqVw@mail.gmail.com>	 <BANLkTi=vwJBgkKSY_Cq_jQS-71gH6uOPaw@mail.gmail.com>	 <BANLkTinL60RXZNH1QW9NdrTv10TckgWFcg@mail.gmail.com>	 <4DEFA18A.2000808@linux.intel.com>  <4DF0B072.8060204@jp.fujitsu.com> <1307621110.3941.78.camel@twins>
In-Reply-To: <1307621110.3941.78.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/09 21:05), Peter Zijlstra wrote:
> On Thu, 2011-06-09 at 20:37 +0900, KOSAKI Motohiro wrote:
>> 1) check the pte of the target address is RW attribute.
>>  2-1) if yes, it has no COW chance. we can safely use gup result.
>>  2-2) if no, we have to fallback slow vma walk. maybe, it's okey.
>>       both RO mappings and COW are rare situation. 
> 
> Not so, clean file pages are RO, even if the vma is writable. We use the
> fault to track dirty state with.

Right you are. Sigh. Please forget my previous mail.

