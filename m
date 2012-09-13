Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797Ab2IMOYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 10:24:12 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63121 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021Ab2IMOYK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 10:24:10 -0400
Subject: Re: [PATCH] Xen backend support for paged out grant targets.
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=US-ASCII
From: Andres Lagar-Cavilla <andres.lagarcavilla@gmail.com>
In-Reply-To: <1347520482.25803.46.camel@dagon.hellion.org.uk>
Date: Thu, 13 Sep 2012 10:24:08 -0400
Cc: Andres Lagar-Cavilla <andres@lagarcavilla.org>, xen-devel@xen.lists.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7BIT
Message-Id: <3B5D2C51-899F-47AF-BD59-36D7F9E3C045@gmail.com>
References: <1347479153-441-1-git-send-email-andres@lagarcavilla.org> <1347520482.25803.46.camel@dagon.hellion.org.uk>
To: Ian Campbell <ian.campbell@citrix.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 13, 2012, at 3:14 AM, Ian Campbell wrote:

> On Wed, 2012-09-12 at 20:45 +0100, Andres Lagar-Cavilla wrote:
>> diff --git a/include/xen/interface/grant_table.h b/include/xen/interface/grant_table.h
>> index 7da811b..66cb734 100644
>> --- a/include/xen/interface/grant_table.h
>> +++ b/include/xen/interface/grant_table.h
>> @@ -520,6 +520,7 @@ DEFINE_GUEST_HANDLE_STRUCT(gnttab_get_version);
>> #define GNTST_permission_denied (-8) /* Not enough privilege for operation.  */
>> #define GNTST_bad_page         (-9) /* Specified page was invalid for op.    */
>> #define GNTST_bad_copy_arg    (-10) /* copy arguments cross page boundary */
> 
> What is -11?

-11 is something called GNTST_address_too_big on the xen public includes. Since it is not relevant too this patch I decided to skip over it. I will add a "placeholder" entry to the message array below to keep things properly aligned.

Thanks
Andres
> 
> Because...
> 
>> +#define GNTST_eagain          (-12) /* Retry.                                */
>> 
>> #define GNTTABOP_error_msgs {                   \
>>     "okay",                                     \
>> @@ -533,6 +534,7 @@ DEFINE_GUEST_HANDLE_STRUCT(gnttab_get_version);
>>     "permission denied",                        \
>>     "bad page",                                 \
>>     "copy arguments cross page boundary"        \
> 
> ... it should go here, otherwise retry is in the wrong place.
> 
> Perhaps we should switch this to the 
> 	[GNTTABOP_foo] = "foo"
> style of initialiser?
> 
>> +    "retry"                                     \
>> }
>> 
>> #endif /* __XEN_PUBLIC_GRANT_TABLE_H__ */ 
> 

