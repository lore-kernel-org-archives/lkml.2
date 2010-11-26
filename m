Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab0KZIck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 03:32:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461Ab0KZIcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 03:32:39 -0500
Message-ID: <4CEF7085.6080200@redhat.com>
Date: Fri, 26 Nov 2010 10:32:05 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        stable-review@kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Stable-review] [22/45] KVM: Fix fs/gs reload oops with invalid
 ldt
References: <1290734130.2928.24.camel@localhost>
In-Reply-To: <1290734130.2928.24.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2010 03:15 AM, Ben Hutchings wrote:
> Greg KH<gregkh@suse.de>  wrote:
> >  2.6.32-stable review patch.  If anyone has any objections, please let us know.
>
> Obviously it's a bit late now, but...
>
> >  ------------------
> >
> >  From: Avi Kivity<avi@redhat.com>
> >
> >  commit 9581d442b9058d3699b4be568b6e5eae38a41493 upstream
> >
> >  kvm reloads the host's fs and gs blindly, however the underlying segment
> >  descriptors may be invalid due to the user modifying the ldt after loading
> >  them.
> >
> >  Fix by using the safe accessors (loadsegment() and load_gs_index()) instead
> >  of home grown unsafe versions.
> >
> >  This is CVE-2010-3698.
> >
> >  Signed-off-by: Avi Kivity<avi@redhat.com>
> >  Signed-off-by: Marcelo Tosatti<mtosatti@redhat.com>
> >  Signed-off-by: Greg Kroah-Hartman<gregkh@suse.de>
> [...]
>
> Avi, you surely knew this commit was buggy (specifically for i386
> userland on an amd64 kernel) since you also committed:
>
> commit c8770e7ba63bb5dd8fe5f9d251275a8fa717fb78
> Author: Avi Kivity<avi@redhat.com>
> Date:   Thu Nov 11 12:37:26 2010 +0200
>
>      KVM: VMX: Fix host userspace gsbase corruption
>
> I realise it wasn't ready for stable as Linus only pulled it in
> 2.6.37-rc3, but surely that means this neither of the changes should
> have gone into 2.6.32.26.  Why didn't you respond to the review??
>

I don't actually read those review emails, there are too many of them.

The fix will go into 2.6.32.stable in time.  Fixing the vulnerability 
was more important than i386-on-x86_64 anyway.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

