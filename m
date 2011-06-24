Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab1FXG7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 02:59:34 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:38949
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751916Ab1FXG7c convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 02:59:32 -0400
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jun 2011 02:59:32 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAEYzBE7L2T1e/2dsb2JhbAAMRhCxCcMmhi0ElneKVkk
X-IronPort-AV: E=Sophos;i="4.65,418,1304265600"; 
   d="scan'208";a="711918092"
Subject: Re: CPU Instantaneous Power Consumption
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Ben Nizette <bn@niasdigital.com>
In-Reply-To: <BANLkTimHRRJ0g6VejfR8o-a5i42Puag0XQ@mail.gmail.com>
Date: Fri, 24 Jun 2011 16:49:08 +1000
Cc: linux-kernel@vger.kernel.org, arjan@infradead.org
Content-Transfer-Encoding: 8BIT
Message-Id: <30509199-CB40-4F6F-9A3D-ED913DAC19DA@niasdigital.com>
References: <BANLkTimHRRJ0g6VejfR8o-a5i42Puag0XQ@mail.gmail.com>
To: pradeep hettiarachchi <pradeepmh@wayne.edu>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 21/06/2011, at 12:15 PM, pradeep hettiarachchi wrote:
> 
> 1) What is the DC-to-DC CPU regulator efficiency ?

Varies board to board.  North of 90% but if you want decent figures you're going to have to characterise this yourself I'd think

> 2) What is the relationship between TDP and input power to the CPU ?

Well all power that goes in and doesn't come out is dissipated!  Unless you can monitor all power that goes out you're not going to get good figures.  Given that most of the lines from the CPU are driving fairly high impedance buffers you can probably make some assumptions here, once again it depends how accurately you need this info

> 3) Do you suggest any other better method to calculate the
> instantaneous input power to the CPU ?

I think it'll be easier to just measure the TDP directly by embedding a good temp sensor in the heat sink and characterising the thermal inertia of the thing.  To do that characterisation you might use, for instance, a heater element with known power dissipation attached to some kind of controller that applies a known power waveform.

> (I can think of calculating accurate instantaneous CPU power as VID
> (corresponding Vcc) x CPU_current_from_regulator; but, how do I read
> instantaneous VID ?

If you can read CPU current from the reg, why can't you directly measure CPU voltage from the reg?

HTH.
	--Ben.

> Is there any MSR that I can instantly access to
> read VID ? (I think Intel has hidden theses details from system
> developer) )
> 
> Please help me to find answers to these questions.
> 
> 
> Sincerely,
> 
> Pradeep M. Hettiarachchi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

