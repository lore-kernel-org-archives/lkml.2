Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab1LDQMO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 11:12:14 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:43259 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037Ab1LDQML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 11:12:11 -0500
Message-ID: <1323015121.4edb9bd116ce9@imp.free.fr>
Date: Sun, 04 Dec 2011 17:12:01 +0100
From: wallak@free.fr
To: linux-kernel@vger.kernel.org
Subject: ACPI - _PCT - linux-3.1 - output different on last kernels - bug
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
User-Agent: Internet Messaging Program (IMP) 3.2.8
X-Originating-IP: 88.161.131.83
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an issue on a dell x300 laptop, everything was working fine with Linux
kernel version 2.6.38.8. But when I update to Linux-3.1.4, I have an issue, PHC
failed to work, and this is related to the ACPI linux layer.

After some investigation, it seems that the ACPI layer gives different results
depending on the kernel version.

This seems related to a bug in the ACPI layer, the same data giving two
different results when parsing the '_PCT' chunk.


The ACPI log differences is available below. When _PCT chunk returns: 0000: 82
0C 00 7F 00 00 00 00 00 00 00 00 00 00 00 79... everything is working fine...

PHC & Linux-2.6.38.8 is still working when using the ACPI parsing code from
linux-3.1: drivers/acpi/acpica/ direcory. The issue may be related to a
different initialization, or a different constant somewhere.

The disassembled ACPI code is available below. It seems that CAP0 & PDC0 are not
evaluated properly on the last kernels.

Do you know where this bug come from ?

How to address it properly ?

Best Regards,
---



1c1
<  nsutils-0363 [-2] ns_build_internal_name: Returning [e30dee40] (rel) "_PCT"
---
>  nsutils-0363 [-2] ns_build_internal_name: Returning [e5e47bc0] (rel) "_PCT"
6,7c6,7
< nssearch-0149 [-1] ns_search_one_scope   : Name [_PCT] (Method) e6c31bc0 found
in scope [CPU0] e6c25b90
<  nsutils-0363 [00] ns_build_internal_name: Returning [e3098e20] (rel) "_PCT"
---
> nssearch-0149 [-1] ns_search_one_scope   : Name [_PCT] (Method) e6c30bc0 found
in scope [CPU0] e6c25b90
>  nsutils-0363 [00] ns_build_internal_name: Returning [e5e24580] (rel) "_PCT"
12,13c12,13
< nssearch-0149 [01] ns_search_one_scope   : Name [_PCT] (Method) e6c31bc0 found
in scope [CPU0] e6c25b90
<   nseval-0127 [-3] ns_evaluate           : _PCT [e6c31bc0] Value e6c369d8
---
> nssearch-0149 [01] ns_search_one_scope   : Name [_PCT] (Method) e6c30bc0 found
in scope [CPU0] e6c25b90
>   nseval-0127 [-3] ns_evaluate           : _PCT [e6c30bc0] Value e6c352a8
15c15
< ACPI: Execute Method [\_PR_.CPU0._PCT] (Node e6c31bc0)
---
> ACPI: Execute Method [\_PR_.CPU0._PCT] (Node e6c30bc0)
17,18c17,18
<   utmisc-0256 [00] ut_allocate_owner_id  : Allocated OwnerId: F7
<  psxface-0257 [-2] ps_execute_method     : **** Begin Method Parse/Execute
[_PCT] **** Node=e6c31bc0 Obj=e6c369d8
---
>   utmisc-0256 [00] ut_allocate_owner_id  : Allocated OwnerId: F6
>  psxface-0257 [-2] ps_execute_method     : **** Begin Method Parse/Execute
[_PCT] **** Node=e6c30bc0 Obj=e6c352a8
21,30c21,30
<  psparse-0448 [-1] ps_parse_aml          : Entered with WalkState=e3096000
Aml=e7e88f13 size=0
<  psparse-0493 [-1] ps_parse_aml          : State=e3096000
< dscontrol-0077 [02] ds_exec_begin_control_: Op=e30463c0 Opcode=A0
State=e3096000
<   psloop-1085 [00] ps_parse_loop         : Opcode 00A0 [If] Op e30463c0 Aml
e7e88f14 AmlOffset 00000
<  dswexec-0268 [02] ds_exec_begin_op      : Exec predicate Op=e3046340
State=e3096000
<   psloop-1085 [00] ps_parse_loop         : Opcode 0093 [LEqual] Op e3046340
Aml e7e88f16 AmlOffset 00002
<   psloop-1085 [00] ps_parse_loop         : Opcode 007B [And] Op e3046300 Aml
e7e88f17 AmlOffset 00003
< dswload2-0083 [03] ds_load2_begin_op     : Op=e3046380 State=e3096000
<   psloop-1085 [00] ps_parse_loop         : Opcode 002D [-NamePath-] Op
e3046380 Aml e7e88f17 AmlOffset 00004
< nsaccess-0398 [03] ns_lookup             : Searching relative to prefix scope
[_PCT] (e6c31bc0)
---
>  psparse-0448 [-1] ps_parse_aml          : Entered with WalkState=e5e45800
Aml=e7e88f13 size=0
>  psparse-0493 [-1] ps_parse_aml          : State=e5e45800
> dscontrol-0077 [02] ds_exec_begin_control_: Op=e5d7b3c0 Opcode=A0
State=e5e45800
>   psloop-1085 [00] ps_parse_loop         : Opcode 00A0 [If] Op e5d7b3c0 Aml
e7e88f14 AmlOffset 00000
>  dswexec-0268 [02] ds_exec_begin_op      : Exec predicate Op=e5d7b340
State=e5e45800
>   psloop-1085 [00] ps_parse_loop         : Opcode 0093 [LEqual] Op e5d7b340
Aml e7e88f16 AmlOffset 00002
>   psloop-1085 [00] ps_parse_loop         : Opcode 007B [And] Op e5d7b300 Aml
e7e88f17 AmlOffset 00003
> dswload2-0083 [03] ds_load2_begin_op     : Op=e5d7b380 State=e5e45800
>   psloop-1085 [00] ps_parse_loop         : Opcode 002D [-NamePath-] Op
e5d7b380 Aml e7e88f17 AmlOffset 00004
> nsaccess-0398 [03] ns_lookup             : Searching relative to prefix scope
[_PCT] (e6c30bc0)
33,34c33,34
< nssearch-0114 [05] ns_search_one_scope   : Searching \_PR_.CPU0._PCT
(e6c31bc0) For [PDC0] (Untyped)
< nssearch-0168 [05] ns_search_one_scope   : Name [PDC0] (Untyped) not found in
search in scope [_PCT] e6c31bc0 first child   (null)
---
> nssearch-0114 [05] ns_search_one_scope   : Searching \_PR_.CPU0._PCT
(e6c30bc0) For [PDC0] (Untyped)
> nssearch-0168 [05] ns_search_one_scope   : Name [PDC0] (Untyped) not found in
search in scope [_PCT] e6c30bc0 first child   (null)
37,38c37,38
< nssearch-0149 [06] ns_search_one_scope   : Name [PDC0] (Integer) e6c31bf0
found in scope [CPU0] e6c25b90
<  dsutils-0481 [03] ds_create_operand     : Getting a name: Arg=e3046380
---
> nssearch-0149 [06] ns_search_one_scope   : Name [PDC0] (Integer) e6c30bf0
found in scope [CPU0] e6c25b90
>  dsutils-0481 [03] ds_create_operand     : Getting a name: Arg=e5d7b380
45c45
< nsaccess-0398 [04] ns_lookup             : Searching relative to prefix scope
[_PCT] (e6c31bc0)
---
> nsaccess-0398 [04] ns_lookup             : Searching relative to prefix scope
[_PCT] (e6c30bc0)
48,49c48,49
< nssearch-0114 [06] ns_search_one_scope   : Searching \_PR_.CPU0._PCT
(e6c31bc0) For [PDC0] (Untyped)
< nssearch-0168 [06] ns_search_one_scope   : Name [PDC0] (Untyped) not found in
search in scope [_PCT] e6c31bc0 first child   (null)
---
> nssearch-0114 [06] ns_search_one_scope   : Searching \_PR_.CPU0._PCT
(e6c30bc0) For [PDC0] (Untyped)
> nssearch-0168 [06] ns_search_one_scope   : Name [PDC0] (Untyped) not found in
search in scope [_PCT] e6c30bc0 first child   (null)
52,71c52,71
< nssearch-0149 [07] ns_search_one_scope   : Name [PDC0] (Integer) e6c31bf0
found in scope [CPU0] e6c25b90
< dswstate-0336 [03] ds_obj_stack_push     : Obj=e6c31bf0 [Integer]
State=e3096000 #Ops=1
< exresnte-0101 [04] ex_resolve_node_to_val: Entry=e6c31bf0 SourceDesc=e6c36a5c
[Integer]
< exresolv-0119 [03] ex_resolve_to_value   : Resolved object e6c36a5c
< dswstate-0381 [02] ds_obj_stack_pop      : Count=1 State=e3096000 #Ops=0
< dswstate-0244 [02] ds_result_stack_push  : Results=e636f2cc State=e3096000
< dswstate-0199 [02] ds_result_push        : Obj=e6cbada0 [Integer]
State=e3096000 Num=1 Cur=0
<  dsutils-0131 [03] ds_do_implicit_return : Result e6cbada0 will be implicitly
returned; Prev=e6cbac14
<  dsutils-0089 [03] ds_clear_implicit_retu: Removing reference on stale
implicit return obj e6cbac14
<  dsutils-0308 [03] ds_is_result_used     : Result of [-NamePath-] used by
Parent [And] Op=e3046380
<  psscope-0230 [02] ps_pop_scope          : Popped Op e3046300 Args 0
<   psloop-0841 [01] ps_complete_op        : Popped scope, Op=e3046300
<   psloop-1085 [00] ps_parse_loop         : Opcode 0001 [One] Op e30462e0 Aml
e7e88f1c AmlOffset 00008
<  psscope-0230 [02] ps_pop_scope          : Popped Op e3046300 Args 0
<   psloop-0841 [01] ps_complete_op        : Popped scope, Op=e3046300
<  dsutils-0613 [03] ds_create_operand     : Null namepath: Arg=e3046320
< dswstate-0336 [03] ds_obj_stack_push     : Obj=e6cbac14 [Integer]
State=e3096000 #Ops=1
<  dsutils-0750 [02] ds_create_operands    : Arg #1 (e3046320) done,
Arg1=e3046380
< dswstate-0336 [03] ds_obj_stack_push     : Obj=e6d29fb0 [Integer]
State=e3096000 #Ops=2
<  dsutils-0750 [02] ds_create_operands    : Arg #0 (e30462e0) done,
Arg1=e3046380
---
> nssearch-0149 [07] ns_search_one_scope   : Name [PDC0] (Integer) e6c30bf0
found in scope [CPU0] e6c25b90
> dswstate-0336 [03] ds_obj_stack_push     : Obj=e6c30bf0 [Integer]
State=e5e45800 #Ops=1
> exresnte-0101 [04] ex_resolve_node_to_val: Entry=e6c30bf0 SourceDesc=e6c35338
[Integer]
> exresolv-0119 [03] ex_resolve_to_value   : Resolved object e6c35338
> dswstate-0381 [02] ds_obj_stack_pop      : Count=1 State=e5e45800 #Ops=0
> dswstate-0244 [02] ds_result_stack_push  : Results=e5ddf2d8 State=e5e45800
> dswstate-0199 [02] ds_result_push        : Obj=e6ccafc8 [Integer]
State=e5e45800 Num=1 Cur=0
>  dsutils-0131 [03] ds_do_implicit_return : Result e6ccafc8 will be implicitly
returned; Prev=e6ccaf08
>  dsutils-0089 [03] ds_clear_implicit_retu: Removing reference on stale
implicit return obj e6ccaf08
>  dsutils-0308 [03] ds_is_result_used     : Result of [-NamePath-] used by
Parent [And] Op=e5d7b380
>  psscope-0230 [02] ps_pop_scope          : Popped Op e5d7b300 Args 0
>   psloop-0841 [01] ps_complete_op        : Popped scope, Op=e5d7b300
>   psloop-1085 [00] ps_parse_loop         : Opcode 0001 [One] Op e5d7b2e0 Aml
e7e88f1c AmlOffset 00008
>  psscope-0230 [02] ps_pop_scope          : Popped Op e5d7b300 Args 0
>   psloop-0841 [01] ps_complete_op        : Popped scope, Op=e5d7b300
>  dsutils-0613 [03] ds_create_operand     : Null namepath: Arg=e5d7b320
> dswstate-0336 [03] ds_obj_stack_push     : Obj=e6ccaf08 [Integer]
State=e5e45800 #Ops=1
>  dsutils-0750 [02] ds_create_operands    : Arg #1 (e5d7b320) done,
Arg1=e5d7b380
> dswstate-0336 [03] ds_obj_stack_push     : Obj=e6d11fc8 [Integer]
State=e5e45800 #Ops=2
>  dsutils-0750 [02] ds_create_operands    : Arg #0 (e5d7b2e0) done,
Arg1=e5d7b380
73,76c73,76
< dswstate-0290 [03] ds_result_stack_pop   : Result=e636f2cc RemainingResults=0
State=e3096000
< dswstate-0126 [03] ds_result_pop         : Obj=e6cbada0 [Integer] Index=0
State=e3096000 Num=0
< dswstate-0336 [03] ds_obj_stack_push     : Obj=e6cbada0 [Integer]
State=e3096000 #Ops=3
<  dsutils-0750 [02] ds_create_operands    : Arg #4294967295 (e3046380) done,
Arg1=e3046380
---
> dswstate-0290 [03] ds_result_stack_pop   : Result=e5ddf2d8 RemainingResults=0
State=e5e45800
> dswstate-0126 [03] ds_result_pop         : Obj=e6ccafc8 [Integer] Index=0
State=e5e45800 Num=0
> dswstate-0336 [03] ds_obj_stack_push     : Obj=e6ccafc8 [Integer]
State=e5e45800 #Ops=3
>  dsutils-0750 [02] ds_create_operands    : Arg #4294967295 (e5d7b380) done,
Arg1=e5d7b380
78,79c78,79
< exresolv-0119 [03] ex_resolve_to_value   : Resolved object e6d29fb0
< exresolv-0119 [03] ex_resolve_to_value   : Resolved object e6cbada0
---
> exresolv-0119 [03] ex_resolve_to_value   : Resolved object e6d11fc8
> exresolv-0119 [03] ex_resolve_to_value   : Resolved object e6ccafc8
81,83c81,83
<   exdump-0494 [02] ex_dump_operand       : e6cbada0 Integer 00000000000009BF
<   exdump-0494 [02] ex_dump_operand       : e6d29fb0 Integer 0000000000000001
<   exdump-0494 [02] ex_dump_operand       : e6cbac14 Integer 0000000000000000
---
>   exdump-0494 [02] ex_dump_operand       : e6ccafc8 Integer 00000000F0000000
>   exdump-0494 [02] ex_dump_operand       : e6d11fc8 Integer 0000000000000001
>   exdump-0494 [02] ex_dump_operand       : e6ccaf08 Integer 0000000000000000
85,96c85,96
< dswstate-0244 [01] ds_result_stack_push  : Results=e636f2cc State=e3096000
< dswstate-0199 [01] ds_result_push        : Obj=e6d29f84 [Integer]
State=e3096000 Num=1 Cur=0
<  dsutils-0131 [03] ds_do_implicit_return : Result e6d29f84 will be implicitly
returned; Prev=e6cbada0
<  dsutils-0089 [03] ds_clear_implicit_retu: Removing reference on stale
implicit return obj e6cbada0
<  dsutils-0308 [03] ds_is_result_used     : Result of [And] used by Parent
[LEqual] Op=e3046300
<  psscope-0230 [02] ps_pop_scope          : Popped Op e3046340 Args 0
<   psloop-0841 [01] ps_complete_op        : Popped scope, Op=e3046340
<   psloop-1085 [00] ps_parse_loop         : Opcode 0001 [One] Op e3046300 Aml
e7e88f1e AmlOffset 0000A
<  psscope-0230 [02] ps_pop_scope          : Popped Op e3046340 Args 0
<   psloop-0841 [01] ps_complete_op        : Popped scope, Op=e3046340
< dswstate-0336 [03] ds_obj_stack_push     : Obj=e6cbada0 [Integer]
State=e3096000 #Ops=1
<  dsutils-0750 [02] ds_create_operands    : Arg #0 (e3046300) done,
Arg1=e30462c0
---
> dswstate-0244 [01] ds_result_stack_push  : Results=e5ddf2d8 State=e5e45800
> dswstate-0199 [01] ds_result_push        : Obj=e6d11f98 [Integer]
State=e5e45800 Num=1 Cur=0
>  dsutils-0131 [03] ds_do_implicit_return : Result e6d11f98 will be implicitly
returned; Prev=e6ccafc8
>  dsutils-0089 [03] ds_clear_implicit_retu: Removing reference on stale
implicit return obj e6ccafc8
>  dsutils-0308 [03] ds_is_result_used     : Result of [And] used by Parent
[LEqual] Op=e5d7b300
>  psscope-0230 [02] ps_pop_scope          : Popped Op e5d7b340 Args 0
>   psloop-0841 [01] ps_complete_op        : Popped scope, Op=e5d7b340
>   psloop-1085 [00] ps_parse_loop         : Opcode 0001 [One] Op e5d7b300 Aml
e7e88f1e AmlOffset 0000A
>  psscope-0230 [02] ps_pop_scope          : Popped Op e5d7b340 Args 0
>   psloop-0841 [01] ps_complete_op        : Popped scope, Op=e5d7b340
> dswstate-0336 [03] ds_obj_stack_push     : Obj=e6ccafc8 [Integer]
State=e5e45800 #Ops=1
>  dsutils-0750 [02] ds_create_operands    : Arg #0 (e5d7b300) done,
Arg1=e5d7b2c0
98,101c98,101
< dswstate-0290 [03] ds_result_stack_pop   : Result=e636f2cc RemainingResults=0
State=e3096000
< dswstate-0126 [03] ds_result_pop         : Obj=e6d29f84 [Integer] Index=0
State=e3096000 Num=0
< dswstate-0336 [03] ds_obj_stack_push     : Obj=e6d29f84 [Integer]
State=e3096000 #Ops=2
<  dsutils-0750 [02] ds_create_operands    : Arg #4294967295 (e30462c0) done,
Arg1=e30462c0
---
> dswstate-0290 [03] ds_result_stack_pop   : Result=e5ddf2d8 RemainingResults=0
State=e5e45800
> dswstate-0126 [03] ds_result_pop         : Obj=e6d11f98 [Integer] Index=0
State=e5e45800 Num=0
> dswstate-0336 [03] ds_obj_stack_push     : Obj=e6d11f98 [Integer]
State=e5e45800 #Ops=2
>  dsutils-0750 [02] ds_create_operands    : Arg #4294967295 (e5d7b2c0) done,
Arg1=e5d7b2c0
103,104c103,104
< exresolv-0119 [03] ex_resolve_to_value   : Resolved object e6cbada0
< exresolv-0119 [03] ex_resolve_to_value   : Resolved object e6d29f84
---
> exresolv-0119 [03] ex_resolve_to_value   : Resolved object e6ccafc8
> exresolv-0119 [03] ex_resolve_to_value   : Resolved object e6d11f98
106,107c106,107
<   exdump-0494 [02] ex_dump_operand       : e6d29f84 Integer 0000000000000001
<   exdump-0494 [02] ex_dump_operand       : e6cbada0 Integer 0000000000000001
---
>   exdump-0494 [02] ex_dump_operand       : e6d11f98 Integer 0000000000000000
>   exdump-0494 [02] ex_dump_operand       : e6ccafc8 Integer 0000000000000001
109,126c109,128
< dswstate-0244 [01] ds_result_stack_push  : Results=e636f2cc State=e3096000
< dswstate-0199 [01] ds_result_push        : Obj=e6cbac14 [Integer]
State=e3096000 Num=1 Cur=0
< dswstate-0290 [02] ds_result_stack_pop   : Result=e636f2cc RemainingResults=0
State=e3096000
< dswstate-0126 [02] ds_result_pop         : Obj=e6cbac14 [Integer] Index=0
State=e3096000 Num=0
<  dsutils-0131 [02] ds_do_implicit_return : Result e6cbac14 will be implicitly
returned; Prev=e6d29f84
<  dsutils-0089 [02] ds_clear_implicit_retu: Removing reference on stale
implicit return obj e6d29f84
<  dswexec-0177 [02] ds_get_predicate_value: Completed a predicate eval=1
Op=e3046340
<  psscope-0230 [02] ps_pop_scope          : Popped Op e30463c0 Args 0
<   psloop-0841 [01] ps_complete_op        : Popped scope, Op=e30463c0
< dscontrol-0077 [02] ds_exec_begin_control_: Op=e3046340 Opcode=A4
State=e3096000
<   psloop-1085 [00] ps_parse_loop         : Opcode 00A4 [Return] Op e3046340
Aml e7e88f1f AmlOffset 0000B
<   psloop-1085 [00] ps_parse_loop         : Opcode 0012 [Package] Op e30993f4
Aml e7e88f20 AmlOffset 0000C
<   psloop-1085 [00] ps_parse_loop         : Opcode 0011 [Buffer] Op e30993c4
Aml e7e88f23 AmlOffset 0000F
<   psloop-1085 [00] ps_parse_loop         : Opcode 000A [ByteConst] Op e30462c0
Aml e7e88f25 AmlOffset 00011
<  psscope-0230 [02] ps_pop_scope          : Popped Op e30993c4 Args 0
<   psloop-0841 [01] ps_complete_op        : Popped scope, Op=e30993c4
<  dswexec-0581 [01] ds_exec_end_op        : Executing CreateObject
(Buffer/Package) Op=e30993c4
< dswstate-0336 [03] ds_obj_stack_push     : Obj=e6d29f84 [Integer]
State=e3096000 #Ops=1
---
> dswstate-0244 [01] ds_result_stack_push  : Results=e5ddf2d8 State=e5e45800
> dswstate-0199 [01] ds_result_push        : Obj=e6ccaf08 [Integer]
State=e5e45800 Num=1 Cur=0
> dswstate-0290 [02] ds_result_stack_pop   : Result=e5ddf2d8 RemainingResults=0
State=e5e45800
> dswstate-0126 [02] ds_result_pop         : Obj=e6ccaf08 [Integer] Index=0
State=e5e45800 Num=0
>  dsutils-0131 [02] ds_do_implicit_return : Result e6ccaf08 will be implicitly
returned; Prev=e6d11f98
>  dsutils-0089 [02] ds_clear_implicit_retu: Removing reference on stale
implicit return obj e6d11f98
>  dswexec-0177 [02] ds_get_predicate_value: Completed a predicate eval=0
Op=e5d7b340
>  psscope-0230 [02] ps_pop_scope          : Popped Op e5d7b3c0 Args 0
> dscontrol-0177 [02] ds_exec_end_control_op: [IF_OP] Op=e5d7b3c0
> dscontrol-0077 [02] ds_exec_begin_control_: Op=e5d7b3c0 Opcode=A1
State=e5e45800
>   psloop-1085 [00] ps_parse_loop         : Opcode 00A1 [Else] Op e5d7b3c0 Aml
e7e88f4d AmlOffset 00039
> dscontrol-0077 [02] ds_exec_begin_control_: Op=e5d7b340 Opcode=A4
State=e5e45800
>   psloop-1085 [00] ps_parse_loop         : Opcode 00A4 [Return] Op e5d7b340
Aml e7e88f4f AmlOffset 0003B
>   psloop-1085 [00] ps_parse_loop         : Opcode 0012 [Package] Op e5d763f8
Aml e7e88f50 AmlOffset 0003C
>   psloop-1085 [00] ps_parse_loop         : Opcode 0011 [Buffer] Op e5d763c8
Aml e7e88f53 AmlOffset 0003F
>   psloop-1085 [00] ps_parse_loop         : Opcode 000A [ByteConst] Op e5d7b2c0
Aml e7e88f55 AmlOffset 00041
>  psscope-0230 [02] ps_pop_scope          : Popped Op e5d763c8 Args 0
>   psloop-0841 [01] ps_complete_op        : Popped scope, Op=e5d763c8
>  dswexec-0581 [01] ds_exec_end_op        : Executing CreateObject
(Buffer/Package) Op=e5d763c8
> dswstate-0336 [03] ds_obj_stack_push     : Obj=e6d11f98 [Integer]
State=e5e45800 #Ops=1
128c130
< exresolv-0119 [04] ex_resolve_to_value   : Resolved object e6d29f84
---
> exresolv-0119 [04] ex_resolve_to_value   : Resolved object e6d11f98
130c132
<   exdump-0494 [03] ex_dump_operand       : e6d29f84 Integer 0000000000000011
---
>   exdump-0494 [03] ex_dump_operand       : e6d11f98 Integer 0000000000000011
132,138c134,140
< dswstate-0381 [02] ds_obj_stack_pop      : Count=1 State=e3096000 #Ops=0
<   psloop-1085 [00] ps_parse_loop         : Opcode 0011 [Buffer] Op e30993c4
Aml e7e88f38 AmlOffset 00024
<   psloop-1085 [00] ps_parse_loop         : Opcode 000A [ByteConst] Op e30462c0
Aml e7e88f3a AmlOffset 00026
<  psscope-0230 [02] ps_pop_scope          : Popped Op e30993c4 Args 0
<   psloop-0841 [01] ps_complete_op        : Popped scope, Op=e30993c4
<  dswexec-0581 [01] ds_exec_end_op        : Executing CreateObject
(Buffer/Package) Op=e30993c4
< dswstate-0336 [03] ds_obj_stack_push     : Obj=e6cbada0 [Integer]
State=e3096000 #Ops=1
---
> dswstate-0381 [02] ds_obj_stack_pop      : Count=1 State=e5e45800 #Ops=0
>   psloop-1085 [00] ps_parse_loop         : Opcode 0011 [Buffer] Op e5d763c8
Aml e7e88f68 AmlOffset 00054
>   psloop-1085 [00] ps_parse_loop         : Opcode 000A [ByteConst] Op e5d7b2c0
Aml e7e88f6a AmlOffset 00056
>  psscope-0230 [02] ps_pop_scope          : Popped Op e5d763c8 Args 0
>   psloop-0841 [01] ps_complete_op        : Popped scope, Op=e5d763c8
>  dswexec-0581 [01] ds_exec_end_op        : Executing CreateObject
(Buffer/Package) Op=e5d763c8
> dswstate-0336 [03] ds_obj_stack_push     : Obj=e6ccafc8 [Integer]
State=e5e45800 #Ops=1
140c142
< exresolv-0119 [04] ex_resolve_to_value   : Resolved object e6cbada0
---
> exresolv-0119 [04] ex_resolve_to_value   : Resolved object e6ccafc8
142c144
<   exdump-0494 [03] ex_dump_operand       : e6cbada0 Integer 0000000000000011
---
>   exdump-0494 [03] ex_dump_operand       : e6ccafc8 Integer 0000000000000011
144,148c146,150
< dswstate-0381 [02] ds_obj_stack_pop      : Count=1 State=e3096000 #Ops=0
<  psscope-0230 [02] ps_pop_scope          : Popped Op e30993f4 Args FFFFFFFD
<   psloop-0841 [01] ps_complete_op        : Popped scope, Op=e30993f4
<  dswexec-0581 [01] ds_exec_end_op        : Executing CreateObject
(Buffer/Package) Op=e30993f4
< dswstate-0336 [03] ds_obj_stack_push     : Obj=e6d29fb0 [Integer]
State=e3096000 #Ops=1
---
> dswstate-0381 [02] ds_obj_stack_pop      : Count=1 State=e5e45800 #Ops=0
>  psscope-0230 [02] ps_pop_scope          : Popped Op e5d763f8 Args FFFFFFFD
>   psloop-0841 [01] ps_complete_op        : Popped scope, Op=e5d763f8
>  dswexec-0581 [01] ds_exec_end_op        : Executing CreateObject
(Buffer/Package) Op=e5d763f8
> dswstate-0336 [03] ds_obj_stack_push     : Obj=e6d11fc8 [Integer]
State=e5e45800 #Ops=1
150c152
< exresolv-0119 [04] ex_resolve_to_value   : Resolved object e6d29fb0
---
> exresolv-0119 [04] ex_resolve_to_value   : Resolved object e6d11fc8
152c154
<   exdump-0494 [03] ex_dump_operand       : e6d29fb0 Integer 0000000000000002
---
>   exdump-0494 [03] ex_dump_operand       : e6d11fc8 Integer 0000000000000002
154,165c156,167
< dswstate-0381 [02] ds_obj_stack_pop      : Count=1 State=e3096000 #Ops=0
< dswstate-0244 [01] ds_result_stack_push  : Results=e636f21c State=e3096000
< dswstate-0199 [01] ds_result_push        : Obj=e6d29fb0 [Package]
State=e3096000 Num=1 Cur=0
<  dsutils-0131 [03] ds_do_implicit_return : Result e6d29fb0 will be implicitly
returned; Prev=e6cbac14
<  dsutils-0089 [03] ds_clear_implicit_retu: Removing reference on stale
implicit return obj e6cbac14
<  dsutils-0308 [03] ds_is_result_used     : Result of [Package] used by Parent
[Return] Op=e30993f4
<  psscope-0230 [02] ps_pop_scope          : Popped Op e3046340 Args 0
<   psloop-0841 [01] ps_complete_op        : Popped scope, Op=e3046340
< dscontrol-0247 [01] ds_exec_end_control_op: [RETURN_OP] Op=e3046340 Arg= 
(null)
<  dsutils-0089 [01] ds_clear_implicit_retu: Removing reference on stale
implicit return obj e6d29fb0
< dscontrol-0337 [01] ds_exec_end_control_op: Completed RETURN_OP
State=e3096000, RetVal=e6d29fb0
<  psscope-0230 [02] ps_pop_scope          : Popped Op e30463c0 Args FFFFFFFE
---
> dswstate-0381 [02] ds_obj_stack_pop      : Count=1 State=e5e45800 #Ops=0
> dswstate-0244 [01] ds_result_stack_push  : Results=e5ddf2d8 State=e5e45800
> dswstate-0199 [01] ds_result_push        : Obj=e6d11fc8 [Package]
State=e5e45800 Num=1 Cur=0
>  dsutils-0131 [03] ds_do_implicit_return : Result e6d11fc8 will be implicitly
returned; Prev=e6ccaf08
>  dsutils-0089 [03] ds_clear_implicit_retu: Removing reference on stale
implicit return obj e6ccaf08
>  dsutils-0308 [03] ds_is_result_used     : Result of [Package] used by Parent
[Return] Op=e5d763f8
>  psscope-0230 [02] ps_pop_scope          : Popped Op e5d7b340 Args 0
>   psloop-0841 [01] ps_complete_op        : Popped scope, Op=e5d7b340
> dscontrol-0247 [01] ds_exec_end_control_op: [RETURN_OP] Op=e5d7b340 Arg= 
(null)
>  dsutils-0089 [01] ds_clear_implicit_retu: Removing reference on stale
implicit return obj e6d11fc8
> dscontrol-0337 [01] ds_exec_end_control_op: Completed RETURN_OP
State=e5e45800, RetVal=e6d11fc8
>  psscope-0230 [02] ps_pop_scope          : Popped Op e5d7b3c0 Args FFFFFFFE
169c171
<  psparse-0507 [-1] ps_parse_aml          : Completed one call to walk loop,
AE_OK State=e3096000
---
>  psparse-0507 [-1] ps_parse_aml          : Completed one call to walk loop,
AE_OK State=e5e45800
171c173
<  psparse-0582 [-1] ps_parse_aml          : ReturnValue=e6d29fb0,
ImplicitValue=  (null) State=e3096000
---
>  psparse-0582 [-1] ps_parse_aml          : ReturnValue=e6d11fc8,
ImplicitValue=  (null) State=e5e45800
173,175c175,177
<  psxface-0351 [-2] ps_execute_method     : Method returned ObjDesc=e6d29fb0
<   exdump-0494 [-2] ex_dump_operand       : e6d29fb0 Package [Len 2]
ElementArray e3098dc0
<   exdump-0492 [-2] ex_dump_operand       :  [1] e6d29f84 Buffer length 11 @
e3098e20
---
>  psxface-0351 [-2] ps_execute_method     : Method returned ObjDesc=e6d11fc8
>   exdump-0494 [-2] ex_dump_operand       : e6d11fc8 Package [Len 2]
ElementArray e5e24520
>   exdump-0492 [-2] ex_dump_operand       :  [1] e6d11f98 Buffer length 11 @
e5e24580
177c179
<   0000: 82 0C 00 7F 00 00 00 00 00 00 00 00 00 00 00 79  ...............y
---
>   0000: 82 0C 00 01 10 00 00 B2 00 00 00 00 00 00 00 79  .......².......y
179c181
<   exdump-0492 [-2] ex_dump_operand       :  [1] e6cbada0 Buffer length 11 @
e3098de0
---
>   exdump-0492 [-2] ex_dump_operand       :  [1] e6ccafc8 Buffer length 11 @
e5e24540
181c183
<   0000: 82 0C 00 7F 00 00 00 00 00 00 00 00 00 00 00 79  ...............y
---
>   0000: 82 0C 00 01 08 00 00 B3 00 00 00 00 00 00 00 79  .......³.......y
185c187
< 82 0c 00 7f 00 00 00 00
---
> 82 0c 00 01 10 00 00 b2
188c190
< 82 0c 00 7f 00 00 00 00
---
> 82 0c 00 01 08 00 00 b3

------------------------------
/*
 * Intel ACPI Component Architecture
 * AML Disassembler version 20111123-32 [Dec  4 2011]
 * Copyright (c) 2000 - 2011 Intel Corporation
 *
 * Disassembly of /dosy/ssdt2, Sun Dec  4 02:32:57 2011
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000356 (854)
 *     Revision         0x01
 *     Checksum         0x47
 *     OEM ID           "DELL  "
 *     OEM Table ID     "MONTARA "
 *     OEM Revision     0x06040000 (100925440)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20020725 (537003813)
 */

DefinitionBlock ("/dosy/ssdt2.aml", "SSDT", 1, "DELL  ", "MONTARA ", 0x06040000)
{
    External (P80H)
    External (TZON)
    External (\_PR_.CPU0, DeviceObj)

    Scope (\_PR.CPU0)
    {
        Method (_PPC, 0, NotSerialized)
        {
            If (LEqual (TZON, 0x04))
            {
                Subtract (SizeOf (SPSS), One, Local0)
                Divide (Local0, 0x02, Local1, Local2)
                If (LNotEqual (Local1, Zero))
                {
                    Increment (Local2)
                }

                Store (0x04, P80H)
                Return (Local2)
            }

            If (LEqual (TZON, 0x05))
            {
                Subtract (SizeOf (SPSS), One, Local0)
                Store (0x05, P80H)
                Return (Local0)
            }

            Store (Zero, P80H)
            Return (Zero)
        }

        Name (PDC0, 0xF0000000)
        Method (_PDC, 1, NotSerialized)
        {
            CreateDWordField (Arg0, 0x08, CAP0)
            Store (CAP0, PDC0)
        }

        Method (_PCT, 0, NotSerialized)
        {
            If (LEqual (And (PDC0, One), One))
            {
                Return (Package (0x02)
                {
                    ResourceTemplate ()
                    {
                        Register (FFixedHW,
                            0x00,               // Bit Width
                            0x00,               // Bit Offset
                            0x0000000000000000, // Address
                            ,)
                    },

                    ResourceTemplate ()
                    {
                        Register (FFixedHW,
                            0x00,               // Bit Width
                            0x00,               // Bit Offset
                            0x0000000000000000, // Address
                            ,)
                    }
                })
            }
            Else
            {
                Return (Package (0x02)
                {
                    ResourceTemplate ()
                    {
                        Register (SystemIO,
                            0x10,               // Bit Width
                            0x00,               // Bit Offset
                            0x00000000000000B2, // Address
                            ,)
                    },

                    ResourceTemplate ()
                    {
                        Register (SystemIO,
                            0x08,               // Bit Width
                            0x00,               // Bit Offset
                            0x00000000000000B3, // Address
                            ,)
                    }
                })
            }
        }

        Method (_PSS, 0, NotSerialized)
        {
            If (LEqual (And (PDC0, One), One))
            {
                Return (NPSS)
            }
            Else
            {
                Return (SPSS)
            }
        }

        Name (NPSS, Package (0x08)
        {
            Package (0x06)
            {
                0x00000578,
                0x00002710,
                0x0000000A,
                0x0000000A,
                0x00000E1A,
                0x00000E1A
            },

            Package (0x06)
            {
                0x00000514,
                0x000025E4,
                0x0000000A,
                0x0000000A,
                0x00000D1A,
                0x00000D1A
            },

            Package (0x06)
            {
                0x000004B0,
                0x000024B8,
                0x0000000A,
                0x0000000A,
                0x00000C19,
                0x00000C19
            },

            Package (0x06)
            {
                0x0000044C,
                0x0000238C,
                0x0000000A,
                0x0000000A,
                0x00000B17,
                0x00000B17
            },

            Package (0x06)
            {
                0x000003E8,
                0x00002260,
                0x0000000A,
                0x0000000A,
                0x00000A16,
                0x00000A16
            },

            Package (0x06)
            {
                0x00000384,
                0x000020D0,
                0x0000000A,
                0x0000000A,
                0x00000915,
                0x00000915
            },

            Package (0x06)
            {
                0x00000320,
                0x00001FA4,
                0x0000000A,
                0x0000000A,
                0x00000814,
                0x00000814
            },

            Package (0x06)
            {
                0x00000258,
                0x00001D4C,
                0x0000000A,
                0x0000000A,
                0x00000612,
                0x00000612
            }
        })
        Name (SPSS, Package (0x08)
        {
            Package (0x06)
            {
                0x00000578,
                0x00002710,
                0x00000064,
                0x0000006E,
                0x00000083,
                0x00000000
            },

            Package (0x06)
            {
                0x00000514,
                0x000025E4,
                0x00000064,
                0x0000006E,
                0x00000183,
                0x00000001
            },

            Package (0x06)
            {
                0x000004B0,
                0x000024B8,
                0x00000064,
                0x0000006E,
                0x00000283,
                0x00000002
            },

            Package (0x06)
            {
                0x0000044C,
                0x0000238C,
                0x00000064,
                0x0000006E,
                0x00000383,
                0x00000003
            },

            Package (0x06)
            {
                0x000003E8,
                0x00002260,
                0x00000064,
                0x0000006E,
                0x00000483,
                0x00000004
            },

            Package (0x06)
            {
                0x00000384,
                0x000020D0,
                0x00000064,
                0x0000006E,
                0x00000583,
                0x00000005
            },

            Package (0x06)
            {
                0x00000320,
                0x00001FA4,
                0x00000064,
                0x0000006E,
                0x00000683,
                0x00000006
            },

            Package (0x06)
            {
                0x00000258,
                0x00001D4C,
                0x00000064,
                0x0000006E,
                0x00000783,
                0x00000007
            }
        })
    }
}

