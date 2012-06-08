Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934115Ab2FHJHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 05:07:39 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:42722 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934020Ab2FHJHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 05:07:36 -0400
Message-ID: <4FD1C0D2.8060704@mev.co.uk>
Date: Fri, 8 Jun 2012 10:07:30 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (Windows NT 5.2; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: comedi: serial2002: quiet NULL pointer sparse
 noise
References: <201206071714.25934.hartleys@visionengravers.com> <4FD19FBB.4040507@mev.co.uk> <20120608065125.GL4400@mwanda>
In-Reply-To: <20120608065125.GL4400@mwanda>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/06/08 07:51 AM, Dan Carpenter wrote:
> On Fri, Jun 08, 2012 at 07:46:19AM +0100, Ian Abbott wrote:
>> On 08/06/12 01:14, H Hartley Sweeten wrote:
>>> Quiet a number of sparse warnings in this file:
>>>
>>> warning: Using plain integer as NULL pointer
>>
>> I wonder why sparse warns about that for a literal, unadorned 0?  I
>> suppose NULL is more explicit, but a plain 0 means the same as NULL
>> in a pointer context (unlike a zero from some random expression).
> 
> http://lwn.net/Articles/93574/

Thanks for the link.  I understand the intent to make null pointer
constants easier to recognize.  Still, the text of the sparse warning
message "Using plain integer as NULL pointer" is technically incorrect
since 0 is not an integer (plain or otherwise) in a pointer context,
it's a null pointer constant.

I wonder if it also issues that warning for a struct initializer such as
{0} where the first member of the struct is a pointer, or would it
expect you to use {NULL} which is more confusing when the struct
contains a mixture of pointer and non-pointer members?

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>             )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587              )=-
