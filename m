Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab0I2NkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 09:40:18 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36787 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756220Ab0I2NkO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 09:40:14 -0400
MIME-Version: 1.0
In-Reply-To: <20100929123752.GA18865@kroah.com>
References: <4CA0EBEB.1030204@austin.ibm.com> <4CA1E338.6070201@redhat.com>
 <20100928151218.GJ14068@sgi.com> <20100929025035.GA13096@kroah.com>
 <4CA2F9A2.3090202@redhat.com> <20100929123752.GA18865@kroah.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 29 Sep 2010 15:39:58 +0200
Message-ID: <AANLkTi=uqVA5XGNKLg8=saXzWM5FA6KNP9fsAj80si_q@mail.gmail.com>
Subject: Re: [PATCH 0/8] v2 De-Couple sysfs memory directories from memory sections
To: Greg KH <greg@kroah.com>
Cc: Avi Kivity <avi@redhat.com>, Robin Holt <holt@sgi.com>,
        Nathan Fontenot <nfont@austin.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 14:37, Greg KH <greg@kroah.com> wrote:
> On Wed, Sep 29, 2010 at 10:32:34AM +0200, Avi Kivity wrote:
>>  On 09/29/2010 04:50 AM, Greg KH wrote:
>>> >
>>> >  Because the old ABI creates 129,000+ entries inside
>>> >  /sys/devices/system/memory with their associated links from
>>> >  /sys/devices/system/node/node*/ back to those directory entries.
>>> >
>>> >  Thankfully things like rpm, hald, and other miscellaneous commands scan
>>> >  that information.
>>>
>>> Really?  Why?  Why would rpm care about this?  hald is dead now so we
>>> don't need to worry about that anymore,
>>
>> That's not what compatiblity means.  We can't just support
>> latest-and-greatest userspace on latest-and-greatest kernels.
>
> Oh, I know that, that's not what I was getting at at all here, sorry if
> it came across that way.
>
> I wanted to know so we could go fix programs that are mucking around in
> these files, as odds are, the shouldn't be doing that in the first
> place.
>
> Like rpm, why would it matter what the memory in the system looks like?

HAL does many inefficient things, but I don't think it's using
/sys/system/, besides that it may check the cpufreq govenors state
there.

Kay
