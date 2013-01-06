Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab3AFS7b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 13:59:31 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:53717 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097Ab3AFS73 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 13:59:29 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <87fw2j5dlj.fsf@rustcorp.com.au>
References: <1348179300-11653-1-git-send-email-keescook@chromium.org>
 <CAHO5Pa2fysDRS3sFSy785XBKApxydN0ONW5kAfVJNkrB+wOaBw@mail.gmail.com>
 <50749DE8.7010703@zytor.com> <CAKgNAkgLW+0aHwzoY6vxmeeK_K5w2RyhxW+jOaJDn274NVbajw@mail.gmail.com>
 <5074A0AB.8040207@zytor.com> <87d30o7iy6.fsf@rustcorp.com.au>
 <CAKgNAkh=99=x1=8Y=3odem-fXc9zEEbLvCc0WQku5Kyso4qHuQ@mail.gmail.com>
 <87ipa8o4mn.fsf@rustcorp.com.au> <CAKgNAkiVxUiqJ1pYNq3wW_yQxcyhqntUzcEWscFOhJ3GaVn1aQ@mail.gmail.com>
 <87sj97hs5e.fsf@rustcorp.com.au> <CAHO5Pa29_=3HNLG-qtULZ2fmkgPJ6JCZ0LTv9m=UowfvFufhMw@mail.gmail.com>
 <87fw2j5dlj.fsf@rustcorp.com.au>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Sun, 6 Jan 2013 19:59:08 +0100
Message-ID: <CAKgNAkggu9+AuMRqTFeNy9sJVCMcZVRZx43t=svF=gm+P4DnuQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] module: add syscall to load module from fd
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        jonathon@jonmasters.org, linux-man@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty, (and Lucas, and Kees)

On Thu, Jan 3, 2013 at 1:12 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Michael Kerrisk <mtk.manpages@gmail.com> writes:
>> Hi Rusty,
>
> Hi Michael,
>
>> The description here is rather thin. Could you supply a sentence or
>> two for each of MODULE_INIT_IGNORE_MODVERSIONS and
>> MODULE_INIT_IGNORE_VERMAGIC that would be suitable for the manual
>> page?
>>
>> Thanks,
>
> There are one or two safety checks built into a module, which are
> checked to match the kernel on module load.  The first is a "vermagic"
> string containing the kernel version number and prominent features (such
> as CPU type).  If the module was built with CONFIG_MODVERSIONS set, a
> version hash is recorded for each symbol the module uses based on the
> types it refers to: in this case, the kernel version number within the
> "vermagic" string is ignored, as the symbol version hashes are assumed
> to be sufficiently reliable.
>
> Using the MODULE_INIT_IGNORE_VERMAGIC flag indicates that the vermagic
> is to be ignored, and the MODULE_INIT_IGNORE_MODVERSIONS flag indicates
> that the version hashes are to be ignored.  If the kernel is built to
> permit such forced loading (ie. CONFIG_MODULE_FORCE_LOAD is set) then
> loading will continue, otherwise it will fail with ENOEXEC as expected
> for malformed modules.
>
> Hope that is more usable?

Yes, that helps. I did some reworking of that text. Hopefully, I did
not introduce any errors.

Below is the text that is proposed to document finit_module() in the
man pages. I'd appreciate any review (Kees, Lucas, Rusty?)

Thanks,

Michael

   finit_module()
       The finit_module() system call is like init_module(), but reads
       the module to be loaded from the file  descriptor  fd.   It  is
       useful  when  the authenticity of a kernel module can be deter‐
       mined from its location in the file system; in cases where that
       is  possible,  the  overhead  of using cryptographically signed
       modules to determine  the  authenticity  of  a  module  can  be
       avoided.  The param_values argument is as for init_module().

       The  flags  argument  modifies the operation of finit_module().
       It is a bit mask value created by ORing together zero  or  more
       of the following flags:

       MODULE_INIT_IGNORE_MODVERSIONS
              Ignore symbol version hashes.

       MODULE_INIT_IGNORE_VERMAGIC
              Ignore kernel version magic.

       There are some safety checks built into a module to ensure that
       it matches the kernel against which it is loaded.  These checks
       are  recorded  when  the  module is built and verified when the
       module is loaded.   First,  the  module  records  a  "vermagic"
       string  containing the kernel version number and prominent fea‐
       tures (such as the CPU type).  Second, if the module was  built
       with  the  CONFIG_MODVERSIONS  configuration  option enabled, a
       version hash is recorded for each symbol the module uses.  This
       hash  is  based  on the types of the arguments and return value
       for the function named by the symbol.  In this case, the kernel
       version  number within the "vermagic" string is ignored, as the
       symbol version hashes are assumed to be sufficiently reliable.

       Using the MODULE_INIT_IGNORE_VERMAGIC flag indicates  that  the
       "vermagic"   string   is   to   be   ignored,   and   the  MOD‐
       ULE_INIT_IGNORE_MODVERSIONS flag indicates that the symbol ver‐
       sion  hashes are to be ignored.  If the kernel is built to per‐
       mit  forced  loading   (i.e.,   configured   with   CONFIG_MOD‐
       ULE_FORCE_LOAD),  then loading will continue, otherwise it will
       fail with ENOEXEC as expected for malformed modules.
...
   ERRORS
...
       The following errors may additionally occur for finit_module():

       EBADF  The file referred to by fd is not opened for reading.

       EFBIG  The file referred to by fd is too large.

       EINVAL flags is invalid.

       ENOEXEC
              fd does not refer to an open file.


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
