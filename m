Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab2HQV1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 17:27:54 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43708 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab2HQV1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 17:27:45 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Josh Boyer <jwboyer@gmail.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>, jmorris@namei.org,
        rusty@rustcorp.com.au, dhowells@redhat.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@us.ibm.com>
References: <cover.1345055638.git.dmitry.kasatkin@intel.com>
	<ec8635c36005ba5ea3784276214fb905720ee3ec.1345055639.git.dmitry.kasatkin@intel.com>
	<CA+5PVA71WegBSBbgZDBZopORkAMN9G8i2MXHmAGdpiSjWzo9RQ@mail.gmail.com>
	<1345144127.3402.2.camel@falcor.watson.ibm.com>
	<CA+5PVA6bwH1RKwT8DiZU2J3xo_c_R5d=0Zo9qHXkq+JhtZeG3Q@mail.gmail.com>
	<1345146349.3402.21.camel@falcor.watson.ibm.com>
	<CA+5PVA5dLY8rux88dC74q3uVwf3mE_VkGxaJU14YHbXkkGuBJQ@mail.gmail.com>
	<1345147278.3402.28.camel@falcor.watson.ibm.com>
Date: Fri, 17 Aug 2012 14:27:34 -0700
In-Reply-To: <1345147278.3402.28.camel@falcor.watson.ibm.com> (Mimi Zohar's
	message of "Thu, 16 Aug 2012 16:01:18 -0400")
Message-ID: <87fw7lyzsp.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+0nH3CKVjgw6LQZSWEiG/z6CDYyg+TLt8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0106]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Mimi Zohar <zohar@linux.vnet.ibm.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC v2 2/7] keys: initialize root uid and session keyrings early
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> writes:

> On Thu, 2012-08-16 at 15:59 -0400, Josh Boyer wrote:
>> On Thu, Aug 16, 2012 at 3:45 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>> > On Thu, 2012-08-16 at 15:13 -0400, Josh Boyer wrote:
>> >> On Thu, Aug 16, 2012 at 3:08 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>> >> >> > +#include "internal.h"
>> >> >> > +static int __init init_root_keyring(void)
>> >> >> > +{
>> >> >> > +       return install_user_keyrings();
>> >> >> > +}
>> >> >> > +
>> >> >> > +late_initcall(init_root_keyring);
>> >> >> > --
>> >> >>
>> >> >> Why is this in an entirely new file instead of just being added to
>> >> >> process_keys.c ?
>> >> >>
>> >> >> josh
>> >> >
>> >> > Only when "CONFIG_INTEGRITY_SIGNATURE" is selected, does this get built.
>> >>
>> >> Yes, I noticed that.  It doesn't explain why it's in its own file.  You
>> >> could accomplish the same thing by wrapping the function and initcall
>> >> in #ifdef CONFIG_INTEGRITY_SIGNATURE in process_keys.c.
>> >
>> > I was under the impression using 'ifdefs' in 'C' code was frowned upon
>> > (Documentation/SubmittingPatches section 2.2).  This would be an
>> > exception?
>> 
>> If it makes a big ugly mess it's frowned upon.  But if you're adding 7
>> lines of code in a new file that will almost certainly never get more
>> code added to it, I'm not sure.  IMHO, it can go into an existing file.
>> Others might disagree.  Isn't Linux development fun?!
>
> This is just a case where if I had 'ifdef's in 'C' code, I'm sure
> someone would have complained.  :)

Why does the code need to be dependent on security modules at all.  The
code should work regardless either way.

Eric
