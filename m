Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab2LJB44 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 20:56:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34596 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064Ab2LJB4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 20:56:55 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <50C53FD6.3000306@hitachi.com>
References: <1354920151-4461-1-git-send-email-dinggnu@gmail.com> <3c1e54bc-31ec-4a38-b6d3-58b25760f9cb@email.android.com> <20121207224949.GA6179@gmail.com> <50C27410.7050101@zytor.com> <20121207230302.GB6179@gmail.com> <50C27665.4090206@zytor.com> <20121207231729.GC6179@gmail.com> <50C420A7.9090108@hitachi.com> <b1251e5e-6193-4da4-abfd-0c753995424a@email.android.com> <50C53441.7050802@hitachi.com> <6335450a-8ba4-4e88-a996-49225f0ec890@email.android.com> <50C53A97.4010409@hitachi.com> <51c3944e-5570-4e76-a7ac-c89b30c4c989@email.android.com> <50C53FD6.3000306@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] arch/x86/tools/gen-insn-attr-x86.awk: remove duplicate const
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 09 Dec 2012 17:56:34 -0800
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Cong Ding <dinggnu@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Message-ID: <9440d1bf-b1ae-43da-ac7f-492dbe06c943@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, you're right.  I blame the font on my phone.

Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

>(2012/12/10 10:34), H. Peter Anvin wrote:
>> You're changing the array from an array of insn_attr_t to pointers to
>insn_attr_t?
>
>No, please look at the code carefully,
>
>-	print "const insn_attr_t const *inat_escape_tables[INAT_ESC_MAX + 1]"
>\
>                                      ^^
>+	print "const insn_attr_t * const inat_escape_tables[INAT_ESC_MAX +
>1]" \
>                                ^^
>Both are pointers of array.
>
>I'd just change the position of const.
>
>const insn_attr_t const * -> const insn_attr_t * const
>
>Thank you,
>
>> 
>> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
>> 
>>> (2012/12/10 10:03), H. Peter Anvin wrote:
>>>> Yes, if you add a * it becomes an array of pointers.
>>>
>>> Right, I would like to make each pointer in the array read-only.
>>>
>>> And, of course, the data itself which pointed by the pointer
>>> is already protected.
>>> You can see this in (builddir)/arch/x86/lib/inat_table.c
>>> ----
>>> /* Table: 2-byte opcode (0x0f) */
>>> const insn_attr_t inat_escape_table_1[INAT_OPCODE_TABLE_SIZE] = {
>>> [...]
>>> /* Escape opcode map array */
>>> const insn_attr_t * const inat_escape_tables[INAT_ESC_MAX +
>>> 1][INAT_LSTPFX_MAX +
>>> 1] = {
>>>        [1][0] = inat_escape_table_1,
>>> ----
>>>
>>> So I think Cong's v3 is good :)
>>>
>>> Thank you,
>>>
>>>>
>>>> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
>>>>
>>>>> (2012/12/10 0:50), H. Peter Anvin wrote:
>>>>>> No, that would really be wrong - changing the type.
>>>>>
>>>>> What would be wrong? IMHO, this is just a fix to add a fool
>>>>> proof 'const' to array instance itself.
>>>>> ...Or, am I missed anything?
>>>>>
>>>>> Thank you,
>>>>>
>>>>>> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
>>>>>>
>>>>>>> (2012/12/08 8:17), Cong Ding wrote:
>>>>>>>>>>>>> Patch description please?
>>>>>>>>>>>> there are 2 consts in the definition of one variable
>>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> Please put in an actual patch description.  The first line
>>>>>>> (subject
>>>>>>>>>>> line) is a title; the patch should make sense without it.
>>>>>>>>>> sorry for that. so like this is fine?
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Well, except that typically you should explain which variable
>it
>>>>> is.
>>>>>>>>> Yes, it is obvious if you look at the patch, but you're making
>>> the
>>>>>>>>> reader spend a few more moments than necessary.
>>>>>>>>>
>>>>>>>>> Also, you should explain what the harm is -- if it breaks
>>> anything
>>>>>>>>> or is just a cosmetic issue.
>>>>>>>> sorry again for lacking of experience...
>>>>>>>> and I missed another same error, so send version 2.
>>>>>>>
>>>>>>> Ah, sorry for my mistake. I would like to make both the value
>>>>>>> pointed by the pointers and the pointers itself read-only.
>>>>>>> Thus the right way of the patch should be;
>>>>>>>
>>>>>>> -	print "const insn_attr_t const
>*inat_escape_tables[INAT_ESC_MAX
>>> +
>>>>> 1]"
>>>>>>> \
>>>>>>> +	print "const insn_attr_t * const
>inat_escape_tables[INAT_ESC_MAX
>>> +
>>>>>>> 1]" \
>>>>>>>
>>>>>>> Cong, could you update your patch? then I can Ack that.
>>>>>>>
>>>>>>> Thank you,
>>>>>>>
>>>>>>>>
>>>>>>>> - cong
>>>>>>>> ---
>>>>>>>> From 6cf729b913287a6fc06325ca75ccf0efff9274e8 Mon Sep 17
>00:00:00
>>>>>>> 2001
>>>>>>>> From: Cong Ding <dinggnu@gmail.com>
>>>>>>>> Date: Fri, 7 Dec 2012 23:14:32 +0000
>>>>>>>> Subject: [PATCH] arch/x86/tools/gen-insn-attr-x86.awk: remove
>>>>>>> duplicate const
>>>>>>>>
>>>>>>>> fix the following sparse warning:
>>>>>>>> arch/x86/lib/inat-tables.c:1080:25: warning: duplicate const
>>>>>>>> arch/x86/lib/inat-tables.c:1095:25: warning: duplicate const
>>>>>>>> arch/x86/lib/inat-tables.c:1118:25: warning: duplicate const
>>>>>>>>
>>>>>>>> for variable inat_escape_tables, inat_group_tables, and
>>>>>>> inat_avx_tables
>>>>>>>>
>>>>>>>> Signed-off-by: Cong Ding <dinggnu@gmail.com>
>>>>>>>> ---
>>>>>>>>  arch/x86/tools/gen-insn-attr-x86.awk |    6 +++---
>>>>>>>>  1 files changed, 3 insertions(+), 3 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/arch/x86/tools/gen-insn-attr-x86.awk
>>>>>>> b/arch/x86/tools/gen-insn-attr-x86.awk
>>>>>>>> index ddcf39b..987c7b2 100644
>>>>>>>> --- a/arch/x86/tools/gen-insn-attr-x86.awk
>>>>>>>> +++ b/arch/x86/tools/gen-insn-attr-x86.awk
>>>>>>>> @@ -356,7 +356,7 @@ END {
>>>>>>>>  		exit 1
>>>>>>>>  	# print escape opcode map's array
>>>>>>>>  	print "/* Escape opcode map array */"
>>>>>>>> -	print "const insn_attr_t const
>*inat_escape_tables[INAT_ESC_MAX
>>> +
>>>>>>> 1]" \
>>>>>>>> +	print "const insn_attr_t *inat_escape_tables[INAT_ESC_MAX +
>1]"
>>> \
>>>>>>>>  	      "[INAT_LSTPFX_MAX + 1] = {"
>>>>>>>>  	for (i = 0; i < geid; i++)
>>>>>>>>  		for (j = 0; j < max_lprefix; j++)
>>>>>>>> @@ -365,7 +365,7 @@ END {
>>>>>>>>  	print "};\n"
>>>>>>>>  	# print group opcode map's array
>>>>>>>>  	print "/* Group opcode map array */"
>>>>>>>> -	print "const insn_attr_t const
>*inat_group_tables[INAT_GRP_MAX
>>> +
>>>>>>> 1]"\
>>>>>>>> +	print "const insn_attr_t *inat_group_tables[INAT_GRP_MAX +
>1]"\
>>>>>>>>  	      "[INAT_LSTPFX_MAX + 1] = {"
>>>>>>>>  	for (i = 0; i < ggid; i++)
>>>>>>>>  		for (j = 0; j < max_lprefix; j++)
>>>>>>>> @@ -374,7 +374,7 @@ END {
>>>>>>>>  	print "};\n"
>>>>>>>>  	# print AVX opcode map's array
>>>>>>>>  	print "/* AVX opcode map array */"
>>>>>>>> -	print "const insn_attr_t const *inat_avx_tables[X86_VEX_M_MAX
>+
>>>>>>> 1]"\
>>>>>>>> +	print "const insn_attr_t *inat_avx_tables[X86_VEX_M_MAX +
>1]"\
>>>>>>>>  	      "[INAT_LSTPFX_MAX + 1] = {"
>>>>>>>>  	for (i = 0; i < gaid; i++)
>>>>>>>>  		for (j = 0; j < max_lprefix; j++)
>>>>>>>>
>>>>>>
>>>>
>> 

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
