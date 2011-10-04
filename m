Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab1JDOT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 10:19:28 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:38348 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756652Ab1JDOT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 10:19:27 -0400
Message-ID: <4E8B15D4.9080104@austin.ibm.com>
Date: Tue, 04 Oct 2011 09:19:00 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Andrew Morton <akpm00@gmail.com>
CC: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] memory hotplug: Correct page reservation checking
References: <4E8098B9.1080702@austin.ibm.com> <20111003175022.50cbef7f.akpm00@gmail.com>
In-Reply-To: <20111003175022.50cbef7f.akpm00@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11100414-8974-0000-0000-0000009F429E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2011 07:50 PM, Andrew Morton wrote:
> On Mon, 26 Sep 2011 10:22:33 -0500
> Nathan Fontenot <nfont@austin.ibm.com> wrote:
> 
>> The check to ensure that pages of recently added memory sections are correctly
>> marked as reserved before trying to online the memory is broken.  The request
>> to online the memory fails with the following:
>>
>> kernel: section number XXX page number 256 not reserved, was it already online?
>>
>> This updates the page reservation checking to check the pages of each memory
>> section of the memory block being onlined individually.
> 
> Why was this only noticed now?  Is there something unusual about the
> way in which you're using it, or has nobody ever used this code, or...?
> 

As far as I know it is only the powerpc/pseries code that uses the feature that
allows memory blocks in sysfs to span multiple memory sections.  We do this
because on pseries memory add/remove is done on a per LMB basis and we can have
machine where an LMB spans multiple memory sections.

This was just noticed due to a lack of testing between the 2.6.38/39 kernels where
this feature originally went in and the current mainline kernel.

-Nathan

