Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab1LISYz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 13:24:55 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:49020 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab1LISYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 13:24:54 -0500
Date: Fri, 9 Dec 2011 19:24:48 +0100
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@amd64.org>, LKML <linux-kernel@vger.kernel.org>,
        X86-ML <x86@kernel.org>, EDAC devel <linux-edac@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86, MCE: Drain mcelog buffer
Message-ID: <20111209182448.GA29629@gere.osrc.amd.com>
References: <1323353332-5671-1-git-send-email-bp@amd64.org>
 <1323353332-5671-3-git-send-email-bp@amd64.org>
 <0207C53569FE594381A4F2EB66570B2A018EFB7762@orsmsx508.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0207C53569FE594381A4F2EB66570B2A018EFB7762@orsmsx508.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 10:19:02AM -0800, Luck, Tony wrote:
> void mce_register_decode_chain(struct notifier_block *nb)
>  {
>  	atomic_notifier_chain_register(&x86_mce_decoder_chain, nb);
> +	drain_mcelog_buffer();
>  }
> 
> Won't this dump all the pended stuff to the *first* guy to
> register - but subsequent interested parties will still
> miss out?

Yeah,

this is currently assuming that we have one consumer per system. At
least this is the case on AMD: MCE decoder registers and decodes the
errors. It will pass a subset of the MCEs (DRAM ECCs) to amd64_edac for
additional massaging.

Do you see a usecase for multiple consumers?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
