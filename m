Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577Ab2EUUkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 16:40:22 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:39964
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758434Ab2EUUkT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 16:40:19 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VPS-9(zzc89bh1432N98dKzz1202hzzz2dh668h839h93fhd25hf0ah)
X-WSS-ID: 0M4E430-01-COV-02
X-M-MSG: 
Date: Mon, 21 May 2012 22:40:42 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "Luck, Tony" <tony.luck@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v24b] RAS: Add a tracepoint for reporting memory
 controller events
Message-ID: <20120521204042.GA14255@aftab.osrc.amd.com>
References: <4FB65D52.9060108@redhat.com>
 <20120518164014.GX20215@aftab.osrc.amd.com>
 <4FB6866E.7090503@redhat.com>
 <20120518185258.GE20215@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F192F1A33@ORSMSX104.amr.corp.intel.com>
 <20120518211211.GA26464@aftab.osrc.amd.com>
 <20120519092618.GC29991@aftab.osrc.amd.com>
 <4FBA5F59.5000604@redhat.com>
 <20120521160041.GJ3334@aftab.osrc.amd.com>
 <4FBA6FE8.50707@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <4FBA6FE8.50707@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 01:40:08PM -0300, Mauro Carvalho Chehab wrote:
> That's exactly what the latest version of this patch does.

Really, where is the address field?

+       TP_PROTO(const unsigned int err_type,
+                const unsigned int mc_index,
+                const char *error_msg,
+                const char *label,
+                const char *location,
+                const char *core_detail,
+                const char *driver_detail),


[ … ]

> Huh? Nobody said to add a bit to tell about the validity of another bit.
> 
> I'm saying is that a bitfield could be used to indicate that certain integer
> values (and not bits) are filled or not. Btw, MCE has it: depending on the
> MCE status registers, reading other registers may be needed to evaluate
> fully the error.

Bullshit, there'll be no bits showing the validity of other fields.

> > We're going to have single fields for EDAC-global valid values and leave
> > the driver-specific stuff lumped in one char * string.
> > 
> > Then, if a driver cannot specify sindrome or whatever, it simply DOESN'T
> > PUT IT IN THE STRING instead of adding validity bits.
> > 
> > [ … ]
> 
> Parsing strings that can be changed from Kernel versions and drivers is a 
> maintenance nightmare. Both I and Tony pointed it with different examples.

Bullshit, stop making up reasons to prove your point.

> >>> Which is basically what I'm suggesting for a couple of days now :-)
> >>>
> >>>        TP_PROTO(const unsigned int err_type,
> >>>                 const unsigned int mc_index,
> >>>                 const char *error_msg,
> >>>                 const char *label,
> >>>                 const char *location,
> >>>                 const char *detail)
> >>>
> >>> and I'm really not sure about err_type - this is an edac-specific define
> >>> and it means nothing outside the kernel so its string representation
> >>> could very well could be merged with error_msg and we can drop the ( ? :
> >>> ) ugliness in the tracepoint definition itself.
> >>
> >> All error management systems use a mandatory field for the error severity.
> > 
> > ... I'm pretty sure the defines you're exporting are not the same as
> > your error management systems require. So some kind of mapping is
> > still needed. Which shows that you're going to need to massage that
> > information in userspace after all.
> 
> Yes, field mapping is needed at the management systems, but this is not the
> point. It is not Kernel's task to help mapping fields inside userspace apps,
> but it is the task of a properly designed API to avoid userspace to guess about
> what the kernel is reporting.
> 
> A printk/sprintk-designed API, as you're proposing, requires userspace to guess
> what the events mean, with the help of a very careful designed parsing rules
> that needs to take into account every single EDAC driver (as the (s)printk message
> message will vary among them), and needs to be reviewed on every single new kernel
> version, as the (s)printk output can change among different Kernel versions. Even
> -stable versions might require changing the parsers, as a fixup patch might be
> changing the (s)printk arguments.

Enough with the crap already - now you're really desperately looking for
bogus arguments to prove your point.

We're going to have single fields for EDAC-global valid values and leave
the driver-specific stuff lumped in one char * string.


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

