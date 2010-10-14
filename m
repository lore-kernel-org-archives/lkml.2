Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab0JNVcD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:32:03 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48564 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919Ab0JNVcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:32:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=x90f1FC3tIVGUlrh1aqOjkChXsT9mUCyArN2lJQGzkqHeRHf/EPxlvLsw83roFqKix
         MUm7bST8ZgflhM1hTlTKy8SSwThM9d0SWtoTswdDtu51iPbTaPzahZHyZ+UqgjmDpgb8
         mszgYOqV4CMjql88Dyjdx8DtytQ9X+96QcT3E=
Subject: Re: Results of my work on memorystick subsystem
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <8497.77981.qm@web37601.mail.mud.yahoo.com>
References: <8497.77981.qm@web37601.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Oct 2010 23:01:12 +0200
Message-ID: <1287090073.4301.20.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-14 at 01:00 -0700, Alex Dubov wrote:
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > 
> > and patch #6 contines adds even more cleanups, and makes
> > whole
> > memctick subsystem look nice and clean.
> > Many non obivous functions were removen.
> 
> Replacing functional state handlers with nasty 3-page long switches on
> undiscriminated integer state variables does not count either "cleaner"
> nor "more obvious" in my notebook.
Yes it is.
In the original state machines, the switch value was a TPC that was
already sent, and therefore it usually wasn't related to code inside
switch block.
In addition to that if one tries to send same TPC and treat it
differently he is for a big surprise.
With my scheme the states are clearly marked.

'nasty 3-page long switches' - what are you taking about?
h_mspro_block_transfer_data - 89 lines before
h_mspro_block_transfer_data - 129 lines after

Sure the new handler is a bit longer, but I moved there a chunk of
request processing code, so that mspro_block_issue_req and
mspro_block_complete_req
do now one thing only and used only for block requests.

> 
> This is a matter of personal preference, I suppose.
> 
> Yet, at the very least, you should define an appropriate enum and give
> your states readable names.
I didn't use a enum on purpose.
This allows me to go to previous/next state by doing card->state++ or
card->state--;
enum will hide the numeric values and thus make this dangerous.
I explicitly jump to a state very rarely, and it is obvious from code
when I do so.
Also states are private to each state machine, so it is easy to locate a
state within it.

Since I introduced the helpers to read/write the regs which make code
simpler and safer (less assumptions about what current window is)
and function to read the INT register which removes a chunk of redundant
code (and a goto), and most importantly guard against infinite INT poll
(which can happen with old code), I can't really use a TPC switch
anyway.


And what I had to go through to understand the
mspro_block_read_attributes....

Best regards,
	Maxim Levitsky

