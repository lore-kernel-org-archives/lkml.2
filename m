Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423Ab1ADN57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 08:57:59 -0500
Received: from canuck.infradead.org ([134.117.69.58]:36450 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab1ADN56 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 08:57:58 -0500
Subject: Re: [PATCH 4/7] perf: Check if HT is supported and enabled
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTima_wh1Nd2E-zQAcymmux1O0e1GzVEdnhLEMOo5@mail.gmail.com>
References: <1293464211.2695.104.camel@localhost>
	 <AANLkTimp9VgD4qhOVmq-k1Ckzti9eeV8pf6Jvt5YB6nx@mail.gmail.com>
	 <1293526288.2457.4.camel@minggr.sh.intel.com>
	 <1294052312.2016.50.camel@laptop> <4D222926.9010206@zytor.com>
	 <1294139419.2016.115.camel@laptop>
	 <AANLkTinGmgB7YhRjnsGMjj2knDuJ8XFps9oyW4+EGOr5@mail.gmail.com>
	 <1294148675.2016.139.camel@laptop>
	 <AANLkTima_wh1Nd2E-zQAcymmux1O0e1GzVEdnhLEMOo5@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 04 Jan 2011 14:58:21 +0100
Message-ID: <1294149501.2016.141.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 14:52 +0100, Stephane Eranian wrote:
> 
> Couldn't you simply over-provision, and then when the CPU is online, use my
> ht_enabled statement to figure out whether or not you need to handle the sharing
> issue? 

That's pretty much what Lin's latest does:

 X86_FEATURE_HT && smp_num_siblings > 1

shows the CPU is capable of HT and will allocate the needed resources.
