Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab0K0Alx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 19:41:53 -0500
Received: from cantor.suse.de ([195.135.220.2]:45913 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238Ab0K0Alw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 19:41:52 -0500
Date: Fri, 26 Nov 2010 16:40:09 -0800
From: Greg KH <gregkh@suse.de>
To: Avi Kivity <avi@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, Marcelo Tosatti <mtosatti@redhat.com>,
        stable-review@kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Stable-review] [22/45] KVM: Fix fs/gs reload oops with
	invalid ldt
Message-ID: <20101127004009.GA12212@suse.de>
References: <1290734130.2928.24.camel@localhost> <4CEF7085.6080200@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CEF7085.6080200@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 10:32:05AM +0200, Avi Kivity wrote:
> On 11/26/2010 03:15 AM, Ben Hutchings wrote:
>> Greg KH<gregkh@suse.de>  wrote:
>> >  2.6.32-stable review patch.  If anyone has any objections, please let us know.
>>
>> Obviously it's a bit late now, but...
>>
>> >  ------------------
>> >
>> >  From: Avi Kivity<avi@redhat.com>
>> >
>> >  commit 9581d442b9058d3699b4be568b6e5eae38a41493 upstream
>> >
>> >  kvm reloads the host's fs and gs blindly, however the underlying segment
>> >  descriptors may be invalid due to the user modifying the ldt after loading
>> >  them.
>> >
>> >  Fix by using the safe accessors (loadsegment() and load_gs_index()) instead
>> >  of home grown unsafe versions.
>> >
>> >  This is CVE-2010-3698.
>> >
>> >  Signed-off-by: Avi Kivity<avi@redhat.com>
>> >  Signed-off-by: Marcelo Tosatti<mtosatti@redhat.com>
>> >  Signed-off-by: Greg Kroah-Hartman<gregkh@suse.de>
>> [...]
>>
>> Avi, you surely knew this commit was buggy (specifically for i386
>> userland on an amd64 kernel) since you also committed:
>>
>> commit c8770e7ba63bb5dd8fe5f9d251275a8fa717fb78
>> Author: Avi Kivity<avi@redhat.com>
>> Date:   Thu Nov 11 12:37:26 2010 +0200
>>
>>      KVM: VMX: Fix host userspace gsbase corruption
>>
>> I realise it wasn't ready for stable as Linus only pulled it in
>> 2.6.37-rc3, but surely that means this neither of the changes should
>> have gone into 2.6.32.26.  Why didn't you respond to the review??
>>
>
> I don't actually read those review emails, there are too many of them.

Please read the ones that are cc:ed to you, otherwise it's pretty
pointless for me to send them out :(

thanks,

greg k-h
