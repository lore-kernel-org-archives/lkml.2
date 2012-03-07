Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab2CGQXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 11:23:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754976Ab2CGQX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 11:23:29 -0500
Message-ID: <4F578B70.9080903@redhat.com>
Date: Wed, 07 Mar 2012 13:23:12 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] edac: Improve the comments to better describe the memory
 concepts
References: <1331120224-27420-1-git-send-email-mchehab@redhat.com> <20120307142411.GA26789@aftab>
In-Reply-To: <20120307142411.GA26789@aftab>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Boris,

Thanks for reviewing it! Comments and a reviewed version below.

Em 07-03-2012 11:24, Borislav Petkov escreveu:
> On Wed, Mar 07, 2012 at 08:37:04AM -0300, Mauro Carvalho Chehab wrote:
>> The memory terms changed along the time,
> 
> I think you mean something along the lines of: "Computer memory terminology has
> changed with time... "
> 
>> since when EDAC were originally written:
> 
> either "since EDAC drivers were originally written" or "since EDAC was
> originally written"
> 
>> new concepts were introduced, and some things have different
>> meanings, depending on the memory architecture.
>>
>> Better define those terms.
> 
> Better: "Improve the definition of all related terms."
> 
>>
>> As some concepts are different for memory controllers used by certain
>> memory stick types, add a per-memory type comment, and add a more verbose
>> description for each memory type.
> 
> Simplify: "Also, describe each memory type in a more detailed fashion."
> But, see my comment below.

Fixed, thanks!

> 
>> No functional changes. Just comments were touched.
>>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>> ---
>>  include/linux/edac.h |  182 +++++++++++++++++++++++++++++++++++++------------
>>  1 files changed, 137 insertions(+), 45 deletions(-)
>>
>> diff --git a/include/linux/edac.h b/include/linux/edac.h
>> index 055b248..96f996f 100644
>> --- a/include/linux/edac.h
>> +++ b/include/linux/edac.h
>> @@ -66,25 +66,91 @@ enum dev_type {
>>  #define DEV_FLAG_X32		BIT(DEV_X32)
>>  #define DEV_FLAG_X64		BIT(DEV_X64)
>>  
>> -/* memory types */
>> +/**
>> + * enum mem_type - memory types
>> + *
>> + * @MEM_EMPTY		Empty csrow
>> + * @MEM_RESERVED:	Reserved csrow type
>> + * @MEM_UNKNOWN:	Unknown csrow type
>> + * @MEM_FPM:		Fast page mode
>> + *			An old asyncronous memory technology, encapsulated as
>> + *			SIMM, popularly used between 1987-1995.
>> + * @MEM_EDO:		Extended data out
>> + *			Asynchronous memory technology used on early Pentium's
>> + *			(1995-1998).
>> + * @MEM_BEDO:		Burst Extended data out
>> + *			EDO memories with performance improvement gains.
>> + * @MEM_SDR:		Single data rate SDRAM
>> + *			First types of syncronous ram specified by JEDEC
>> + *			popular between 1998-2002. The JEDEC standards defined
>> + *			3 types of sticks: PC66, PC100 and PC133. There were
>> + *			also some non-official overclocked sticks like PC150
>> + *			and PC166.
>> + *			There are 3 pins for chip select: Pins 0 and 2 are
>> + *			for rank 0; pins 1 and 3 are for rank 1, if the memory
>> + *			is dual-rank.
>> + * @MEM_RDR:		Registered single data rate SDRAM
>> + * @MEM_DDR:		Double data rate SDRAM, used between 2002 and 2005.
>> + *			The JEDEC standards defined sticks PC1600, PC2100,
>> + *			PC2700 and PC3200. Non-official overclocked sticks
>> + *			also exists.
>> + *			On DDR memories, there are one or two channels. A
>> + *			single-channel mode means that one x72 ECC dimm is
>> + *			accessed, in order to provide 64 bits of data. On
>> + *			dual-channel mode, two dimm's are used simultaneously,
>> + *			in order to provide a 128 bits of data. The "cschannel"
>> + *			concept used on EDAC refers to such channel type.
>> + * @MEM_RDDR:		Registered Double data rate SDRAM
>> + *			This is a variant of the DDR memories.
>> + *			A registered memory has a buffer inside it, hiding
>> + *			part of the memory details to the memory controller.
>> + * @MEM_RMBS:		Rambus DRAM
>> + *			Rambus uses a high-speed multi-drop serial bus to
>> + *			communicate with each RDRAM chip, used on some
>> + *			machines between 2000-2002 (Pentium III and IV).
>> + * @MEM_DDR2:		DDR2 RAM, as described at JEDEC JESD79-2F.
>> + *			Those memories are labed as "PC2-" instead of "PC" to
>> + *			differenciate from DDR.
>> + * @MEM_FB_DDR2:	Fully-Buffered DDR2, as described at JEDEC Std No. 205
>> + *			and JESD206.
>> + *			A FB-DIMM channel consists of 14 unidirectional signal
>> + *			pairs (Northbound path) from the memories to the MC
>> + *			and 10 unidirectional signal pairs (Southbond path)
>> + *			from the MC to the DIMM's.
>> + *			those memories are x72 ECC DIMMs. Up to 8 DIMMs can
>> + *			be connected per channel. When used with 128 bits,
>> + *			two channels are needed. The grouping of those two
>> + *			channels is called "branch".
>> + * @MEM_RDDR2:		Registered DDR2 RAM
>> + *			This is a variant of the DDR2 memories.
>> + * @MEM_XDR:		Rambus XDR
>> + *			It is an evolution of the original RAMBUS memories,
>> + *			created to compete with DDR2. Weren't used on any
>> + *			x86 arch, but cell_edac PPC memory controller uses it.
>> + * @MEM_DDR3:		DDR3 RAM
>> + *			Those memories are labed as "PC3-" to differenciate
>> + *			from DDR and DDR2.
>> + * @MEM_RDDR3:		Registered DDR3 RAM
>> + *			This is a variant of the DDR3 memories.
>> + */
> 
> I don't think the kernel source should contain such verbose comments.
> Wikipedia contains much more info: http://en.wikipedia.org/wiki/DRAM
> which we simply cannot carry in comments even if we wanted to so best it
> would be if this enum only maps the actual enum names to the names on
> the wikipedia page so that interested entities can look them up. Then,
> the comment should contain the wikipedia URL, of course.

I'll simplify, and add a reference for the pertinent wiki pages. I'll 
preserve a few comments where what is there is more related to the edac 
implementation.

I would love to put at least the standard spec that defines each type,
but finding the right ones is time-consuming. Also, on some cases, there
are several related standards. I'll keep the ones I got, as it may help
developers to retrieve the needed information.

> 
>>  enum mem_type {
>> -	MEM_EMPTY = 0,		/* Empty csrow */
>> -	MEM_RESERVED,		/* Reserved csrow type */
>> -	MEM_UNKNOWN,		/* Unknown csrow type */
>> -	MEM_FPM,		/* Fast page mode */
>> -	MEM_EDO,		/* Extended data out */
>> -	MEM_BEDO,		/* Burst Extended data out */
>> -	MEM_SDR,		/* Single data rate SDRAM */
>> -	MEM_RDR,		/* Registered single data rate SDRAM */
>> -	MEM_DDR,		/* Double data rate SDRAM */
>> -	MEM_RDDR,		/* Registered Double data rate SDRAM */
>> -	MEM_RMBS,		/* Rambus DRAM */
>> -	MEM_DDR2,		/* DDR2 RAM */
>> -	MEM_FB_DDR2,		/* fully buffered DDR2 */
>> -	MEM_RDDR2,		/* Registered DDR2 RAM */
>> -	MEM_XDR,		/* Rambus XDR */
>> -	MEM_DDR3,		/* DDR3 RAM */
>> -	MEM_RDDR3,		/* Registered DDR3 RAM */
>> +	MEM_EMPTY = 0,
>> +	MEM_RESERVED,
>> +	MEM_UNKNOWN,
>> +	MEM_FPM,
>> +	MEM_EDO,
>> +	MEM_BEDO,
>> +	MEM_SDR,
>> +	MEM_RDR,
>> +	MEM_DDR,
>> +	MEM_RDDR,
>> +	MEM_RMBS,
>> +	MEM_DDR2,
>> +	MEM_FB_DDR2,
>> +	MEM_RDDR2,
>> +	MEM_XDR,
>> +	MEM_DDR3,
>> +	MEM_RDDR3,
>>  };
>>  
>>  #define MEM_FLAG_EMPTY		BIT(MEM_EMPTY)
>> @@ -162,8 +228,9 @@ enum scrub_type {
>>  #define OP_OFFLINE		0x300
>>  
>>  /*
>> - * There are several things to be aware of that aren't at all obvious:
>> + * Concepts used at the EDAC subsystem
>>   *
>> + * There are several things to be aware of that aren't at all obvious:
>>   *
>>   * SOCKETS, SOCKET SETS, BANKS, ROWS, CHIP-SELECT ROWS, CHANNELS, etc..
>>   *
>> @@ -172,36 +239,61 @@ enum scrub_type {
>>   * creating a common ground for discussion, terms and their definitions
>>   * will be established.
>>   *
>> - * Memory devices:	The individual chip on a memory stick.  These devices
>> - *			commonly output 4 and 8 bits each.  Grouping several
>> - *			of these in parallel provides 64 bits which is common
>> - *			for a memory stick.
>> + * Memory devices:	The individual DRAM chips on a memory stick.  These
>> + *			devices commonly output 4 and 8 bits each (x4, x8).
>> + *			Grouping several of these in parallel provides the
>> + *			number of bits that the memory controller expects:
>> + *			typically 72 bits, in order to provide 64 bits of ECC
>> + *			corrected data.
> 
> 					...in order to provide 64 bits + 8 bits
> 					   of ECC data.
> 
> 
> ECC checking and correction is done in the memory/DRAM controller.
> 
>>   *
>>   * Memory Stick:	A printed circuit board that aggregates multiple
>> - *			memory devices in parallel.  This is the atomic
>> - *			memory component that is purchaseable by Joe consumer
>> - *			and loaded into a memory socket.
>> + *			memory devices in parallel.  In general, this is the
>> + *			Field Replaceable Unit (FRU) that the final consumer
> 
> Linux is hopefully still not officially "sponsored" by a single company which
> knows only "customers" so let's change that to:
> 
> 					    ... (FRU) which gets replaced, in
> 					    the case of excessive errors.
> 
>> + *			cares to replace. It is typically encapsulated as DIMMs
> 
> 					... Most often it is also called DIMM (Dual Inline
> 					Memory Module).
> 
>>   *
>>   * Socket:		A physical connector on the motherboard that accepts
>> - *			a single memory stick.
>> + *			a single memory stick. Also called as "slot" on several
>> + *			datasheets.
> 
> I would change that name to "Memory Socket" because "socket" is most
> often used for the physical processor package connecting to the
> mainboard.
> 
>>   *
>> - * Channel:		Set of memory devices on a memory stick that must be
>> - *			grouped in parallel with one or more additional
>> - *			channels from other memory sticks.  This parallel
>> - *			grouping of the output from multiple channels are
>> - *			necessary for the smallest granularity of memory access.
>> - *			Some memory controllers are capable of single channel -
>> - *			which means that memory sticks can be loaded
>> - *			individually.  Other memory controllers are only
>> - *			capable of dual channel - which means that memory
>> - *			sticks must be loaded as pairs (see "socket set").
>> + * Channel:		A memory controller channel, responsible to communicate
>> + *			with a group of DIMM's. Each channel has its own
> 
> 					DIMMs.
> 
>> + *			independent control (command) and data bus, and can
>> + *			be used independently or grouped.
> 
> 							 with other channels.
>>   *
>> - * Chip-select row:	All of the memory devices that are selected together.
>> - *			for a single, minimum grain of memory access.
>> - *			This selects all of the parallel memory devices across
>> - *			all of the parallel channels.  Common chip-select rows
>> - *			for single channel are 64 bits, for dual channel 128
>> - *			bits.
>> + * Branch:		Not all memory controllers have it.
> 
> 			^^^ No need for that sentence.
> 
>> 			It is the highest
>> + *			hierarchy on a Fully-Buffered DIMM memory controller.
>> + *			Typically, it contains two channels.
>> + *			Two channels at the same branch can be used in single
>> + *			mode or in lockstep mode.
>> + *			When lockstep is enabled, the cache line is higher,
> 
> What does "the cache line is higher" mean? You wanna rather say "the
> cacheline is doubled"?
> 
>> + *			but it generally brings some performance penalty.
>> + *			Also, it is generally not possible to point to just one
>> + *			memory stick when an error occurs, as the error
>> + *			correction code is calculated using two dimms instead
> 
> 								DIMMs
> 
>> + *			of one. Due to that, it is capable of correcting more
>> + *			errors than on single mode.
> 
> 				 .. in ..
>> + *
>> + * Single-channel:	The data accessed by the memory controller is contained
>> + *			into one dimm only. E. g. if the data is 64 bits-wide,
> 
> 				 DIMM				    bits wide
> 
>> + *			the data flows to the CPU using one 64 bits parallel
>> + *			access.
>> + *			Typically used with SDR, DDR, DDR2 and DDR3 memories.
>> + *			FB-DIMM and RAMBUS use a different concept for channel,
>> + *			so this concept doesn't apply there.
>> + *
>> + * Double-channel:	The data size accessed by the memory controller is
>> + *			interlaced into two dimms, accessed at the same time.
> 
> 					    DIMMs
> 
>> + *			E. g. if the DIMM is 64 bits-wide (72 bits with ECC),
>> + *			the data flows to the CPU using a 128 bits parallel
>> + *			access.
>> + *

Fixed all the above.


>> + * Chip-select row:	This is the name of the DRAM signal used to select the
>> + *			DRAM chips to be used. It may not be visible by the
>> + *			memory controller, as some DIMM types have a memory
>> + *			buffer that can hide direct access to it from the
>> + *			Memory Controller.
> 

> No need for the FBDIMM reference - simply keep the original comment
> of single channel/dual channel width and that's it. You can add a
> sentence at the end of this definition stating that there are memory
> configurations/technologies which do not use chip selects or hide chip
> selects behind buffering logic.

The original comment is not true for some memory controllers:

- * Chip-select row:        All of the memory devices that are selected together
- *                 for a single, minimum grain of memory access.
- *                 This selects all of the parallel memory devices across
- *                 all of the parallel channels.  Common chip-select rows
- *                 for single channel are 64 bits, for dual channel 128
- *                 bits.

The 3-channel/4-channel Intel DDR2/DDR3 memory controllers (the 
non-FB-DIMM ones) have csrow pins on them, but they don't always
select all channels altogether, even when they're at the same csrow, 
as each channel (or channel pair) can work independently from the other
ones, and the memory controllers can interlace memory DIMMs on non-trivial
ways. 

I changed it to say, instead:
	This is the name of the DRAM signal used to select the
	DRAM ranks to be accessed. Common chip-select rows for 
	single channel are 64 bits, for dual channel 128 bits.
	It may not be visible by the memory controller, as some 
	DIMM types have a memory buffer that can hide direct
	access to it from the Memory Controller.


> 
>> 			On devices where it is visible, it
>> + *			selects the DIMM rank that it is accessed by the
>> + *			memory controller.
>>   *
>>   * Single-Ranked stick:	A Single-ranked stick has 1 chip-select row of memory.
>>   *			Motherboards commonly drive two chip-select pins to
>> @@ -214,8 +306,8 @@ enum scrub_type {
>>   *
>>   * Double-sided stick:	DEPRECATED TERM, see Double-Ranked stick.
>>   *			A double-sided stick has two chip-select rows which
>> - *			access different sets of memory devices.  The two
>> - *			rows cannot be accessed concurrently.  "Double-sided"
>> + *			access different sets of memory devices. The two
>> + *			rows cannot be accessed concurrently. "Double-sided"
>>   *			is irrespective of the memory devices being mounted
>>   *			on both sides of the memory stick.
>>   *
>> -- 
>> 1.7.8
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-edac" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 


-


[PATCHv2] edac: Improve the comments to better describe the memory concepts

The Computer memory terminology has changed with time since EDAC was 
originally written: new concepts were introduced, and some things have 
different meanings, depending on the memory architecture.

Improve the definition of all related terms.

Also, describe each memory type in a more detailed fashion.

No functional changes. Just comments were touched.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 include/linux/edac.h |  182 +++++++++++++++++++++++++++++++++++++------------
 1 files changed, 137 insertions(+), 45 deletions(-)

Index: new_edac/include/linux/edac.h
===================================================================
--- new_edac.orig/include/linux/edac.h
+++ new_edac/include/linux/edac.h
@@ -66,25 +66,64 @@ enum dev_type {
 #define DEV_FLAG_X32		BIT(DEV_X32)
 #define DEV_FLAG_X64		BIT(DEV_X64)
 
-/* memory types */
+/**
+ * enum mem_type - memory types. For a more detailed reference, please see
+ *			http://en.wikipedia.org/wiki/DRAM
+ *
+ * @MEM_EMPTY		Empty csrow
+ * @MEM_RESERVED:	Reserved csrow type
+ * @MEM_UNKNOWN:	Unknown csrow type
+ * @MEM_FPM:		FPM - Fast Page Mode, used on systems up to 1995.
+ * @MEM_EDO:		EDO - Extended data out, used on systems up to 1998.
+ * @MEM_BEDO:		BEDO - Burst Extended data out, an EDO variant.
+ * @MEM_SDR:		SDR - Single data rate SDRAM
+ *			http://en.wikipedia.org/wiki/Synchronous_dynamic_random-access_memory
+ *			They use 3 pins for chip select: Pins 0 and 2 are
+ *			for rank 0; pins 1 and 3 are for rank 1, if the memory
+ *			is dual-rank.
+ * @MEM_RDR:		Registered SDR SDRAM
+ * @MEM_DDR:		Double data rate SDRAM
+ *			http://en.wikipedia.org/wiki/DDR_SDRAM
+ * @MEM_RDDR:		Registered Double data rate SDRAM
+ *			This is a variant of the DDR memories.
+ *			A registered memory has a buffer inside it, hiding
+ *			part of the memory details to the memory controller.
+ * @MEM_RMBS:		Rambus DRAM, used on a few Pentium III/IV controllers.
+ * @MEM_DDR2:		DDR2 RAM, as described at JEDEC JESD79-2F.
+ *			Those memories are labed as "PC2-" instead of "PC" to
+ *			differenciate from DDR.
+ * @MEM_FB_DDR2:	Fully-Buffered DDR2, as described at JEDEC Std No. 205
+ *			and JESD206.
+ *			Those memories are accessed per DIMM slot, and not by
+ *			a chip select signal.
+ * @MEM_RDDR2:		Registered DDR2 RAM
+ *			This is a variant of the DDR2 memories.
+ * @MEM_XDR:		Rambus XDR
+ *			It is an evolution of the original RAMBUS memories,
+ *			created to compete with DDR2. Weren't used on any
+ *			x86 arch, but cell_edac PPC memory controller uses it.
+ * @MEM_DDR3:		DDR3 RAM
+ * @MEM_RDDR3:		Registered DDR3 RAM
+ *			This is a variant of the DDR3 memories.
+ */
 enum mem_type {
-	MEM_EMPTY = 0,		/* Empty csrow */
-	MEM_RESERVED,		/* Reserved csrow type */
-	MEM_UNKNOWN,		/* Unknown csrow type */
-	MEM_FPM,		/* Fast page mode */
-	MEM_EDO,		/* Extended data out */
-	MEM_BEDO,		/* Burst Extended data out */
-	MEM_SDR,		/* Single data rate SDRAM */
-	MEM_RDR,		/* Registered single data rate SDRAM */
-	MEM_DDR,		/* Double data rate SDRAM */
-	MEM_RDDR,		/* Registered Double data rate SDRAM */
-	MEM_RMBS,		/* Rambus DRAM */
-	MEM_DDR2,		/* DDR2 RAM */
-	MEM_FB_DDR2,		/* fully buffered DDR2 */
-	MEM_RDDR2,		/* Registered DDR2 RAM */
-	MEM_XDR,		/* Rambus XDR */
-	MEM_DDR3,		/* DDR3 RAM */
-	MEM_RDDR3,		/* Registered DDR3 RAM */
+	MEM_EMPTY = 0,
+	MEM_RESERVED,
+	MEM_UNKNOWN,
+	MEM_FPM,
+	MEM_EDO,
+	MEM_BEDO,
+	MEM_SDR,
+	MEM_RDR,
+	MEM_DDR,
+	MEM_RDDR,
+	MEM_RMBS,
+	MEM_DDR2,
+	MEM_FB_DDR2,
+	MEM_RDDR2,
+	MEM_XDR,
+	MEM_DDR3,
+	MEM_RDDR3,
 };
 
 #define MEM_FLAG_EMPTY		BIT(MEM_EMPTY)
@@ -162,8 +201,9 @@ enum scrub_type {
 #define OP_OFFLINE		0x300
 
 /*
- * There are several things to be aware of that aren't at all obvious:
+ * Concepts used at the EDAC subsystem
  *
+ * There are several things to be aware of that aren't at all obvious:
  *
  * SOCKETS, SOCKET SETS, BANKS, ROWS, CHIP-SELECT ROWS, CHANNELS, etc..
  *
@@ -172,36 +212,61 @@ enum scrub_type {
  * creating a common ground for discussion, terms and their definitions
  * will be established.
  *
- * Memory devices:	The individual chip on a memory stick.  These devices
- *			commonly output 4 and 8 bits each.  Grouping several
- *			of these in parallel provides 64 bits which is common
- *			for a memory stick.
+ * Memory devices:	The individual DRAM chips on a memory stick.  These
+ *			devices commonly output 4 and 8 bits each (x4, x8).
+ *			Grouping several of these in parallel provides the
+ *			number of bits that the memory controller expects:
+ *			typically 72 bits, in order to provide 64 bits +
+ *			8 bits of ECC data.
  *
  * Memory Stick:	A printed circuit board that aggregates multiple
- *			memory devices in parallel.  This is the atomic
- *			memory component that is purchaseable by Joe consumer
- *			and loaded into a memory socket.
- *
- * Socket:		A physical connector on the motherboard that accepts
- *			a single memory stick.
- *
- * Channel:		Set of memory devices on a memory stick that must be
- *			grouped in parallel with one or more additional
- *			channels from other memory sticks.  This parallel
- *			grouping of the output from multiple channels are
- *			necessary for the smallest granularity of memory access.
- *			Some memory controllers are capable of single channel -
- *			which means that memory sticks can be loaded
- *			individually.  Other memory controllers are only
- *			capable of dual channel - which means that memory
- *			sticks must be loaded as pairs (see "socket set").
- *
- * Chip-select row:	All of the memory devices that are selected together.
- *			for a single, minimum grain of memory access.
- *			This selects all of the parallel memory devices across
- *			all of the parallel channels.  Common chip-select rows
- *			for single channel are 64 bits, for dual channel 128
- *			bits.
+ *			memory devices in parallel.  In general, this is the
+ *			Field Replaceable Unit (FRU) which gets replaced, in
+ *			the case of excessive errors. Most often it is also
+ *			called DIMM (Dual Inline Memory Module).
+ *
+ * Memory Socket:	A physical connector on the motherboard that accepts
+ *			a single memory stick. Also called as "slot" on several
+ *			datasheets.
+ *
+ * Channel:		A memory controller channel, responsible to communicate
+ *			with a group of DIMMs. Each channel has its own
+ *			independent control (command) and data bus, and can
+ *			be used independently or grouped with other channels.
+ *
+ * Branch:		It is typically the highest hierarchy on a
+ *			Fully-Buffered DIMM memory controller.
+ *			Typically, it contains two channels.
+ *			Two channels at the same branch can be used in single
+ *			mode or in lockstep mode.
+ *			When lockstep is enabled, the cacheline is doubled,
+ *			but it generally brings some performance penalty.
+ *			Also, it is generally not possible to point to just one
+ *			memory stick when an error occurs, as the error
+ *			correction code is calculated using two DIMMs instead
+ *			of one. Due to that, it is capable of correcting more
+ *			errors than on single mode.
+ *
+ * Single-channel:	The data accessed by the memory controller is contained
+ *			into one dimm only. E. g. if the data is 64 bits-wide,
+ *			the data flows to the CPU using one 64 bits parallel
+ *			access.
+ *			Typically used with SDR, DDR, DDR2 and DDR3 memories.
+ *			FB-DIMM and RAMBUS use a different concept for channel,
+ *			so this concept doesn't apply there.
+ *
+ * Double-channel:	The data size accessed by the memory controller is
+ *			interlaced into two dimms, accessed at the same time.
+ *			E. g. if the DIMM is 64 bits-wide (72 bits with ECC),
+ *			the data flows to the CPU using a 128 bits parallel
+ *			access.
+ *
+ * Chip-select row:	This is the name of the DRAM signal used to select the
+ *			DRAM ranks to be accessed. Common chip-select rows for
+ *			single channel are 64 bits, for dual channel 128 bits.
+ *			It may not be visible by the memory controller, as some
+ *			DIMM types have a memory buffer that can hide direct
+ *			access to it from the Memory Controller.
  *
  * Single-Ranked stick:	A Single-ranked stick has 1 chip-select row of memory.
  *			Motherboards commonly drive two chip-select pins to
@@ -214,8 +279,8 @@ enum scrub_type {
  *
  * Double-sided stick:	DEPRECATED TERM, see Double-Ranked stick.
  *			A double-sided stick has two chip-select rows which
- *			access different sets of memory devices.  The two
- *			rows cannot be accessed concurrently.  "Double-sided"
+ *			access different sets of memory devices. The two
+ *			rows cannot be accessed concurrently. "Double-sided"
  *			is irrespective of the memory devices being mounted
  *			on both sides of the memory stick.
  *




