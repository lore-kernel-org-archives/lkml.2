Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282Ab2JREZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 00:25:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:50980 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab2JREZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 00:25:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,604,1344236400"; 
   d="scan'208";a="235360705"
Message-ID: <507F848F.50707@zytor.com>
Date: Wed, 17 Oct 2012 21:24:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: mtk.manpages@gmail.com, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/4] module: add syscall to load module from fd
References: <1348179300-11653-1-git-send-email-keescook@chromium.org> <CAHO5Pa2fysDRS3sFSy785XBKApxydN0ONW5kAfVJNkrB+wOaBw@mail.gmail.com> <50749DE8.7010703@zytor.com> <CAKgNAkgLW+0aHwzoY6vxmeeK_K5w2RyhxW+jOaJDn274NVbajw@mail.gmail.com> <5074A0AB.8040207@zytor.com> <87d30o7iy6.fsf@rustcorp.com.au>
In-Reply-To: <87d30o7iy6.fsf@rustcorp.com.au>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2012 03:16 PM, Rusty Russell wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
> 
>> On 10/10/2012 06:03 AM, Michael Kerrisk (man-pages) wrote:
>>> Good point. A "whole hog" openat()-style interface is worth thinking about too.
>>
>> *Although* you could argue that you can always simply open the module
>> file first, and that finit_module() is really what we should have had in
>> the first place.  Then you don't need the flags since those would come
>> from openat().
> 
> There's no fundamental reason that modules have to be in a file.  I'm
> thinking of compressed modules, or an initrd which simply includes all
> the modules it wants to load in one linear file.
> 
> Also, --force options manipulate the module before loading (as did the
> now-obsolete module rename option).
> 

So perhaps what we *should* have is something that points to the module
to a (buffer, length) in userspace, and the equivalent of the current
init_module() would be open() + mmap() + minit_module() + close()?

	-hpa



