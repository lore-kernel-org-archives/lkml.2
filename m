Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab2ALRsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 12:48:50 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60921 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab2ALRst convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 12:48:49 -0500
MIME-Version: 1.0
In-Reply-To: <20120112171019.GA19771@phenom.dumpdata.com>
References: <498097597.20120112133832@eikelenboom.it> <20120112154613.GA10148@phenom.dumpdata.com>
 <CAPXgP1373C5SfzU-rfo5GG53dUE6dVzECSuKzX1c_FirpXQt2g@mail.gmail.com>
 <20120112161204.GC10269@phenom.dumpdata.com> <20120112164025.GA22773@phenom.dumpdata.com>
 <256392989.20120112180546@eikelenboom.it> <20120112171019.GA19771@phenom.dumpdata.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 12 Jan 2012 18:48:28 +0100
Message-ID: <CAPXgP11GwHuA3e=xYUpKgvDTEwYb1Q9FH=aV8wvivUXhOaXBVg@mail.gmail.com>
Subject: Re: linux 3.3-pre-rc1: Starting domU fails with Error: Failed to
 query current memory allocation of dom0.
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sander Eikelenboom <linux@eikelenboom.it>, linux-kernel@vger.kernel.org,
        xen-devel <xen-devel@lists.xensource.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 18:10, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Thu, Jan 12, 2012 at 06:05:46PM +0100, Sander Eikelenboom wrote:

>> Shouldn't the
>>
>> if (error) {
>>         bus_unregister(&balloon_subsys);
>>         return error;
>> }
>>
>> right below it also be changed ?
>
> I thought so too, but looking at how the subsys_system_register it looks
> to be OK. Kay, thoughts?

No, it's fine, there is nothing else.

The subsys_system_register() fucrtion is a new function (for compat
with old sysdev rules only) that registers a bus. The counterpart is
the bus_unregister.

The long-term picture is that 'struct bus_type' and 'struct class'
will be merged and everything will be called 'subsys'.

Kay
