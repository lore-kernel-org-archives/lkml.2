Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab1FNS7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 14:59:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57704 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab1FNS7G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 14:59:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ZpDI+5r7OuW7kJ0XqBxZOMwRFYi1RN96ThiucJP1qU0/E0MzcNSvJ+CcjWChkhruu6
         HtvgVTgufw2ZmU7JSN/WQ3JyxuDz6RiBnipjd4fxDcfUxb7VxtCQeYD+Qx7PGQsy2mmy
         rY3mMPgLE6MVybjDw2u4eohTPYQ8mu/70Kxzg=
MIME-Version: 1.0
In-Reply-To: <20110612183627.GA12311@mail.gmail.com>
References: <20110606004038.GA28970@mail.gmail.com> <4DED0990.8090309@linux.intel.com>
 <20110612183627.GA12311@mail.gmail.com>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Tue, 14 Jun 2011 14:58:25 -0400
Message-ID: <BANLkTim+R74CXCpPDdz2W1+UrydTiW-4+w@mail.gmail.com>
Subject: Re: [PATCH 1/1] boot: Enhance performance by eliminating unnecessary
 calls to printf()
To: Jean Sacren <sakiwit@gmail.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Valdis.Kletnieks@vt.edu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 12, 2011 at 14:36, Jean Sacren <sakiwit@gmail.com> wrote:
> From: "H. Peter Anvin" <hpa@linux.intel.com>
> Date: Mon, 06 Jun 2011 10:08:32 -0700
>>
>> On 06/05/2011 05:40 PM, Jean Sacren wrote:

>> First of all, this is a build time tool which is executed exactly once
>> during the entire kernel build.
>>
>> Second, printf execution time is largely dependent on the size
>> formatting string; since the I/O is buffered it is only issued once
>> anyway... which basically means that there is no time saved at all.
>
> The above two arguments have nothing to do with the fact you printed out
> 13 lines individually, where they should have been printed out
> collectively. To make my point here, why you didn't print out each
> character individually?

Because that would be substantially harder to read. And harder to
write, at that.

>
> I looked at the history of the file and the way you did it is a birth
> shortcoming. For the past two years, no code has ever been necessarily
> inserted between these 13 printf() calls. Looking into the future, that
> block of code shall be facilitated by the updated patch.
>>
>> Third, the resulting code is substantially harder to read.
>
> With the updated patch, this argument doesn't stand at all.

Sure it does. With the original code, the arguments to printf are
right next to the format specifiers; with your patch you have to count
format specifiers to figure out which argument goes to what. And for
what? A millisecond or two of time saved, at compile time, probably
less?

>> Fourth, carrying this as a patch will cost kernel developers more time
>> in additional git execution time than it ever will save them in build time.
>
> With the updated patch, this argument doesn't make any sense at all.

You've already cost kernel developers more time in responding to your
patch than they'll save in build time. Asking them to apply it to git
wastes even more time.

> +       printf(".section \".rodata..compressed\",\"a\",@progbits\n"
> +              ".globl z_input_len\n"
> +              "z_input_len = %lu\n"
> +              ".globl z_output_len\n"
> +              "z_output_len = %lu\n"
> +              ".globl z_extract_offset\n"
> +              "z_extract_offset = 0x%lx\n"
> +              ".globl z_extract_offset_negative\n"
> +              "z_extract_offset_negative = -0x%lx\n"
> +              ".globl input_data, input_data_end\n"
> +              "input_data:\n"
> +              ".incbin \"%s\"\n"
> +              "input_data_end:\n",
> +              ilen, (unsigned long)olen, offs, offs, argv[1]);

Quick! Which printf argument does z_extract_offset correspond to?
If you had to count (or it took you more than half a second
otherwise), this code is less readable than it was before.
