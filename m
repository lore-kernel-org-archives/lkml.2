Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab1AFUrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 15:47:16 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:43652 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050Ab1AFUrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 15:47:14 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Replace the dangerous to_root_device macro with an inline function
References: <44482f820e5700f952825c9b5ec6a9f080975d79.1294326889.git.wferi@niif.hu>
	<20110106162032.GA10189@suse.de>
Date: Thu, 06 Jan 2011 21:47:08 +0100
In-Reply-To: <20110106162032.GA10189@suse.de> (Greg KH's message of "Thu, 6
	Jan 2011 08:20:32 -0800")
Message-ID: <87zkrd3gkz.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> On Thu, Jan 06, 2011 at 04:24:24PM +0100, Ferenc Wagner wrote:
>
>> The original macro worked only when applied to variables named 'dev'.
>> While this could have been fixed by simply renaming the macro argument,
>> a more type-safe replacement is preferred.
>
> Preferred for what?  This is a local macro, not exported to anything
> else, is it causing problems today within this single file?

No, it isn't a problem currently, because this macro is applied to
variables named 'dev' exclusively.  But the macro definition is wrong,
as it uses 'dev' (the macro argument) in two places, of which the second
probably isn't intentional, as the third argument of the container_of
macro is a structure member name, which should stay fixed to the literal
string 'dev' in this case, not replaced by the actual macro argument.

So you've got the choice of leaving things as they are and happen to
work for the moment, fixing the definition of the to_root_device macro
to use some other token as the name of the free variable instead of
'dev', or to replace the macro with a function, which provides some
type-checking advantages during compilation as well.  I thought this was
a general reason for preferring inline functions over preprocessor
macros in the kernel codebase, but maybe I was wrong.
-- 
Regards,
Feri.
