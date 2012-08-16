Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933303Ab2HPT7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 15:59:07 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57889 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932536Ab2HPT7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 15:59:03 -0400
MIME-Version: 1.0
In-Reply-To: <1345146349.3402.21.camel@falcor.watson.ibm.com>
References: <cover.1345055638.git.dmitry.kasatkin@intel.com>
	<ec8635c36005ba5ea3784276214fb905720ee3ec.1345055639.git.dmitry.kasatkin@intel.com>
	<CA+5PVA71WegBSBbgZDBZopORkAMN9G8i2MXHmAGdpiSjWzo9RQ@mail.gmail.com>
	<1345144127.3402.2.camel@falcor.watson.ibm.com>
	<CA+5PVA6bwH1RKwT8DiZU2J3xo_c_R5d=0Zo9qHXkq+JhtZeG3Q@mail.gmail.com>
	<1345146349.3402.21.camel@falcor.watson.ibm.com>
Date: Thu, 16 Aug 2012 15:59:02 -0400
Message-ID: <CA+5PVA5dLY8rux88dC74q3uVwf3mE_VkGxaJU14YHbXkkGuBJQ@mail.gmail.com>
Subject: Re: [RFC v2 2/7] keys: initialize root uid and session keyrings early
From: Josh Boyer <jwboyer@gmail.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Dmitry Kasatkin <dmitry.kasatkin@intel.com>, jmorris@namei.org,
        rusty@rustcorp.com.au, dhowells@redhat.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 3:45 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> On Thu, 2012-08-16 at 15:13 -0400, Josh Boyer wrote:
>> On Thu, Aug 16, 2012 at 3:08 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>> >> > +#include "internal.h"
>> >> > +static int __init init_root_keyring(void)
>> >> > +{
>> >> > +       return install_user_keyrings();
>> >> > +}
>> >> > +
>> >> > +late_initcall(init_root_keyring);
>> >> > --
>> >>
>> >> Why is this in an entirely new file instead of just being added to
>> >> process_keys.c ?
>> >>
>> >> josh
>> >
>> > Only when "CONFIG_INTEGRITY_SIGNATURE" is selected, does this get built.
>>
>> Yes, I noticed that.  It doesn't explain why it's in its own file.  You
>> could accomplish the same thing by wrapping the function and initcall
>> in #ifdef CONFIG_INTEGRITY_SIGNATURE in process_keys.c.
>
> I was under the impression using 'ifdefs' in 'C' code was frowned upon
> (Documentation/SubmittingPatches section 2.2).  This would be an
> exception?

If it makes a big ugly mess it's frowned upon.  But if you're adding 7
lines of code in a new file that will almost certainly never get more
code added to it, I'm not sure.  IMHO, it can go into an existing file.
Others might disagree.  Isn't Linux development fun?!

josh
