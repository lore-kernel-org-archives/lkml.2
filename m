Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab1EUQ1I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 12:27:08 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62731 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580Ab1EUQ1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 12:27:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=fLljc361R4SVqt6U7V2n5KN1rVQesrK0qyExuRyY6Vdf2GnLgduzSjVUt5K36JE1/l
         AKsHD57MOIBbKMM8Olbt2rPQUOXe/Uy8v5+Mb72zP2fUyfpBu+z/u1aMVX23WSRk4Uz7
         iEpUBX/QfJmtTuKgo7szSjBqqrHcaFl/HDlnY=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=tdfG3jpCJQpozpxjBmR7ZicgV9g@mail.gmail.com>
References: <BANLkTinM_=bAjD59=GiKtTvjLtoOs7KCFA@mail.gmail.com>
	<201105211727.35985.arnd@arndb.de>
	<BANLkTi=tdfG3jpCJQpozpxjBmR7ZicgV9g@mail.gmail.com>
Date: Sat, 21 May 2011 09:27:05 -0700
Message-ID: <BANLkTikyg-SDtU9Z8KdCAeOkGR67ihVUkQ@mail.gmail.com>
Subject: Re: X32 project status update
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>, x32-abi@googlegroups.com,
        "H. Peter Anvin" <h.peter.anvin@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 21, 2011 at 8:34 AM, H.J. Lu <hjl.tools@gmail.com> wrote:
> On Sat, May 21, 2011 at 8:27 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Saturday 21 May 2011 17:01:33 H.J. Lu wrote:
>>> This is the x32 project status update:
>>>
>>> https://sites.google.com/site/x32abi/
>>>
>>
>> I've had another look at the kernel patch. It basically
>> looks all good, but the system call table appears to
>> diverge from the x86_64 list for no (documented) reason,
>> in the calls above 302. Is that intentional?
>>
>> I can see why you might want to keep the numbers identical,
>> but if they are already different, why not use the generic
>> system call table from asm-generic/unistd.h for the new
>> ABI?
>
> We can sort it out when we start merging x32 kernel changes.
>

Peter, is that possible to use the single syscall table for
both x86-64 and x32 system calls? Out of 300+ system
calls, only 84 are different for x86-64 and x32.  That
is additional 8*84 == 672 bytes in syscall table.


-- 
H.J.
