Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab1BGDIV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 22:08:21 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57412 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab1BGDIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 22:08:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=g1y2VTpq+x43VB8xUAilhzBX67ZH94u8V3IaI9Da0M/gVg86JuN7LGjEX804aihszS
         pkzDSrbUjmAwqWk/vioD1C87SXywhvkjEnAAMNfsJ5AB5gmjI6hqQ/unLIVUOfEgYhHJ
         1dDqTZzwmc1dm+rksweEJlePUwxBB9/CZlA40=
MIME-Version: 1.0
In-Reply-To: <1297034086.14982.8.camel@pasglop>
References: <1296136583-13815-1-git-send-email-akinobu.mita@gmail.com>
	<1296136583-13815-3-git-send-email-akinobu.mita@gmail.com>
	<1297034086.14982.8.camel@pasglop>
Date: Mon, 7 Feb 2011 12:08:18 +0900
Message-ID: <AANLkTik3OEJV1AMSDPg+DkmxZuGL7uzBHSswRorhc7xQ@mail.gmail.com>
Subject: Re: [PATCH -mm 2/6] powerpc: convert little-endian bitops macros to
 static inline functions
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/2/7 Benjamin Herrenschmidt <benh@kernel.crashing.org>:
> On Thu, 2011-01-27 at 22:56 +0900, Akinobu Mita wrote:
>> (This patch is intended to be folded into the patch in -mm:
>> powerpc-introduce-little-endian-bitops.patch)
>>
>> The little-endian bitops on powerpc are written as preprocessor
>> macros with the cast to "unsigned long *".
>> This means that even non-pointers will be accepted without an error, and
>> that is a Very Bad Thing.
>>
>> This converts the little-endian bitops macros to static inline functions
>> with proper prototypes.
>
> No objection to the powerpc variant of the patches. What is the status
> with the wholes series tho ? Does it looks like its going to be
> accepted ? Do you expect my Ack and will merge the whole thing at once ?

The whole series now seems acceptable since I fixed two issues
that Linus found annoying. (the naming and the change of prototype)

Please give your ack if it is OK.

I should have fixed them quickly so that the series went upstream
in the last merge windows. But I couldn't because I spent some time
fixing and compile testing for a bisection hole.

> Does it break bisection unless it's merged as one single giant patch ?

I think there is no known problem that breaks bisectability by
this patch series.
