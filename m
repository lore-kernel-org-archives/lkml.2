Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941Ab1CDSUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 13:20:21 -0500
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:37388 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759891Ab1CDSUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 13:20:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=DtUhnTV1SpCd3IIDRTNM3MWly82jB4KfTPL6gFJO8vJKcP31lvyUA3SS2HP5/ZKnNSDePNUvFYg9AI0vtEGmv5BI0bY+NnuMRuLTUPVgNO7wa56Adx7fd5GZXwcBnce4;
Date: Fri, 4 Mar 2011 10:20:12 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2] x86: early_quirk check all bus/dev/func in domain 0
Message-ID: <20110304102012.3ef9e7b2@jbarnes-desktop>
In-Reply-To: <4D506EDC.2070609@kernel.org>
References: <4D506EDC.2070609@kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Feb 2011 14:14:52 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> When we have 00:1a.0, 00:1a.1, 00:1a.2, 00:1a.7
> Found only 00:1a.0, and 00:1a.1 get processed. and 00:1a.2 and 00:1a.7 get skipped.
> 
> We should only check header type on func0.
> Also should not bail out when have gap.
> 
> At last try to process bus 00 - 0xff instead of only bus 00.
> 
> -v2: check with VENDOR_ID instead of CLASS_DEVICE for invalid device.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

I need a much better changelog here.  It sounds (and looks) like the
patch is doing several things:
  - processing more than the first two functions on a device
  - processing the full set of busses in the first domain
  - checking for nonexistent devices

Why are you making these changes?  Do you have a system that needs
early quirks but violates the existing assumptions?  Can you apply a
standard quirk instead?

-- 
Jesse Barnes, Intel Open Source Technology Center
