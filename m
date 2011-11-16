Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab1KPSUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 13:20:53 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49445 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab1KPSUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 13:20:51 -0500
Subject: Re: Crash during vmcore_init
From: Tim Hartrick <tim@edgecast.com>
Reply-To: tim@edgecast.com
To: Dave Young <dyoung@redhat.com>
Cc: tj@kernel.org, WANG Cong <xiyou.wangcong@gmail.com>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <4EC31E55.6040809@redhat.com>
References: <1318376345.2050.20.camel@boudreau>
	 <j9r5m5$b18$1@dough.gmane.org> <1321296650.2066.17.camel@boudreau>
	 <4EC21F67.10905@redhat.com> <1321396371.4198.5.camel@boudreau>
	 <4EC31E55.6040809@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: EdgeCast Networks
Date: Wed, 16 Nov 2011 10:20:47 -0800
Message-ID: <1321467647.2137.4.camel@boudreau>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dave,

On Wed, 2011-11-16 at 10:22 +0800, Dave Young wrote:
> On 11/16/2011 06:32 AM, Tim Hartrick wrote:
> 
> > 
> > Dave,
> > 
> > I tested with
> > 
> > linux-image-3.1.1-030101-generic_3.1.1-030101.201111111651_amd64.deb
> > 
> > which, as far as I know, is the Ubuntu build of the latest stable.
> > Below are the results.
> > 
> > [    1.427457] ioremap: invalid physical address 5800000000000
> 
> 
> Hi, thanks for the testing
> 
> Can you applied the debug patch to see if it's per cpu problem?
> 
> Don't need test kdump, just
> cd /sys/devices/system/cpu
> cat cpu[x]/crash_notes
> 
> probably cat crash notes of cpu number other than 0 will get the invalid
> address
> 

Using 3.1.1 stable with your patch.  See below.


tim

# for i in /sys/devices/system/cpu/cpu[0-9]*/crash_notes; do cat $i; done
5800000000000
5800000000000
5800000000000
5800000000000
5800000000000
5800000000000
5800000000000
5800000000000

dmesg:

[  277.276349] per cpu addr ffff880c7fc19ad0
[  277.276352] addr is not in vmalloc area
[  277.277545] per cpu addr ffff880667c19ad0
[  277.277548] addr is not in vmalloc area
[  277.278832] per cpu addr ffff880c7fc39ad0
[  277.278835] addr is not in vmalloc area
[  277.280175] per cpu addr ffff880667c39ad0
[  277.280178] addr is not in vmalloc area
[  277.281406] per cpu addr ffff880c7fc59ad0
[  277.281409] addr is not in vmalloc area
[  277.282592] per cpu addr ffff880667c59ad0
[  277.282594] addr is not in vmalloc area
[  277.284019] per cpu addr ffff880c7fc79ad0
[  277.284022] addr is not in vmalloc area
[  277.285251] per cpu addr ffff880667c79ad0
[  277.285254] addr is not in vmalloc area








