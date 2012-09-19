Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab2ISOoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 10:44:01 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:38936 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab2ISOn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 10:43:57 -0400
Message-ID: <1348065718.2453.31.camel@falcor>
Subject: Re: [PATCH 1/2] module: add syscall to load module from fd
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-security-module@vger.kernel.org
Date: Wed, 19 Sep 2012 10:41:58 -0400
In-Reply-To: <87obl2ptq0.fsf@rustcorp.com.au>
References: <1346955201-8926-1-git-send-email-keescook@chromium.org>
	 <50500C5C.8060006@zytor.com> <878vcfu22s.fsf@rustcorp.com.au>
	 <1347564136.2270.4.camel@falcor> <87obl2ptq0.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091914-5518-0000-0000-000007C61E07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-19 at 13:08 +0930, Rusty Russell wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> writes:
> 
> > On Wed, 2012-09-12 at 17:04 +0930, Rusty Russell wrote:
> >> "H. Peter Anvin" <hpa@zytor.com> writes:
> >> 
> >> > On 09/06/2012 11:13 AM, Kees Cook wrote:
> >> >> Instead of (or in addition to) kernel module signing, being able to reason
> >> >> about the origin of a kernel module would be valuable in situations
> >> >> where an OS already trusts a specific file system, file, etc, due to
> >> >> things like security labels or an existing root of trust to a partition
> >> >> through things like dm-verity.
> >> >>
> >> >> This introduces a new syscall (currently only on x86), similar to
> >> >> init_module, that has only two arguments. The first argument is used as
> >> >> a file descriptor to the module and the second argument is a pointer to
> >> >> the NULL terminated string of module arguments.
> >> >>
> >> >
> >> > Please use the standard naming convention, which is an f- prefix (i.e. 
> >> > finit_module()).
> >> 
> >> Good point; I just did a replace here.
> >
> > Have you pushed out the changes?  And if so, to where?
> 
> No, I kept them in my patch series but out of linux-next, since I
> thought you disliked the placement of the security hooks?

I thought about it some more.  The call to
security_kernel_module_from_file() from copy_module_from_user() doesn't
provide any information, not the buffer contents nor the signature.  The
only thing IMA-appraisal can do is to fail the request with
INTEGRITY_UNKNOWN.  This is reflected in the IMA-appraisal patch I
posted http://marc.info/?l=linux-security-module&m=134739023306344&w=2.

Please add my Acked-by: Mimi Zohar <zohar@us.ibm.com> 

thanks,

Mimi

