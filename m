Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938Ab0LBSvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 13:51:44 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:53694 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390Ab0LBSvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 13:51:43 -0500
Date: Thu, 2 Dec 2010 19:51:23 +0100
From: Borislav Petkov <bp@amd64.org>
To: Florian Mickler <florian@mickler.org>
Cc: Tobias Karnat <tobias.karnat@googlemail.com>,
        Borislav Petkov <bp@alien8.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: edac_core: crashes on shutdown
Message-ID: <20101202185123.GI27263@aftab>
References: <20101201123921.GA15530@a1.tnic>
 <1291209888.12511.11.camel@Tobias-Karnat>
 <20101201143329.GB18074@a1.tnic>
 <1291225614.8646.4.camel@Tobias-Karnat>
 <20101201193508.GA4916@liondog.tnic>
 <1291280613.10626.22.camel@Tobias-Karnat>
 <20101202152106.GA29301@a1.tnic>
 <1291306872.3898.7.camel@Tobias-Karnat>
 <20101202170610.GE27263@aftab>
 <20101202191412.288b82f8@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101202191412.288b82f8@schatten.dmk.lab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 01:14:12PM -0500, Florian Mickler wrote:
> Yes. That should work. Once we stopped the workqueue and removed it
> from the global list, do we actually need to set it to OP_OFFLINE?

I think yes, because we seem to protect ourselves in the actual
edac_mc_workq_function() on exit, if we overlap the work items
cancellation with the execution of the delayed work at the same time on
a different cpu. Besides, it is a single assignment and it does cost us
almost nothing.

> Also 00740c585 did fix a hang in edac_mc.c... could this also happen
> in the edac_device_del_device/edac_pci_del_device functions?

Nope, because there we don't check ->op_state when we cancel the work
items in the respective _teardown() functions - we simply cancel them
unconditionally.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
