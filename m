Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab2CZKHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 06:07:34 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:35025 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423Ab2CZKHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 06:07:33 -0400
Message-ID: <4F703FB9.9020407@linux.vnet.ibm.com>
Date: Mon, 26 Mar 2012 15:36:49 +0530
From: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, acme@infradead.org,
        ananth@in.ibm.com, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        rostedt@goodmis.org
Subject: [RESEND]Re: [PATCH] perf - probe finder fails to resolve function
 name to address
References: <4F6AF410.1010400@linux.vnet.ibm.com> <4F6AFD92.4030603@linux.vnet.ibm.com> <4F6C721B.9060807@hitachi.com>
In-Reply-To: <4F6C721B.9060807@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032610-2398-0000-0000-000005522408
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing a coding style issue..

On 03/23/2012 06:22 PM, Masami Hiramatsu wrote:

> Hi,
> 
> (2012/03/22 19:23), Prashanth Nageshappa wrote:
>> probe finder fails to resolve valid function names into addresses for
>> functions which have more than one die entries in DWARF info.
>>
>> It is valid for DWARF info to contain more than 1 entries for a given
>> function name, where one entry corresponds to definition which has code
>> address/range attributes and remaining entries (which are only
>> declarations) does not have code address/range attributes.
>> (example: do_fork, sys_write, sys_wait4, sys_sync etc)
> 
> Hmm, I'd like to reproduce and see what happened on debuginfo in those cases.
> Could you tell me your environment or actual dwarf dump of those entries as below?
> 

$ uname -r
3.1.0-7.fc16.x86_64

$ sudo perf probe  do_fork
Failed to get entry address of do_fork.
  Error: Failed to add events. (-2)

$ readelf -wi /usr/lib/debug/lib/modules/3.1.0-7.fc16.x86_64/vmlinux | grep do_fork -A 16
    <2691f7>   DW_AT_name        : (indirect string, offset: 0x1b1e0): do_fork	
    <2691fb>   DW_AT_decl_file   : 3	
    <2691fc>   DW_AT_decl_line   : 2269	
    <2691fe>   DW_AT_prototyped  : 1	
    <2691fe>   DW_AT_type        : <0x2593d1>	
    <269202>   DW_AT_declaration : 1	
    <269202>   DW_AT_sibling     : <0x269225>	
 <2><269206>: Abbrev Number: 14 (DW_TAG_formal_parameter)
    <269207>   DW_AT_type        : <0x259284>	
 <2><26920b>: Abbrev Number: 14 (DW_TAG_formal_parameter)
    <26920c>   DW_AT_type        : <0x259284>	
 <2><269210>: Abbrev Number: 14 (DW_TAG_formal_parameter)
    <269211>   DW_AT_type        : <0x25b2b1>	
 <2><269215>: Abbrev Number: 14 (DW_TAG_formal_parameter)
    <269216>   DW_AT_type        : <0x259284>	
 <2><26921a>: Abbrev Number: 14 (DW_TAG_formal_parameter)
    <26921b>   DW_AT_type        : <0x25a1f3>	
--
    <4015fc>   DW_AT_name        : (indirect string, offset: 0x266d7): do_fork_idle	
    <401600>   DW_AT_decl_file   : 3	
    <401601>   DW_AT_decl_line   : 638	
    <401603>   DW_AT_prototyped  : 1	
    <401603>   DW_AT_low_pc      : 0xffffffff814a32bb	
    <40160b>   DW_AT_high_pc     : 0xffffffff814a32dd	
    <401613>   DW_AT_frame_base  : 1 byte block: 9c 	(DW_OP_call_frame_cfa)
    <401615>   DW_AT_GNU_all_call_sites: 1	
    <401615>   DW_AT_sibling     : <0x40165b>	
 <2><401619>: Abbrev Number: 91 (DW_TAG_formal_parameter)
    <40161a>   DW_AT_name        : (indirect string, offset: 0x10f8da): work	
    <40161e>   DW_AT_decl_file   : 3	
    <40161f>   DW_AT_decl_line   : 638	
    <401621>   DW_AT_type        : <0x3f96c9>	
    <401625>   DW_AT_location    : 0x7fb55	(location list)
 <2><401629>: Abbrev Number: 110 (DW_TAG_variable)
    <40162a>   DW_AT_name        : (indirect string, offset: 0x1109a7): c_idle	
--
    <679053>   DW_AT_name        : (indirect string, offset: 0x1b1e0): do_fork	
    <679057>   DW_AT_decl_file   : 25	
    <679058>   DW_AT_decl_line   : 2269	
    <67905a>   DW_AT_prototyped  : 1	
    <67905a>   DW_AT_type        : <0x66a9b5>	
    <67905e>   DW_AT_declaration : 1	
    <67905e>   DW_AT_sibling     : <0x679081>	
 <2><679062>: Abbrev Number: 12 (DW_TAG_formal_parameter)
    <679063>   DW_AT_type        : <0x66a872>	
 <2><679067>: Abbrev Number: 12 (DW_TAG_formal_parameter)
    <679068>   DW_AT_type        : <0x66a872>	
 <2><67906c>: Abbrev Number: 12 (DW_TAG_formal_parameter)
    <67906d>   DW_AT_type        : <0x66c935>	
 <2><679071>: Abbrev Number: 12 (DW_TAG_formal_parameter)
    <679072>   DW_AT_type        : <0x66a872>	
 <2><679076>: Abbrev Number: 12 (DW_TAG_formal_parameter)
    <679077>   DW_AT_type        : <0x66b877>	
--
    <723f0b>   DW_AT_name        : (indirect string, offset: 0x1b1e0): do_fork	
    <723f0f>   DW_AT_decl_file   : 4	
    <723f10>   DW_AT_decl_line   : 1476	
    <723f12>   DW_AT_prototyped  : 1	
    <723f12>   DW_AT_type        : <0x70caad>	
    <723f16>   DW_AT_low_pc      : 0xffffffff81056ee1	
    <723f1e>   DW_AT_high_pc     : 0xffffffff81057149	
    <723f26>   DW_AT_frame_base  : 1 byte block: 9c 	(DW_OP_call_frame_cfa)
    <723f28>   DW_AT_GNU_all_call_sites: 1	
    <723f28>   DW_AT_sibling     : <0x7244fd>	
 <2><723f2c>: Abbrev Number: 96 (DW_TAG_formal_parameter)
    <723f2d>   DW_AT_name        : (indirect string, offset: 0x146df): clone_flags	
    <723f31>   DW_AT_decl_file   : 4	
    <723f32>   DW_AT_decl_line   : 1476	
    <723f34>   DW_AT_type        : <0x70ca0d>	
    <723f38>   DW_AT_location    : 0x10db3b	(location list)
 <2><723f3c>: Abbrev Number: 96 (DW_TAG_formal_parameter)
--
    <33629b6>   DW_AT_name        : (indirect string, offset: 0x124058): run_do_fork_test	
    <33629ba>   DW_AT_decl_file   : 2	
    <33629bb>   DW_AT_decl_line   : 858	
    <33629bd>   DW_AT_prototyped  : 1	
    <33629bd>   DW_AT_inline      : 1	(inlined)
 <1><33629be>: Abbrev Number: 71 (DW_TAG_subprogram)
    <33629bf>   DW_AT_name        : (indirect string, offset: 0x123c3d): run_sys_open_test	
    <33629c3>   DW_AT_decl_file   : 2	
    <33629c4>   DW_AT_decl_line   : 867	
    <33629c6>   DW_AT_prototyped  : 1	
    <33629c6>   DW_AT_inline      : 1	(inlined)
 <1><33629c7>: Abbrev Number: 64 (DW_TAG_subprogram)
    <33629c8>   DW_AT_name        : (indirect string, offset: 0x123e9e): kgdbts_option_setup	
    <33629cc>   DW_AT_decl_file   : 2	
    <33629cd>   DW_AT_decl_line   : 985	
    <33629cf>   DW_AT_prototyped  : 1	
    <33629cf>   DW_AT_type        : <0x335570d>	
--
    <33651ea>   DW_AT_name        : (indirect string, offset: 0x12405c): do_fork_test	
    <33651ee>   DW_AT_decl_file   : 2	
    <33651ef>   DW_AT_decl_line   : 522	
    <33651f1>   DW_AT_type        : <0x33651d9>	
    <33651f5>   DW_AT_location    : 9 byte block: 3 30 87 a7 81 ff ff ff ff 	(DW_OP_addr: ffffffff81a78730)
 <1><33651ff>: Abbrev Number: 122 (DW_TAG_variable)
    <3365200>   DW_AT_name        : (indirect string, offset: 0x123c41): sys_open_test	
    <3365204>   DW_AT_decl_file   : 2	
    <3365205>   DW_AT_decl_line   : 540	
    <3365207>   DW_AT_type        : <0x33651d9>	
    <336520b>   DW_AT_location    : 9 byte block: 3 b0 88 a7 81 ff ff ff ff 	(DW_OP_addr: ffffffff81a788b0)
 <1><3365215>: Abbrev Number: 122 (DW_TAG_variable)
    <3365216>   DW_AT_name        : (indirect string, offset: 0x123b83): hw_breakpoint_test	
    <336521a>   DW_AT_decl_file   : 2	
    <336521b>   DW_AT_decl_line   : 558	
    <336521d>   DW_AT_type        : <0x3365167>	
    <3365221>   DW_AT_location    : 9 byte block: 3 30 8a a7 81 ff ff ff ff 	(DW_OP_addr: ffffffff81a78a30)

> 
> At least we must consider this lazy_line case. If I understand correctly,
> that can also affect find_probe_point_lazy(sp_die, pf);
> 
> If I find the different attribute, I'd like to add a checker function and
> filter it out at early step in this function.
> 

Based on the above comments I have redone the patch:

If die entries corresponding to declarations appear before definition
entry, probe finder returns error instead of continuing to look further
for a definition entry.

This patch ensures we reach to the die entry corresponding to the
definition and get the function address.

V2: A simpler solution based on Masami's suggestion.


Signed-off-by: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
---

 tools/perf/util/probe-finder.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 5d73262..d5914ee 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -963,10 +963,12 @@ static int probe_point_search_cb(Dwarf_Die *sp_die, void *data)
 	struct dwarf_callback_param *param = data;
 	struct probe_finder *pf = param->data;
 	struct perf_probe_point *pp = &pf->pev->point;
+	Dwarf_Attribute attr;

 	/* Check tag and diename */
 	if (dwarf_tag(sp_die) != DW_TAG_subprogram ||
-	    !die_compare_name(sp_die, pp->function))
+	    !die_compare_name(sp_die, pp->function) ||
+	    dwarf_attr(sp_die, DW_AT_declaration, &attr))
 		return DWARF_CB_OK;

 	/* Check declared file */


