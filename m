Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932727Ab2FHN41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 09:56:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:44554 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932610Ab2FHN4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 09:56:23 -0400
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, mingo@elte.hu,
        ming.m.lin@intel.com, Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
In-Reply-To: <20120608135117.GB31359@aftab.osrc.amd.com>
References: <20120607071531.GA4849@quad> <1339064319.23343.13.camel@twins>
	 <CABPqkBQ+p5rcuxpXCTLMXPM+awAHhQ6mP9-WzVh5GWtn2GyfrA@mail.gmail.com>
	 <1339065932.23343.18.camel@twins>
	 <CABPqkBQ=tLXXsgvzQx+i01Owm4MM8m=6cEVVi4ab64gOiTTBYQ@mail.gmail.com>
	 <1339067757.23343.21.camel@twins> <20120608093513.GA22520@gmail.com>
	 <1339149613.23343.52.camel@twins> <1339161972.2507.13.camel@laptop>
	 <20120608135117.GB31359@aftab.osrc.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jun 2012 15:56:11 +0200
Message-ID: <1339163771.2507.18.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-08 at 15:51 +0200, Borislav Petkov wrote:
> 
> In these cases, you already have PEBS fixed but since you're not loading
> any ucode, you won't run intel_snb_verify_ucode().
> 
> So, you want to check for PEBS twice (and for all other features fixed
> by ucode and tested for earlier than the ucode loader, for that matter):
> 
> * once when perf inits
> 
> * twice, a bit later when the ucode loader has loaded something from
> userspace and the notifier corrects it. 


>  static __init void intel_sandybridge_quirk(void)
>  {
> +       intel_snb_verify_ucode();
> +       /*
> +        * we're still single threaded, so while there's a hole here,
> +        * you can't trigger it.
> +        */
> +       microcode_notifier(intel_snb_ucode_notifier);
>  }

Like that you mean?

