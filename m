Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab0DUVFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 17:05:39 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:46091 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab0DUVFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 17:05:38 -0400
Date: Wed, 21 Apr 2010 23:05:34 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@elte.hu, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, Frank Arnold <frank.arnold@amd.com>
Subject: Re: [PATCH 4/5] x86, cacheinfo: Make L3 cache info per node
Message-ID: <20100421210534.GA31028@aftab>
References: <1271349663-16670-1-git-send-email-bp@amd64.org>
 <1271349663-16670-5-git-send-email-bp@amd64.org>
 <4BCF6425.7040908@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BCF6425.7040908@zytor.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, Apr 21, 2010 at 01:46:29PM -0700

> On 04/15/2010 09:41 AM, Borislav Petkov wrote:
> > +
> > +/* max 8 nodes on a system */
> > +static struct amd_l3_cache * __cpuinitdata l3_caches[8];
> > +
> 
> This makes me very nervous.  Where does this limit come from?  It
> appears completely arbitrary and seems like begging for problems in the
> future.

Right. So, we currently have a 3-bit field for the node id of each node,
in conjunction with the L3 cache this means one L3 cache per node. It is
located in F0x60[2:0]. This field is setup to the proper value by the
BIOS.

But yeah, I see your point. I could try initializing it dynamically
per system so that there are no out of bounds accesses. Let me cook up
something tomorrow.

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
