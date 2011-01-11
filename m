Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab1AKDkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 22:40:20 -0500
Received: from kroah.org ([198.145.64.141]:41680 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755326Ab1AKDj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 22:39:58 -0500
Date: Mon, 10 Jan 2011 19:39:07 -0800
From: Greg KH <greg@kroah.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4]  x86: early_quirk check all dev/func in domain 0
Message-ID: <20110111033907.GF9709@kroah.com>
References: <4D2A1382.7010407@kernel.org>
 <4D2AC6BF.3010907@kernel.org>
 <4D2BA8FE.9090204@kernel.org>
 <4D2BAA7B.3030800@kernel.org>
 <20110111010903.GE32585@kroah.com>
 <4D2BB684.3090109@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2BB684.3090109@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 05:46:44PM -0800, Yinghai Lu wrote:
> On 01/10/2011 05:09 PM, Greg KH wrote:
> > On Mon, Jan 10, 2011 at 04:55:23PM -0800, Yinghai Lu wrote:
> >>
> >> go with all buses instead of bus0.
> > 
> > Why?
> 
> in cause USB host controller is not on Bus0.
> 
> > 
> >> also only check header type on func0.
> > 
> > Why?
> 
> that is bug.
> 
> notice when there is 00:1a.0, 00:1a.1, 00:1a.2 00:1a.7
> 
> the quirk code will not be applied with 00:1a.2 and 00:1a.7
> 
> it will exit after checking 00:1a.1's header type.

Also, if this is a real bug, then just fix this in one patch, separate
from the other patches.  Don't do more than one thing per patch.

thanks,

greg k-h
