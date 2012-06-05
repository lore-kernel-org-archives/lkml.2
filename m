Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094Ab2FENH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:07:29 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:36086 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab2FENH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:07:27 -0400
Date: Tue, 5 Jun 2012 15:07:52 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v29] RAS: Add a tracepoint for reporting memory
 controller events
Message-ID: <20120605130752.GE13495@aftab.osrc.amd.com>
References: <1338563258-13322-1-git-send-email-mchehab@redhat.com>
 <20120601152151.GC28216@aftab.osrc.amd.com>
 <4FC8E5C4.4080008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC8E5C4.4080008@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 12:54:44PM -0300, Mauro Carvalho Chehab wrote:
> +/*
> + * Default error mechanisms for Memory Controller errors (CE and UE)
> + */
> +TRACE_EVENT(mc_event,
> +
> +	TP_PROTO(const unsigned int err_type,
> +		 const char *error_msg,
> +		 const char *label,
> +		 const int error_count,
> +		 const u8 mc_index,
> +		 const s8 top_layer,
> +		 const s8 mid_layer,
> +		 const s8 low_layer,
> +		 unsigned long address,
> +		 const u8 grain_bits,
> +		 unsigned long syndrome,
> +		 const char *driver_detail),
> +
> +	TP_ARGS(err_type, error_msg, label, error_count, mc_index,
> +		top_layer, mid_layer, low_layer, address, grain_bits,
> +		syndrome, driver_detail),
> +
> +	TP_STRUCT__entry(
> +		__field(	unsigned int,	error_type		)
> +		__string(	msg,		error_msg		)
> +		__string(	label,		label			)
> +		__field(	u16,		error_count		)
> +		__field(	u8,		mc_index		)
> +		__field(	s8,		top_layer		)
> +		__field(	s8,		middle_layer		)
> +		__field(	s8,		lower_layer		)
> +		__field(	long,		address			)
> +		__field(	u8,		grain_bits		)
> +		__field(	long,		syndrome		)
> +		__string(	driver_detail,	driver_detail		)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->error_type		= err_type;
> +		__assign_str(msg, error_msg);
> +		__assign_str(label, label);
> +		__entry->error_count		= error_count;
> +		__entry->mc_index		= mc_index;
> +		__entry->top_layer		= top_layer;
> +		__entry->middle_layer		= mid_layer;
> +		__entry->lower_layer		= low_layer;
> +		__entry->address		= address;
> +		__entry->grain_bits		= grain_bits;
> +		__entry->syndrome		= syndrome;
> +		__assign_str(driver_detail, driver_detail);
> +	),
> +
> +	TP_printk("%d %s error%s:%s%s on memory stick %s (mc:%d location:%d:%d:%d address:0x%08lx grain:%d syndrome:0x%08lx%s%s)",

Just a minor nitpick:

       mcegen.py-3078  [019] .N..  6815.663058: mc_event: 1 Corrected error: amd64_edac on memory stick unknown memory (mc:0 location:3:1:-1 address:0x000007ba grain:2 syndrome:0x00001809)

It says "... on memory stick unknown memory... "

Can we make the printk proto like this:

	TP_printk("%d %s error%s:%s%s on %s (mc:%d location:%d:%d:%d address:0x%08lx grain:%d syndrome:0x%08lx%s%s)",

so that both

	"Corrected error on DIMMx..."

and

	"Corrected error on unknown memory..."

work semantically?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
