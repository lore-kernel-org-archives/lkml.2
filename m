Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760417Ab2JaTsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 15:48:19 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38893 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760317Ab2JaTsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 15:48:18 -0400
MIME-Version: 1.0
In-Reply-To: <30574.1351686689@warthog.procyon.org.uk>
References: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
	<20121030192148.11000.3582.stgit@warthog.procyon.org.uk>
	<CAGXu5jK22D_15jYopqaegYAGSHO2x0asXogXCnZGfMw2KwUVNw@mail.gmail.com>
	<30574.1351686689@warthog.procyon.org.uk>
Date: Wed, 31 Oct 2012 12:48:17 -0700
X-Google-Sender-Auth: mFazsn2wX_Gfb2bebafwnfMicqQ
Message-ID: <CAGXu5jLY+oOcH5ZxvncNxEg2kY_E-HPKpeFB6T+2m6eWZfjSuQ@mail.gmail.com>
Subject: Re: [PATCH 16/23] pefile: Parse a PE binary to find a key and a
 signature contained therein
From: Kees Cook <keescook@chromium.org>
To: David Howells <dhowells@redhat.com>
Cc: rusty@rustcorp.com.au, pjones@redhat.com, jwboyer@redhat.com,
        mjg@redhat.com, dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 5:31 AM, David Howells <dhowells@redhat.com> wrote:
> Kees Cook <keescook@chromium.org> wrote:
>
>> Which means this loop will walk past the end of the memory (loop is
>> bounded by n_sections, so secs[loop] can go past datalen). While
>> data_addr and raw_data_size will stay bounded, the read of sec->name
>> can be out of bounds.
>
> Assuming n_sections is checked, sec->name can't be out of bounds because it's
> a char array, not a pointer.
>
>> (Also, do you want a "break" in there after the first .keylist is found, or
>> is this intentionally "use last key list"?)
>
> Actually, no I don't.  The loop also checks the limits on each section - which
> I need to do since I have to individually digest the sections later.
>
> Attached is a patch I'm applying to pefile_parse_binary() to be more rigorous
> about the checking of values in the PE binary.

Cool; looks good to me. When this gets into linux-next, we should
probably spend more time staring at it. :)

Thanks for the fixes!

-Kees

-- 
Kees Cook
Chrome OS Security
