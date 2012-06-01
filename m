Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964875Ab2FAPV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 11:21:26 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:49563 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964820Ab2FAPVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 11:21:24 -0400
Date: Fri, 1 Jun 2012 17:21:51 +0200
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
Message-ID: <20120601152151.GC28216@aftab.osrc.amd.com>
References: <1338563258-13322-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338563258-13322-1-git-send-email-mchehab@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 12:07:38PM -0300, Mauro Carvalho Chehab wrote:
> + * Default error mechanisms for Memory Controller errors (CE and UE)
> + */
> +TRACE_EVENT(mc_event,
> +
> +	TP_PROTO(const unsigned int err_type,
> +		 const char *error_msg,
> +		 const char *label,
> +		 const int error_count,
> +		 const u8 mc_index,
> +		 const s8 layer0,
> +		 const s8 layer1,
> +		 const s8 layer2,

Btw, why are the layers still called layer[012] but differently below?
This is confusing.

Also, edac_mc_handle_error() should have the top/middle/lower layer arg
names too.

And also, why are the layers s8? Any reason for the signedness?

> +		 unsigned long address,
> +		 const int grain_bits,

This is an int here and a u8 below?

I was just about to befriend the idea of grain being u8 and accepting it
as a compromise.

Make it a u8 and cast it at the call sites of trace_mc_event instead.

> +		 unsigned long syndrome,
> +		 const char *driver_detail),
> +
> +	TP_ARGS(err_type, error_msg, label, error_count, mc_index,
> +		layer0, layer1, layer2, address, grain_bits, syndrome,
> +		driver_detail),
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

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
