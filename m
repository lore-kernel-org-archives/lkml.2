Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886Ab2LJB14 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 20:27:56 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:54657 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab2LJB1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 20:27:55 -0500
X-AuditID: 85900ec0-d5479b900000152f-5a-50c53a98951c
Message-ID: <50C53A97.4010409@hitachi.com>
Date: Mon, 10 Dec 2012 10:27:51 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Cong Ding <dinggnu@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH v2] arch/x86/tools/gen-insn-attr-x86.awk: remove duplicate
 const
References: <1354920151-4461-1-git-send-email-dinggnu@gmail.com> <3c1e54bc-31ec-4a38-b6d3-58b25760f9cb@email.android.com> <20121207224949.GA6179@gmail.com> <50C27410.7050101@zytor.com> <20121207230302.GB6179@gmail.com> <50C27665.4090206@zytor.com> <20121207231729.GC6179@gmail.com> <50C420A7.9090108@hitachi.com> <b1251e5e-6193-4da4-abfd-0c753995424a@email.android.com> <50C53441.7050802@hitachi.com> <6335450a-8ba4-4e88-a996-49225f0ec890@email.android.com>
In-Reply-To: <6335450a-8ba4-4e88-a996-49225f0ec890@email.android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/12/10 10:03), H. Peter Anvin wrote:
> Yes, if you add a * it becomes an array of pointers.

Right, I would like to make each pointer in the array read-only.

And, of course, the data itself which pointed by the pointer
is already protected.
You can see this in (builddir)/arch/x86/lib/inat_table.c
----
/* Table: 2-byte opcode (0x0f) */
const insn_attr_t inat_escape_table_1[INAT_OPCODE_TABLE_SIZE] = {
[...]
/* Escape opcode map array */
const insn_attr_t * const inat_escape_tables[INAT_ESC_MAX + 1][INAT_LSTPFX_MAX +
 1] = {
        [1][0] = inat_escape_table_1,
----

So I think Cong's v3 is good :)

Thank you,

> 
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> (2012/12/10 0:50), H. Peter Anvin wrote:
>>> No, that would really be wrong - changing the type.
>>
>> What would be wrong? IMHO, this is just a fix to add a fool
>> proof 'const' to array instance itself.
>> ...Or, am I missed anything?
>>
>> Thank you,
>>
>>> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
>>>
>>>> (2012/12/08 8:17), Cong Ding wrote:
>>>>>>>>>> Patch description please?
>>>>>>>>> there are 2 consts in the definition of one variable
>>>>>>>>>
>>>>>>>>
>>>>>>>> Please put in an actual patch description.  The first line
>>>> (subject
>>>>>>>> line) is a title; the patch should make sense without it.
>>>>>>> sorry for that. so like this is fine?
>>>>>>>
>>>>>>
>>>>>> Well, except that typically you should explain which variable it
>> is.
>>>>>> Yes, it is obvious if you look at the patch, but you're making the
>>>>>> reader spend a few more moments than necessary.
>>>>>>
>>>>>> Also, you should explain what the harm is -- if it breaks anything
>>>>>> or is just a cosmetic issue.
>>>>> sorry again for lacking of experience...
>>>>> and I missed another same error, so send version 2.
>>>>
>>>> Ah, sorry for my mistake. I would like to make both the value
>>>> pointed by the pointers and the pointers itself read-only.
>>>> Thus the right way of the patch should be;
>>>>
>>>> -	print "const insn_attr_t const *inat_escape_tables[INAT_ESC_MAX +
>> 1]"
>>>> \
>>>> +	print "const insn_attr_t * const inat_escape_tables[INAT_ESC_MAX +
>>>> 1]" \
>>>>
>>>> Cong, could you update your patch? then I can Ack that.
>>>>
>>>> Thank you,
>>>>
>>>>>
>>>>> - cong
>>>>> ---
>>>>> From 6cf729b913287a6fc06325ca75ccf0efff9274e8 Mon Sep 17 00:00:00
>>>> 2001
>>>>> From: Cong Ding <dinggnu@gmail.com>
>>>>> Date: Fri, 7 Dec 2012 23:14:32 +0000
>>>>> Subject: [PATCH] arch/x86/tools/gen-insn-attr-x86.awk: remove
>>>> duplicate const
>>>>>
>>>>> fix the following sparse warning:
>>>>> arch/x86/lib/inat-tables.c:1080:25: warning: duplicate const
>>>>> arch/x86/lib/inat-tables.c:1095:25: warning: duplicate const
>>>>> arch/x86/lib/inat-tables.c:1118:25: warning: duplicate const
>>>>>
>>>>> for variable inat_escape_tables, inat_group_tables, and
>>>> inat_avx_tables
>>>>>
>>>>> Signed-off-by: Cong Ding <dinggnu@gmail.com>
>>>>> ---
>>>>>  arch/x86/tools/gen-insn-attr-x86.awk |    6 +++---
>>>>>  1 files changed, 3 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/arch/x86/tools/gen-insn-attr-x86.awk
>>>> b/arch/x86/tools/gen-insn-attr-x86.awk
>>>>> index ddcf39b..987c7b2 100644
>>>>> --- a/arch/x86/tools/gen-insn-attr-x86.awk
>>>>> +++ b/arch/x86/tools/gen-insn-attr-x86.awk
>>>>> @@ -356,7 +356,7 @@ END {
>>>>>  		exit 1
>>>>>  	# print escape opcode map's array
>>>>>  	print "/* Escape opcode map array */"
>>>>> -	print "const insn_attr_t const *inat_escape_tables[INAT_ESC_MAX +
>>>> 1]" \
>>>>> +	print "const insn_attr_t *inat_escape_tables[INAT_ESC_MAX + 1]" \
>>>>>  	      "[INAT_LSTPFX_MAX + 1] = {"
>>>>>  	for (i = 0; i < geid; i++)
>>>>>  		for (j = 0; j < max_lprefix; j++)
>>>>> @@ -365,7 +365,7 @@ END {
>>>>>  	print "};\n"
>>>>>  	# print group opcode map's array
>>>>>  	print "/* Group opcode map array */"
>>>>> -	print "const insn_attr_t const *inat_group_tables[INAT_GRP_MAX +
>>>> 1]"\
>>>>> +	print "const insn_attr_t *inat_group_tables[INAT_GRP_MAX + 1]"\
>>>>>  	      "[INAT_LSTPFX_MAX + 1] = {"
>>>>>  	for (i = 0; i < ggid; i++)
>>>>>  		for (j = 0; j < max_lprefix; j++)
>>>>> @@ -374,7 +374,7 @@ END {
>>>>>  	print "};\n"
>>>>>  	# print AVX opcode map's array
>>>>>  	print "/* AVX opcode map array */"
>>>>> -	print "const insn_attr_t const *inat_avx_tables[X86_VEX_M_MAX +
>>>> 1]"\
>>>>> +	print "const insn_attr_t *inat_avx_tables[X86_VEX_M_MAX + 1]"\
>>>>>  	      "[INAT_LSTPFX_MAX + 1] = {"
>>>>>  	for (i = 0; i < gaid; i++)
>>>>>  		for (j = 0; j < max_lprefix; j++)
>>>>>
>>>
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


