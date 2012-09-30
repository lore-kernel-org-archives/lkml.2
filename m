Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627Ab2I3VNW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 17:13:22 -0400
Received: from nm14.bullet.mail.ac4.yahoo.com ([98.139.52.211]:39755 "HELO
	nm14.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751450Ab2I3VNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 17:13:21 -0400
X-Yahoo-Newman-Id: 581111.71870.bm@omp1027.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: r3AkEukVM1nzxAi1whLZnlZYvD4JpJXnMwf4FK8M12C1hZG
 xBAI0xyHIJ1DvDoWHNulQyl6Snq5RkErPfwXwTaMnVR5lzMmBz5UCCloIBri
 YhCip3n1aZTae39XSQ9JfVj0BBYdkVBwManZ.aEjYIWG9G_4g58lkMw5iOkY
 DVyAVLqCQetgujEAPh2qOtVD6YZXK5s5JBMhMrRf27zchI_6bOT2o2JU3KlC
 F6U_v17lJUGMmafhJBVgQd4LhPunl3RM.2JcG_DJrHc6c936PmE6Ulxherrz
 9fa_7h5IRBp82iDUu43kJYO8zgqojl2aQz2ItFxnUo5c2A9VqVjBl0KqQTfM
 T0uEcTUEdyIz66xiyTKP4EtHj1xZ4auvOTHxb6dk6fXzxxNzQCB8AsrnZyn0
 4uW06sU6efvEc8TqZYmyLpyTjyWuXmNEljvmD0kjy6kexMDEQ.A--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <5068B5F2.7030800@att.net>
Date: Sun, 30 Sep 2012 16:13:22 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Steven Rostedt <rostedt@goodmis.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 6/10] bug.h: Replace __linktime_error with __compiletime_error
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com> <1348874411-28288-7-git-send-email-daniel.santos@pobox.com> <20120929002353.GC13907@jtriplet-mobl1> <1348880675.22822.102.camel@gandalf.local.home> <20120930132233.GB15400@liondog.tnic>
In-Reply-To: <20120930132233.GB15400@liondog.tnic>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/30/2012 08:22 AM, Borislav Petkov wrote:
> On Fri, Sep 28, 2012 at 09:04:35PM -0400, Steven Rostedt wrote:
>> On Fri, 2012-09-28 at 17:23 -0700, Josh Triplett wrote:
>>> On Fri, Sep 28, 2012 at 06:20:07PM -0500, Daniel Santos wrote:
>>>> Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
>>>> ---
>>>>  include/linux/bug.h |    2 +-
>>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/include/linux/bug.h b/include/linux/bug.h
>>>> index aaac4bb..298a916 100644
>>>> --- a/include/linux/bug.h
>>>> +++ b/include/linux/bug.h
>>>> @@ -73,7 +73,7 @@ extern int __build_bug_on_failed;
>>>>  #define BUILD_BUG()						\
>>>>  	do {							\
>>>>  		extern void __build_bug_failed(void)		\
>>>> -			__linktime_error("BUILD_BUG failed");	\
>>>> +			__compiletime_error("BUILD_BUG failed");\
>>>>  		__build_bug_failed();				\
>>>>  	} while (0)
>>> This change should either occur as part of patch 5 or before patch 5,
>>> not after.
>> I noticed the same thing and was about to comment on it.
>>
>> Please do not break bisectablity. All your patches should compile and
>> run at every step.
> And while we're at it, every patch upstream should have a commit message
> explaining why this is done. No matter how trivial it is, because after
> a sufficient amount of time passes, everyone tends to forget why this
> has been done.
>
> Thanks.
>
Ah, well thank you all for the guidance!

Daniel
