Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab2H2NMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 09:12:43 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:33826 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab2H2NMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 09:12:41 -0400
Message-ID: <503E14DC.3060507@linux.vnet.ibm.com>
Date: Wed, 29 Aug 2012 18:40:52 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: tony.luck@intel.com, andi@firstfloor.org, ananth@in.ibm.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
        hpa@zytor.com, tglx@linutronix.de, linux-edac@vger.kernel.org
Subject: Re: [PATCH RFC] x86/mce: Move MCE sysfs attributes out of the per-cpu
 location
References: <20120829074154.6755.98941.stgit@localhost.localdomain> <20120829101302.GA26977@aftab.osrc.amd.com> <503DEE3C.6020406@linux.vnet.ibm.com> <20120829104018.GD26977@aftab.osrc.amd.com>
In-Reply-To: <20120829104018.GD26977@aftab.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12082913-6102-0000-0000-00000223FDAD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2012 04:10 PM, Borislav Petkov wrote:
> On Wed, Aug 29, 2012 at 03:56:04PM +0530, Naveen N. Rao wrote:
>> Hmmm.. Can't we just deprecate these? ;) Perhaps we can consider
>> adding newer tunables in the right place.
>
> In case you haven't noticed yet: I'm all on your side.

Yup, I know :)

I had my doubts when I sent this patch (hence the RFC tag) and I was 
only wondering above if it'll be a good idea to limit such tunables 
going forward. We could force all _new_ MCE tunables to be global, 
except where they actually apply on a per-processor basis.

>
> But let me ask you this: these attributes grow to a large number with
> a large number of cores but why is this a problem? We have a bunch of
> redundant attributes in sysfs, so what?
>
> See what I mean?
>

Well, it's ugly and does not make much sense, as I'm sure you noticed. 
On a 10-core, 8-socket machine with HT, we'll end up with nearly a 
thousand such entries!

I don't know how much resource this takes up (if any) and like you said, 
this may just be a "so what?", but I wanted to bring this up and see if 
we could/want to do anything about this. I'm certainly fine if we want 
to ignore this.


Thanks,
Naveen

