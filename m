Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab2JOFxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 01:53:49 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:52545 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab2JOFxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 01:53:48 -0400
Message-ID: <507BA4E5.7020608@linux.vnet.ibm.com>
Date: Mon, 15 Oct 2012 11:23:41 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120910 Thunderbird/15.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [RFC PATCH 3/3] Convert mce_disabled
References: <1349878801-15956-1-git-send-email-bp@amd64.org> <1349878801-15956-4-git-send-email-bp@amd64.org> <5077F600.9090605@linux.vnet.ibm.com> <20121012115628.GA14991@aftab.osrc.amd.com>
In-Reply-To: <20121012115628.GA14991@aftab.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12101505-1618-0000-0000-000002A65387
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2012 05:26 PM, Borislav Petkov wrote:
> On Fri, Oct 12, 2012 at 04:20:40PM +0530, Naveen N. Rao wrote:
>> Hi Boris, Thanks for getting to this before I could!
>
> Ah ok, I thought you wasn't interested in doing this anymore :).

Sorry - just got sidetracked a bit, I'm afraid :)

>
>> I had a look but I still feel boolean is a better way to go. With
>> bool, we can get rid of the #defines above and more importantly, the
>> aux field in dev_ext_attribute since that is used in other places
>> too. Further, I suspect we'll still end up using the same or less
>> memory since we don't have that many boolean members within the MCA
>> code.
>
> My main intention was to have all those in a single struct and use a
> single store_bit/show_bit function.
>
> Sure, you can do bools but this'll still be single variables spread
> around in mce.c instead of one single struct mca_config which nicely
> encapsulates all the configuration we do in the MCA code.
>
> Or, you can modify the mca_config I have there and use bools and pass a
> pointer to each actual bool member in each DEVICE_BIT_ATTR invocation
> (and rename it to DEVICE_BOOL_ATTR). Yeah, that could work, unless I'm
> missing something else, of course.

Yes, this is what I had in mind. Though your code for use of bitfield is 
nicely done, I felt use of boolean will fit better in this specific case.


Thanks,
Naveen

