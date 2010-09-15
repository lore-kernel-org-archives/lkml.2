Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab0IOVeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 17:34:20 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:41233 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455Ab0IOVeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 17:34:19 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lnxninja@linux.vnet.ibm.com
References: <20100914234714.8AF506EA@kernel.beaverton.ibm.com>
	<20100915133303.0b232671.kamezawa.hiroyu@jp.fujitsu.com>
	<20100915135016.C9F1.A69D9226@jp.fujitsu.com>
	<1284531262.27089.15725.camel@nimitz>
	<m1d3se7t0h.fsf@fess.ebiederm.org>
	<1284578821.27089.17409.camel@nimitz>
Date: Wed, 15 Sep 2010 14:34:12 -0700
In-Reply-To: <1284578821.27089.17409.camel@nimitz> (Dave Hansen's message of
	"Wed, 15 Sep 2010 12:27:01 -0700")
Message-ID: <m17him4ror.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Dave Hansen <dave@linux.vnet.ibm.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC][PATCH] update /proc/sys/vm/drop_caches documentation
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen <dave@linux.vnet.ibm.com> writes:

> On Wed, 2010-09-15 at 11:37 -0700, Eric W. Biederman wrote:
>> > I'm worried that there are users out there experiencing real problems
>> > that aren't reporting it because "workarounds" like this just paper over
>> > the issue.
>> 
>> For what it is worth.  I had a friend ask me about a system that had 50%
>> of it's memory consumed by slab caches.  20GB out of 40GB.  The kernel
>> was suse? 2.6.27 so it's old, but if you are curious.
>> /proc/sys/vm/drop_caches does nothing in that case. 
>
> Was it the reclaimable caches doing it, though?  The other really common
> cause is kmalloc() leaks.

It was reclaimable caches.  He kept seeing the cache sizes of the
problem caches shrink.  On an idle system he said he was seeing
about 16MB/min getting free or something like that.  Something
that would take hours and hours before things freed up.

I asked and my friend told me that according to slabtop the slab
with the most memory used kept changing dramatically and he could
not see a pattern.

So at least on one old kernel on one strange workload there was a problem.

Eric
