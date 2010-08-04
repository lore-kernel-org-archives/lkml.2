Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab0HDSBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 14:01:53 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:43798 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751186Ab0HDSBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 14:01:51 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: TxArbZkVM1l0O00ON.ESuPy5DlExM75Q1WoV72nFvNh_h7U
 xF0QIkW8IcaziwZZHhzbx2IIK1fwNGjumvx0rOgKb0R._cpnWiO7Z07.qzcZ
 jDdV1q8cPBxO0wRT.ugFsSBvLesRM0YaFSwIIpgVvmtd84z4l.HOapfzZTq2
 JXEpAZPoUaGHUY_h63DInMKLHfb12XrPs09fab.goMiDuH0HQHxanbCV6x.e
 v
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 4 Aug 2010 13:01:48 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Peter Crosthwaite <peter.crosthwaite@petalogix.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        mpm@selenic.com, Michal Simek <michal.simek@petalogix.com>,
        "Edgar E. Iglesias" <edgar.iglesias@petalogix.com>,
        John Williams <john.williams@petalogix.com>
Subject: Re: Using Bootmem for large DMA buffers in the presence of the slab
  allocator
In-Reply-To: <AANLkTikRf6r4a=XhnOJswrzHRDTb8yvCuQjD2qnh5ETt@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1008041259440.11084@router.home>
References: <AANLkTimK4NhXasetA4ZeeCeGSGySRNm8n=UgT+1oY_2g@mail.gmail.com> <alpine.DEB.2.00.1008040951170.11084@router.home> <AANLkTikRf6r4a=XhnOJswrzHRDTb8yvCuQjD2qnh5ETt@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note also that allocating a 64M buffer will be difficult due to the
maximum allocation size restrictions of the page allocator.

You therefore have no choice but to allocate the memory at boot
time. Or (if you have control over the arch) increase the maximum
allocation unit (MAX_ORDER I believe).


