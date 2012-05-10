Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495Ab2EJLFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 07:05:32 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:51410 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096Ab2EJLFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 07:05:31 -0400
Message-ID: <4FABA0F6.6090401@mev.co.uk>
Date: Thu, 10 May 2012 12:05:26 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120414 Thunderbird/11.0.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>
Subject: Re: [PATCH] staging: comedi: remove __user annotation inside of struct's
References: <201205081641.00358.hartleys@visionengravers.com> <ADE657CA350FB648AAC2C43247A983F0020698A1774D@AUSP01VMBX24.collaborationhost.net> <4FAA44D7.1040209@mev.co.uk> <20120509103111.GR22134@mwanda> <4FAA4E85.6020305@mev.co.uk> <20120509141920.GT22134@mwanda>
In-Reply-To: <20120509141920.GT22134@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-09 15:19, Dan Carpenter wrote:
> On Wed, May 09, 2012 at 12:01:25PM +0100, Ian Abbott wrote:
>> Are there any handy macros for casting pointers to __user pointers,
>> something like
>>
>> #define _user(p) ((typeof(*(p)) __user *)(p))
>>
>> but preferably without the repeated expansion of 'p' in case of
>> side-effects?
>
> typeof() doesn't have side effects.
>
> #include<stdio.h>
>
> int main(void)
> {
> 	int x = 0;
> 	typeof(x++) y;
>
> 	printf("%d\n", x);
>
> 	return 0;
> }
>
> regards,
> dan carpenter

Yes, you're correct of course.  I was unnecessarily worried about the 
double-expansion of the macro parameter but it's safe in this case.

BTW, the intention of this macro is so you can write things like:

   copy_from_user(data, _user(insn.data), insn.n * sizeof(insn.data[0]));

instead of:

   copy_from_user(data, (unsigned int __user *)insn.data, insn.n * 
sizeof(insn.data[0]));

where the member insn.data is a 'unsigned int *' but is used for both 
__user pointers and kernel pointers.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
