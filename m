Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab0LQKGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 05:06:12 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:54502 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab0LQKGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 05:06:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=v0yyV9jcfgHBdVlHphSKbUWrGdcaYaxj90kf9w6cPFGqevG7a8ga72ltxPf3sK4HOC
         vopV0DRVfZJnf3BPysXqctDJwFUDibUP4n30NvHOx5fejtnCgwxv0ltwJ2i5ybZYoKz1
         /pAEM4Xem2uypZC30IeFVsmGUU+371zTJoZeg=
Date: Fri, 17 Dec 2010 18:05:59 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Lu, Hongjiu" <hongjiu.lu@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [BUG]x86: relocatable doesn't work with new binutils
Message-ID: <20101217100559.GB8413@cr0.nay.redhat.com>
References: <1292553726.2323.482.camel@sli10-conroe>
 <4D0AD1F9.7030704@zytor.com>
 <1292556114.2323.484.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292556114.2323.484.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 11:21:54AM +0800, Shaohua Li wrote:
>On Fri, 2010-12-17 at 10:59 +0800, H. Peter Anvin wrote:
>> On 12/16/2010 06:42 PM, Shaohua Li wrote:
>> > We can easily workaround this issue by moving jiffies to a section or at
>> > least warn people if such binutils are using. what should we do?
>> 
>> I think we should do the workaround, but still get distros to update the
>> broken binutils.
>Here is my workaround.
>The problem is a lot of kernel versions are affected by this, fix all?
>
>
>
>The CONFIG_RELOCATABLE is broken with new binutils, which will make boot
>panic. According to Lu Hongjiu, the affected binutils are from
>2.20.51.0.12 to 2.21.51.0.3, which are release since Oct 22 this year.
>At least ubuntu 10.10 is using such binutils. see:
>http://sourceware.org/bugzilla/show_bug.cgi?id=12327
>The reason of boot panic is we have 'jiffies = jiffies_64;' in
>vmlinux.lds.S. The jiffies isn't in any section. In kernel build, there
>is warning saying jiffies is an absolute address and can't be
>relocatable. At runtime, jiffies will have virtual address 0.
>

Just curious, what change in binutils caused this? And what build
warning did you see? Section mismatch warning?

Thanks.
