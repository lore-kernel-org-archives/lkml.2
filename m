Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab2KGIis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 03:38:48 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:53994 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab2KGIir convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Wed, 7 Nov 2012 03:38:47 -0500
Message-Id: <509A2C2402000078000A6EB9@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 07 Nov 2012 08:38:44 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Ian Campbell" <ian.campbell@citrix.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/2] xen/generic: Disable fallback
 build on ARM.
References: <1352239982-17389-1-git-send-email-konrad.wilk@oracle.com>
 <1352239982-17389-2-git-send-email-konrad.wilk@oracle.com>
 <1352272794.12977.17.camel@hastur.hellion.org.uk>
In-Reply-To: <1352272794.12977.17.camel@hastur.hellion.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 07.11.12 at 08:19, Ian Campbell <ian.campbell@citrix.com> wrote:
> On Tue, 2012-11-06 at 22:13 +0000, Konrad Rzeszutek Wilk wrote:
>> As there is no need for it (the fallback code is for older
>> hypervisors and they won't run under ARM), 
> 
> I think more specifically they won't run on anything other than x86.
> 
> [...]
>> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
>> index 46de6cd..273d2b9 100644
>> --- a/drivers/xen/Makefile
>> +++ b/drivers/xen/Makefile
>> @@ -1,8 +1,8 @@
>>  ifneq ($(CONFIG_ARM),y)
>> -obj-y	+= manage.o balloon.o
>> +obj-y	+= manage.o balloon.o fallback.o
>>  obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
>>  endif
> 
> I think :
>   obj-$(CONFIG_X86) += fallback.o
> would better reflect what is going on here.

Yes please.

Jan

